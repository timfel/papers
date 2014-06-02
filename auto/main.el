(TeX-add-style-hook "main"
 (lambda ()
    (LaTeX-add-bibliographies
     "bib")
    (LaTeX-add-environments
     "highlight")
    (TeX-add-symbols
     '("circnum" 1)
     '("mydescriptionlabel" 1)
     '("bs" 1)
     '("todo" 1)
     '("nbnote" 2)
     "svnversion"
     "coexist"
     "eg"
     "ie"
     "ct"
     "descriptionlabel")
    (TeX-run-style-hooks
     "pifont"
     "acronym"
     "listings"
     "xcolor"
     "textcomp"
     "xspace"
     "ifthen"
     "url"
     "inputenc"
     "utf8x"
     "tabularx"
     "multirow"
     "graphicx"
     "amssymb"
     "amsmath"
     "makeidx"
     "latex2e"
     "sigplanconf10"
     "sigplanconf"
     "content/1_introduction"
     "content/2_background"
     "content/3_motivation"
     "content/4_approach"
     "content/5_implementation"
     "content/6_evaluation"
     "content/7_related_work"
     "content/8_future_work"
     "content/9_summary")))

