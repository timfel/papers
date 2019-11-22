### MoreVMs Paperidee auf Basis von [Memento Mori](http://dx.doi.org/10.1145/2754169.2754181)
#### Informationen die interessant wären zu profilen:
- Wie oft wächst die Liste?
- Um wieviel wächst die Liste im Schnitt, maximal, minimal? (Also
  reales wachsen, wieviele Elemente hat die Liste am Ende?)
- Wie groß ist die Liste am Ende (was ist das Ende? Compile time? GC?)?
- Welchen Typ/Typen hat die Liste?
- Sortierung?
- Wie wird sie am meisten verwendet? Hauptsächlich lesend oder schreibend? 
#### Stellschrauben für Performance / Tradeoffs:
- Initiale größe / preallozierung
- Anfangsstrategie (anstelle von Empty vielleicht Integer)
- Wachstumsrate:
	- Bei 50/50 Branch mit Listengröße 1 oder 1000 wäre vielleicht
	preallozieren mit Größe 1 und wachsen mit Faktor 10 das Optimum?
#### Weitere Ideen
- Optimierungen nicht nur für Listen, auch für Dictionaries
  - Leeres Dict == Liste, Dict mit Integer keys == Array, etc
- Was wäre mit einer Liste, die immer nach dem einfügen sortiert wird?
  Könnte man bei der gleich sortiert einfügen? Sorted Strategy?
	  - Das erste mal wenn `sort()` auf der Liste gerufen wird, wird
        sie sortiert und in eine *sorted* Strategy gepackt, von da an
        wird sortiert eingefügt.
- Escape analysis für Arrays (wird ab bestimmter Größe in Graal nicht
  gemacht)
- Was ist, wenn die Liste wie ein Dict verwendet wird? Könnte man
    das im Hintergrund rausbekommen/umstellen?
		
#### Paper - Memento Mori: Dynamic Allocation-Site-Based Optimizations
- Mementos sind kurzlebige Objekte, die beim ersten GC
  wegfliegen. Davor speichern sie (u.a.) wo das Objekt hinter dem sie stehen
  alloziert wurde.
Wird für drei Optimierungen genutzt:
1. Pretenuring
   - Hauptoptimierung. Objekte die mit hoher Wahrscheinlichkeit
     langlebig sind werden direkt im Speicherbereich der alten
     Generation alloziert
2. Pretransitioning
	- Bessere Vorauswahl der StorageStrategy auf Basis der vorherigen
     Transitionen
	- Allerdings gibt es da nicht viele in JavaScript:
		* SmiElements (small int?)
		* DoubleElements
		* Elements 
		+ Alle nochmal mit Holey für Listen aus denen Elemente
          entfernt wurden (JS Eigenheit)
	- Hauptsächlich wird es gemacht um Transitionen von Smi->Double
      und Double->Elements zu vermeiden, die sind teuer (32bit int ->
      64bit Double; 64bit Double -> boxed Double)
3. Presizing
	- Eher afterthought (Prototyped within a day)
	- Kommt nicht in der Evaluierung oder Related Work vor
	- Einzige Evaluierung:
	``` 
		Encouragingly, our prototype was able to learn the optimum
	allocation size for the important sites in the very sensitive
	DeltaBlue benchmark without prior knowledge, and preliminary
	measurements indicated a slight decrease in the maximum overall
	heap size in Octane, with no other performance loss. 
	```
	- Scheinen sie auch später nicht ausgebaut zu haben... Vielleicht
      weil es primär GC Leute sind?
	- Die Citations auf das Paper reden alle über Pretenuring und manchmal
      über Pretransitioning. Habe keine Referenz auf Presizing gefunden.

### Erster Prototyp
- Beispiel aus 3.2 in Smalltalk nachbauen
  - Nur Transitioning ohne Branches, schauen ob man ähnliches Szenario
    bekommt
- Size overhead messen
- Was passiert eigentlich in Chrome gerade bei Branching?
- 4 Seiten für MoreVMs bis Januar?
- Größerer Prototyp mit Benchmarks für ICOOOLPS?

#### GraalSqueak Findings
Branch: https://github.com/hpi-swa/graalsqueak/tree/wip/memento

##### Insights / Learnings
Squeak arrays are too low-level for the optimization to be effective. Splitting cannot be forced in the compiler, but it's necessary for the optimization. Otherwise, it leads to too many arrays to be generic (and therefore a *decrease* in performance).
Also, elimination of resizing does not apply. Arrays are of fixed size in Smalltalk. `OrderedCollection` and `Dictionary` use arrays, but are implemented in the language (unlike JS, Python, etc.).

##### Benchmark results

- Significant slowdown in Queens and Havlak
- Insignificant speedups in DeltaBlue

![image](https://user-images.githubusercontent.com/2368856/68404593-169bb900-017f-11ea-9181-457e3567f2be.png)


#### GraalPython Findings
Branch: https://github.com/johenning/graalpython/tree/overallocate (Commit 940a616)

##### Benchmark results
- Significant speed-up in DeltaBlue
- Significant increase in memory consumption


| Benchmark size | Average performance increase | Memory increase (percent) | Maximum memory usage (before/after)| 
| ----- | ----- | -----| ---- |
| 1000 | 10%-20% | +30% | 888.128 KB / 1.178.832 KB |
| 5000 | 30%-100% | +200% | 1.723.276 KB / 4.463.428 KB |
| 10.000 | - | - | 1.768.720 KB / **java.lang.OutOfMemoryError** |

##### Data (`mx --dy /compiler,/tools python --python.OverallocateLiteralLists=true deltablue.py 30 0 1000` and script:
```python
import numpy

at1k = [2.802, 1.779999, 1.793999, 1.775, 1.582999, 1.691999, 1.539, 1.322999, 0.731999, 0.519999, 0.627, 0.496999, 0.437, 0.409, 0.338, 0.412999, 0.473, 0.389, 0.188999, 0.227999, 0.181999, 0.121999, 0.187999, 0.128999, 0.134, 0.107, 0.107, 0.095, 0.14, 0.098999] # Overallocate=True results in seconds with size=1000

af1k = [2.654, 1.858999, 1.732999, 1.602999, 1.628, 1.504999, 1.349999, 1.281, 0.996999, 0.559999, 0.541, 0.7, 0.549999, 0.595999, 0.373, 0.351, 0.362999, 0.363999, 0.455, 0.473999, 0.398, 0.352999, 0.256, 0.321, 0.315999, 0.332999, 0.296, 0.332999, 0.272, 0.436]# Overallocate=False results in seconds with size=1000

at5k = [10.646999, 8.65, 3.726, 3.348999, 3.303999, 1.791, 4.605, 1.848, 0.653, 0.463, 0.767999, 0.535, 0.564, 0.497999, 0.375, 0.528, 0.490999, 0.541, 0.374, 0.532999, 0.456, 0.529999, 0.348, 0.532, 0.373, 0.513, 0.383, 0.545, 0.437999, 0.554999] # Overallocate=True results in seconds with size=5000

af5k = [8.008, 7.694, 4.220999, 2.821, 2.569, 2.905999, 2.146999, 1.779999, 1.911999, 1.891999, 1.566999, 1.705, 2.020999, 1.43, 1.864, 1.421, 1.694, 1.529, 1.636, 1.545999, 1.345999, 1.774, 1.470999, 1.288, 1.743, 1.427999, 1.33, 1.786, 1.46, 1.296] # Overallocate=False results in seconds with size=5000

def compare(at, af):
    print("\tAverage time Overallocate=True: %f seconds" % (numpy.average(at)))
    print("\tAverage time Overallocate=False: %f seconds" % (numpy.average(af)))
    print("\tAverage Speedup with True: %f times" % (numpy.average(af)/numpy.average(at)))
    print("\tAverage Speedup without Warmup (excluding first 4): %f times" % (numpy.average(af[4:])/numpy.average(at[4:])))
    print("\tAverage Slowdown of Warmup (first 4 only): %f times" % (numpy.average(af[:4])/numpy.average(at[:4])))
    print("\tSpeedup best-case: %f times" % (min(af)/min(at)))

print("1k results:")
compare(at1k, af1k)
print("5k results:")
compare(at5k, af5k)
```
Prints:
```
1k results:
        Average time Overallocate=True: 0.694766 seconds
        Average time Overallocate=False: 0.775033 seconds
        Average Speedup with True: 1.115530 times
        Average Speedup without Warmup (excluding first 4): 1.213521 times
        Average Slowdown of Warmup (first 4 only): 0.962949 times
        Speedup best-case: 2.694737 times
5k results:
        Average time Overallocate=True: 1.630533 seconds
        Average time Overallocate=False: 2.242833 seconds
        Average Speedup with True: 1.375521 times
        Average Speedup without Warmup (excluding first 4): 1.975737 times
        Average Slowdown of Warmup (first 4 only): 0.862430 times
        Speedup best-case: 3.701149 times
```


