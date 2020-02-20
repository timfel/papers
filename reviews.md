## REVIEW 1

### Overall evaluation 
SCORE: 2 (accept)

### TEXT:

> This paper describes a technique re-implemented in GraalVM to optimize
> the sizing of arrays at allocation time without having to grow and
> copy arrays often, as well as a technique to set the type of arrays in
> a dynamic language from the start to avoid costly transitions.  The
> authors present preliminary results on a real-world benchmark showing
> the promising of presizing arrays.
> 
> While the techniques explored in this paper aren't novel, they have
> the potential to benefit GraalVM.  I think this paper is definitely a
> good fit for discussion at MoreVMs.  The work is on-going and I am
> interested to hear more about the potential of these optimizations to
> improve performance and avoid the costly reallocations of arrays.  I'd
> love to see results with other benchmarks, as well as more analysis
> and results with pretransitioning. 
> 
> One thought is that you first need to actually show that allocation
> site has a good correlation with the end size of the list, or of the
> type of elements stored in the list.  As mentioned in the paper, if
> each list allocated at the allocation site has a wildly different
> size, this optimization will not help. 
> * [ ] See this previous paper for a reference that measures the
> homogeneity of allocation sites with respect to write operations:
> S. Akram, J.B. Sartor, K.S. McKinley, and L. Eeckhout, "Crystal
> Gazer: Profile-Driven Write-Rationing Garbage Collection for Hybrid
> Memories," ACM International Conference on Measurement and Modeling
> of Computer Systems (SIGMETRICS), 2019.
> 
> * [x] What are storage strategies mentioned in the introduction?
> The text is vague.  Since they are explained later, a forward
> reference would make it clearer.
> 
> * [x] “the evaluation is only anecdotally” -> should be “anecdotal”
> 
> * [ ] In Section 2, it would have been nice to hear what the previous work’s
> general conclusions were regarding pretransitioning. 

Erinnere ich mich richtig, dass es auch Chrome wieder rausgeflogen
ist? Oder war das was anderes? 
Bzw. geht es eher um die Schlußfolgerungen, die im Paper stehen?
 
> Why do you need all of this information: “The amount of elements the
> array contains at most, at least, and on average”?  Wouldn’t you just
> presize to the maximum?  
> * [x] Ah, you answer these questions later in the
> paper, but it was confusing at the time of reading.  
> * [x] And why do you need to know if most operations are read or
> write?  
> Also, the text mentions you can’t coordinate with the garbage
> collector, but you collect this information: “The size of the array
> when it is garbage collected, including actual size and allocated
> but empty space”.
> * [x] First do you really collect this information?  Second, do you use it?
> 
> * [ ] You mention optimization potential, but did you measure any extra
> allocation removal because of your naive strategy?

War das Allocation removal eine gut begründete Vermutung, oder
haben wir das mal im IGV (oder ähnlichem) beobachtet? 
Wenn ich das noch messen möchte, wie würde ich das am besten
anstellen?

> * [x] In Section 6.4, this part is confusing: “Hence, we only
> increase the presize if the current size has been exceeded 8 times.”
> If the starting size is 10, but the array only grows to 70, then you
> don’t give it a presize?
> 
> * [ ] I didn’t understand the naive strategy with shrinking.  Are you also
> monitoring delete operations?  Did you just play with the
> growth/resizing factor, and never try to shrink the list?  This might
> be good in conjunction with an initial list size equal to the average
> or median.

Ich merke gerade, dass ich mich daran gar nicht mehr richtig erinnern
kann. Warum bekommen wir jeh mit, ob eine Liste zu groß ist? Wenn sie
mit der Presize angelegt wird, bekommen wir ja nie ein append auf
einer kleineren Liste.
Also schon, append wird ja in jedem Fall gerufen wenn neue Elemente
hinzugefügt werden. Wir könnten sehen wie groß bei jedem append die
Liste gerade ist und könnten daher auch wieder Schrumpfen. Aber wir
gucken ja nicht auf die Length, sonder auf die Capacity der Liste. Die
sollte ja eigentlich von der Presize vorgegeben sein und damit würde
wir von da an nie kleinere Listen sehen.


> 
> It would be nice to compare average and median in regards to performance.
> 
> * [ ] (Für den Vortrag?) I only see presizing results, what about
> pretransitioning?  And with pretransitioning, would you then turn
> off any dynamic transitioning and leave the list only at the storage
> strategy it is given at its allocation time?  It would be nice to
> see a graph like Figure 1, but summarizing the number of storage
> strategies each allocation site/list had over time.
> 
> * [x] Experimenting with other benchmarks is mentioned twice in Section 7.
> 
> * [ ] (Für den Vortrag?) Extra thought: as mentioned by another
> reviewer, **I think it would be good to explore some sort of optimal
> sizing plan given all the gathered profile data.  Does the array
> spend most of its time at size X, even if it grows up to 5000 at the
> end of the program?  Then the optimal pre-size could be X.  Is the
> benchmark small enough to determine the size that each array grows
> to and stays the longest at?**



## REVIEW 2

### Overall evaluation 
SCORE: 2 (accept)

### TEXT:

> This paper discusses pre-sizing of arrays in the context of a Graal-based
> runtime, where the memory manager is not able to be modified. The authors
> investigated the distribution of the sizes of arrays allocated at each
> allocation site. They also compared several strategies to decide the
> sizes to be allocated at each allocation site.
> Though pre-transitioning is also mentioned, no evaluation is presented.
> 
> Comments for authors:
> This work is interesting for presentation at the workshop. The topic
> of the work is important. The authors provided useful experimental results.
> 
> The authors argue that it is difficult to investigate the final sizes
> of arrays without accessing GC. I think, however, it would be possible
> if all the array-expanding and -shrinking operations were instrumented.
> For example, if the size of an array is being changed from X to Y, we
> could reduce the count for the size X and increase that of Y.

Bin mir nicht sicher ob ich das richtig verstehe. Ist das im
wesentliche die Idee, dass wir alle Größen mitschreiben (um median
oder so zu berechnen) nur mit der Anpassung, dass wir beim wachsen den
entsprechenden kleineren Eintrag in der Liste löschen?
 
> Nevertheless, the authors investigation of the distribution of the sizes of
> arrays in section 6.2 is useful to understand the distribution of the sizes
> of live arrays. As the authors pointed out, using the largest size would
> consume too much memory. I also think using final sizes of arrays still uses
> too much memory in the case where arrays are expanded almost at the end
> of their lives. This distribution of live arrays would be useful to decide
> the target sizes of pre-sizing.
> 
> * [ ] I think the author could discuss the ideal target sizes of pre-sizing.

Das diskutieren wir schon, schließlich ist das die RQ und wir sagen
explizit "While finding an optimal solution remains an open question,
we discuss what we have found so far in section 6", da wir ja nicht
die ideale Größe kennen. 

> * [x] Although the authors presented three strategies to decide the target
> sizes, the first two of them do not show the goal of the sizes
> (and even what sizes were obtained by the strategy).
> 
> * [ ] (Für Vortrag!) I also think it would be interesting to investigate the trade-off between
> the sizes and memory consumption directly: how much the memory consumption
> is against the sizes of pre-sizing?
> 
> * [ ] (Megamorphic ist auf jeden Fall eine wichtige Idee/Parallele)
> It would be useful to make a threshold of the distribution to give
> up pre-sizing for an allocation site as it is **megamorphic**.



## REVIEW 3 

### Overall evaluation 
SCORE: 0 (borderline paper)

### TEXT:

> This paper describes some work on implementing some previously
> published optimizations around storage strategies for arrays --
> presizing and pretransitioning -- in a context where GC-time feedback
> is not available. It describes some initial experiments with
> interpreter-side allocation site profiling in GraalVM-hosted
> languages. The results so far, on the DeltaBlue benchmark, are mixed
> -- a speedup (37% on one benchmark) is available but only at a large
> cost (200% or 100% -- reporting is confused) in memory.
> 
> I was already familiar with storage strategies work (in outline), but
> some readers might not be. A diagram would go a long way to conveying
> the idea without using too much time or space.

Storage Strategies erkläre ich nur oberflächlich, da hat er recht,
dass man das besser erklären könnte. Egal ob Diagramm oder Text stellt
sich aber die Frage, was ich dafür weglasse. Wie wichtig findet ihr
hier eine bessere Erklärung?
	
> The current paper doesn't really make clear its idea. It is something
> about doing the usual optimizations (presizing, pretransitioning) from
> profiling information gathered only during interpretation time, not at
> GC time. The basis of the work is that it is proceeding on GraalVM
> which does not make it possible to gather the information at GC time
> as the Memento Mori work had done on V8.
> 
> * [x] So, a high-level comment: the *essential novelty* of the approach
> described in the paper is buried, rather than explicit. This can
> easily be fixed.
>
> * [x] Also, a question: why is it good to avoid the GC-time approach? Is
> this just a case of "we don't want to get our hands dirty modifying
> the GC"? Perhaps there are better arguments in terms of
> "accessibility" in the sense of Maxine, e.g. if the GC is buried in
> Hotspot C++ code. In any case, this needs articulating.
>
> More generally, the writing is not great, although it can be fixed up
> without too much effort. I've put detailed comments below.
> 
> * [x] When first mentioning (line 273) "during interpretation", it's
> important to explain when/how these language impls transition from
> interpreted to compiled. This makes a huge difference to how much
> information may be gathered, and hence to the feasibility of sensible
> optimizations.
>
> Overall I did not find the results as promising as the authors
> did. Time/memory trades are often available, especially around storage
> strategies. Exposing a trade of this shape, where the memory penalty
> is severe, does not seem very noteworthy. However, the experiments so
> far are quite preliminary, so there is still reason to continue the
> investigation, and I think the topic is a good one for the workshop.
>
> Detailed comments:
> 
> - [x] 77: "programmers perspective" => "programmer's perspective"
> - [x] 80: "Beyond that" -- beyond what? Perhaps delete these words.
> - [x] 89: "shorthand" -- doesn't seem like the right word
> - [x] 91: "But our findings are applicable" -- delete the "but", and say "potentially applicable" (do you *really* know?)
> - [x] 109: "time," -- comma should be semicolon or dash
> - [x] 110: delete "thus"
> - [x] 112: "added to improve" => "which, in return, improves..."
> - [ ] 132: why are mementos short-lived? why are they objects? It seems the basic idea is to remember some extra data over the lifetime of an object, so that it can be mapped back to its allocation site at GC time

Okay, das ist nicht offensichtlich... Aber für Details kann man ja das
original Paper lesen, oder? Platz ist eh schon knapp.

> - [x] 137: "Essentially improving" -- this sentence needs a verb. "This improves" perhaps.
> - [x] 143: It's clunky to spend this time talking about pretenuring and then abruptly move on. Perhaps instead delete "However, the" and start a new paragraph: "Two other..."
> - [x] 146: "anecdotally" => "anecdotal"
> - [x] 163 and elsewhere: "amount" => "number". Discrete quantities come in numbers, not amounts. This substitution needs to be applied in many places in the text.
> - [x] 175: "whose sizes stabilize" -- this is unclear, because there are two dimensions of stability (at least). One is a single array object's size stabilizing. Another is *the sizes reached by arrays allocated at a given allocation site* stabilizing, in aggregate, over time. Which do you mean? "Both" would be a possible answer.
> - [x] 207: "object" and "empty" strategies need explaining somewhere
> - [x] 220: "unlikely and sub-optimal" seems redundant. If the net-gain scenario is unlikely, the practice is suboptimal by definition.
> - [x] 270: "payed" => "paid"
> - [x] 280: "actual size and allocated but empty space" -- I wasn't clear what counted as "actual" size. Maybe just "object size, and how much of this was empty"?
> - [x] 299: "build" => "built"
> - [x] 300: is the point here that only an allocation *site*, not an allocating *call chain*, is available?
> - [x] 308--312: this paragraph goes awry, at least from the word "led" onwards -- suggest rewriting
> - [x] 338: "like 32 and 360" => like *lines* 32 and 360 (otherwise you're saying that 32 and 360 are especially stable numbers)
> - [x] 340: "bottom heavy" => "bottom-heavy"
> - [x] 371: "a too large one" => "too large a presize"
> - [x] 399: "with disregard for" => "without regard for"
> - [x] 402: "factor of 8" -- this is confusing because 8 is a count, not a factor. Clarify that it means "on 8 occasions" and just call it an "inhibit count" or similar
> - [x] 410: this says "factor of 2" suggesting 100% increase, but on line 444 you say 200% increase. Which is it?
> - [x] 429: "average" means "arithmetic mean"? A median is still an "average"
> - [x] 429: "to large" => "too large"

