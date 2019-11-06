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
	Encouragingly, our prototype was able to learn the optimum allocation size for the important sites in the very sensitive DeltaBlue benchmark without prior knowledge, and preliminary measurements indicated a slight decrease in the maximum overall heap size in Octane, with no other performance loss. 
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
- Größerer Prototyp mit Benchmarks für ICOOLPS?
