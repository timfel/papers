    What is the research problem?

    Adapt the introduction and abstract to reflect the lack of current tools and
    presents more clearly the new contributions.

We have adapted the abstract and introduction to more clearly state that the
problem is about code editing and thus the static tooling aspects, and that both
RPython and Truffle already provide language independent run-time tools for
debugging, profiling, and coverage information. We have also included a mention
of the basic features we aim to support, such as syntax errors, references and
declarations, and completions. Finally, we now also make clearer that we don't
intend our approach to be able to challenge a specialized, established server
for a specific language, but instead to provide a good baseline if, for example,
no language server exists for a given language. This is the case, for example,
for Smalltalk and SimpleLanguage, both of which we present later in the paper.

    Describe the proposed solution and its implementation with some examples.

    Merge sections two and three and discuss the features of the proposed solution
    with examples using the Truffle-SL language (see the reviews for more details).

    Describe in more detail, the implementation for the language server protocol.

    Organize the material/challenges/solutions in a table according to the reviews. 

    Section 3 (bulk of the paper) is full of suggestions but no model. It can be
    shorten to a table (challenges/proposal) plus a UML diagram describing where and
    how their proposal integrates into the current Graal/LSP workflow.

    Fix Table 1 according to the reviews.

As was suggested, we have completely reorganized and to large extents completely
rewritten and merged sections 3 and 4. We now go (as was suggested in the fourth
review) feature by feature first for Simple Language, describing at each step
the approach, our reasoning, the implementation strategy, and any API extensions
that we had to make and how difficult these are to implement for the language
developer. We then follow the same order to show how our approaches transfer to
other languages, where they do not we explain why they do not work, and what we
had or would have to implement in these languages to support them. We have
replaced the diagram with the high-level overview over Truffle, the languages,
and the tools with a simplified UML class diagram and reference the classes and
methods in our description. We hope this will help to understand how our
approach is language agnostic, how information is gathered by the server, and
which APIs must be implemented by the language developer.

    Section 2 contains very introductory information that can be found online
    (including some very similar figures), so it can be shorten/merged with their
    "approach" as long as the figures are extended to show where their system
    lives. See the reviews for more details.

This section was shortend significantly and now omits all but the basic
background information about the language server protocol.

    Review A: It seems that executing code to obtain type information has its
    limitations. First, it requires an adequate test suite to bootstrap the
    code. This means that the test suite needs to not only have good coverage but be
    correct. A bogus test (which can happen during early development stages) would
    lead to incorrect runtime type information and potentially wrong code
    completion.

Indeed this is a problem of the approach, yet we think it is one that is out of
the scope of this work to overcome. Bogus code is just as likely to trip up any
attempt of static analysis for dynamic languages as well. We have added a few
sentences, however, to make it clear that our approach heavily favors
test-driven development with small unittests.

    Review A: Second, the ability to execute code assumes that the code is in good
    enough shape. For example, the developer might first write the overall logic
    with mock function calls before filling those out.  In this case, executing the
    code will not help in obtaining type information.

Indeed, if the mock functions are not filled out in the order they are going to
be called, there will be no path to get the type information. However, if
developers either fill out top-to-bottom (in which case there is a good chance
that at every step code will run just far enough to give some completions for
the next implementation level), or they fill out bottom to top and add small
unit tests along the way, gather run-time data is possible.

    Review A: Finally, executing code could be side-effecting. The paper needs to
    discuss this limitation a bit more. The developer may use a library which has a
    REST call deep inside. Executing the code over and over from the IDE may result
    in external undesirable side-effects (and potentially costly).

We have added quite a bit more detail to the sandboxing capabilities of Truffle
and RPython. We envision that these would be used to execute code and redirect
any side-effecting code to in memory mocks. In cases where the result of a
side-effecting operation cannot be known (such as a REST call), all we can do is
give up and ask the developer to write a unit test with appropriate mocking.
  
    Review A: The paper needs to discuss a bit better what a language developer
    needs to provide in terms of hooks to be able to use this framework. A complete
    example on a small language might help (or a general discussion). How much more
    work do they have to do?

    Review D: Possibly the issue is really the paper structure: the paper takes
    Table 1 in Row-major order (working per feature) whereas a presentation in
    Column-major would work better. That's to say: make 2.1 more grounded, detailed,
    precise, then for a new section merging 3 and 4, start with a subsection for the
    simplest language (SL?), describe the salient features of the implementation,
    then describe how it supports whichever features.  The the next subsection
    tackles the next least complex language, describing how the implementation
    differs from the previous one, and the how the features differ, and so on.
    Perhaps language 4 mixes techniques from 3 previous ones, well that's fine,
    again, point back to the concrete descriptions of those features or
    implementations, describe differences.

We have completely reworked sections 3 and 4 of the paper according to the
suggestions. We hope this makes it much clearer how much a language developer
really needs to implement, and we mention whenever a new API was introduced to
support LSP that the developer needs to implement, and refer back to the UML
diagram.

    Review A: The caching aspect needs a bit of clarification. The paper states the
    user needs to initiate it at appropriate times. How does the user know when to
    initiate caching? Does this require knowledge of how the IDE works (which would
    not be ideal)?

We have also dropped the discussion of manual caching of runtime information,
because it cleary was confusing. The user does not have to trigger caching at
all, it is triggered automatically if necessary. The manual triggering was a
cludge that we used during exploration of our approach. In particular, we added
further explanation of how we attempt to create a parseable state after a change
to gather information and that our heuristic is very naive at the moment. We
have instead explained that further work is required to support parsing mid-edit
to alleviate this problem and obsolete the need for the user manually triggering
a parse.

    Review B: IDE use in particular, is an area where "lag" can make the difference
    between a practical implementation of an idea that has a chance of adoption, and
    an idea that has no hope of ever being useful. To be useful to the wider
    community, you really need to give a clear indication of how responsive your
    implementation is. Some benchmarks and results would help to convince the reader
    that your approach is worth pursuing.

We have extended our discussion of lag by moving our description of gathering
runtime information earlier in the paper and extending it. In our discussion of
caching, we mentioned our experience. Due to time and page constraints, we feel
unable to include proper benchmarking in the paper right now, but we have added
this to our future work.

    Review C: You are not presenting properly the context of your contribution when
    you are speaking about "tools" in general that are lacking when building new
    languages, the LSP provides a lot of editing assistance, but is not meant as a
    replacement for "tooling in general". This is the reason that projects such as
    the "Debug Adapters Protocol" where also introduced (to cover additional needs
    such as debuggers, but again not "tooling in general"). You can keep the general
    problem as a motivation but quickly explain to your readers what is the scope of
    your contribution.
    
We have reworked the abstract, introduction, and conclusion to make clear that
our contribution is only in the area of tooling for code editing, and also that
other runtime tools are already available in other forms for language
implementation frameworks.

    Review C: Sec 2. Context: This is very introductory material that can be also
    found online, try to give concrete examples for a "Problem Statement" with some
    implementation details (ie we have Python on top of Truffle, running
    faster/better and can do polyglot, but we do not have the following editing
    facilities that are available through LSP with the standard python
    distribution). Then state your goal (ie a single language server for all
    truffle-based dyn. languages) and pick a state-of-the-art baseline. Even if you
    show us a fraction of the features covered compared to your baseline BUT on top
    of Truffle it is still a WIN.

We removed most of the general information and added some text to make it
clearer that all the existing LSP servers also work with the Truffle
implementations. Our goal in providing this support in a language independent
manner is to argue that there should be no need for separate server
implementations at all. As part of the rewrite to make it clearer how our
approach works for SL (a language without a dedicated language server) and how
it works for Squeak/Smalltalk (another language without a language server) we
hope this has become clearer.

    Review C: Sec 3. Approach: Try to extract a model/design pattern from the
    textual description of page 4 and walk-us through some "idealized"
    code/pseudo-code for your solution. Imagine that we are implementors to whom you
    are suggesting a general solution by giving them an idealized example and not
    only textual "guidelines".

    Review C: Sec 3. Approach: You need to organize your material / challenges /
    solutions in a table, give examples and tell us how your proposed model solves
    the problem (related to c1). Giving textual general guidelines is ok but only
    for corner cases that you judge as "implementation specific", the rest should be
    linked with a concrete description (UML and code) of a proposed solution.

We have added a more detailed (but still simplified) UML diagram and explain the
features in terms of the classes and methods presented in the diagram. We hope
this makes it much clearer what our approach is and what an implementor has to
do in order to support our or a similar approach.

    Review C: Sec 3. Approach: The "Obtaining run-time information" challenge for
    dynamic languages in order to do code completion is an orthogonal/independent
    problem to the one that you already introduced (ie out of the box
    language-agnostic editor support). Again set here a base-line and check what the
    current state-of-the-art is.

It can be an independent problem, but in our case we start from the same basic
requirement: the language developer should not have to do do too much that is
not related to the execution of their language. In particular, they should not
have to add hooks to their interpreter to extract runtime information, instead
the framework should be able to gather as much information as possible
completely transparently to the language runtime. We have made this clearer in
the introduction to our "Obtaining Run-time Information" section, and we also
emphasized more how the FastR was not extended at all to gather runtime
information, yet our approach immediately allows to collect types and provide
some useful features.

    Review C: Sec 4. Impem. + Validation: What is the baseline ? Where are the
    implementation details ? What resources are being used by your proposal,
    compared to other solutions ? What are the trade-offs ?

We merged sections 3 and 4 and give more details of the implementation with the
help of the UML diagram. We hope that this makes it clearer that our approach
relies on the resources provided by Truffle (and that are partially also
available in RPython). We also made clearer in the introduction what our
baseline is.

    Review C: for that matter, can an implementation really run a whole batch of
    unit tests in response to a code completion request?

We have included in our discussion of this approach that we track coverage of
statements by entry point and that as future work its easy to implement
selecting only those tests to run that lead to the desired piece of code. At
this moment, however, this is not implemented we always run everything.

    Review C: the suggestions on unsaved changes seem even less practical (459)

Virtualizing the file system in the manner we propose is easy in both the
Truffle and RPython sandboxes. We have explained a bit more about our sandboxing
approach. The things we mention are available with both the Truffle and RPython
sandboxes to languages developed in those frameworks.

    Review C: Actually page 5 gets more and more far-fetched - is this
    implemented???

Yes, these things are implemented. Our choice of conditionals and wording was
very confusing here, we apologize for the confusion this caused. We have moved
this discussion within the paper and now give more details to make clear that
these things are implemented.
