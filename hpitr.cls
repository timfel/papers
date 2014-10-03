%%
%% This is file `hpitr.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% hpitr.dtx  (with options: `class')
%% Copyright (c) Daniel Richter, Uwe Hentschel 2013-2014
%% Copyright (c) Tobias Pape, 2014
%% 
%% This file was generated from file(s) of hpitr distribution.
%% ----------------------------------------------------------------------
%% 
%% This work may be distributed and/or modified under the conditions of
%% the LaTeX Project Public License, version 1.3c of the license.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
%% This work has the LPPL maintenance status "maintained".
%% 
%% The Current Maintainer and author of this work is Tobias Pape.
%% 
%% This file may only be distributed together with the file
%% `hpitr.dtx'. You may however distribute the file `hpitr.dtx'
%% without this file.
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{hpitr}%
[%
  2014/09/30 v0.9a
^^J
  A unified class for Technical Reports at the HPI
]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic tools
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{etoolbox}
\RequirePackage{scrbase}[2013/12/19]

%%
%% Id and error
%%
\edef\TR@ClassName{\@currname}
\def\TR@warn{\ClassWarning{\TR@ClassName}}
\def\TR@info{\ClassInfo{\TR@ClassName}}
\def\TR@error{\ClassError{\TR@ClassName}}
\newcommand*\TR@fonterror{\TR@error{%
    Old font commands are not to be used}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conditional statements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{ifthen,ifdraft,ifxetex,ifluatex}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*\@pushback@classoption[1]{%
  \xdef\@classoptionslist{%
    \ifx\@classoptionslist\@empty\else\@classoptionslist,\fi
    #1}%
}

\newcommand*{\TR@NowButAtEndOfClass}{\AtEndOfClass}
\AtEndOfClass{\let\TR@NowButAtEndOfClass\@firstofone}


\DefineFamily{hpitr}
\def\TRFamily{\DefineFamilyMember{hpitr}}
\TRFamily%

\newcommand*{\TRKey}[1][.\@currname.\@currext]{%
  \DefineFamilyKey[#1]{hpitr}%
}
\newcommand*{\TRExecuteOptions}[1][.\@currname.\@currext]{%
  \FamilyExecuteOptions[#1]{hpitr}%
}
\newcommand*{\TRoptions}{\FamilyOptions{hpitr}}
\newcommand*{\AfterTRoptions}{}
\let\AfterTRoptions\AtEndOfFamilyOptions
\newcommand*{\TRoption}{\FamilyOption{hpitr}}

\newcommand*{\TRnewif}{\TRFamily\FamilyBoolKey{hpitr}}
\newcommand*{\TRsetif}{\FamilySetBool{hpitr}}
\newcommand*{\TRnewnumc}{\TRFamily\FamilyNumericalKey{hpitr}}
\newcommand*{\TRsetnumc}{\FamilySetNumerical{hpitr}}

\newcommand*{\TRnewifStd}[1]{%
  \newbool{TR@#1}
  \TRnewif{#1}{TR@#1}}

\newcommand*{\TR@curropt}{}
\newcommand*{\TRStdOption}[3][]{%
  \let\TR@curropt\CurrentOption
  \DeclareOption{#2}{
    #1%
    \TRExecuteOptions{#3}}
  \let\CurrentOption\TR@curropt
}

\providebool{@draft}
\newbool{TR@fulldraft}
\TRKey{draft}[true]{%
  \TRsetif{draft}{@draft}{#1}%
  \ifx\FamilyKeyState\FamilyKeyStateProcessed
    \boolfalse{TR@fulldraft}
  \else
    \ifstr{#1}{full}{%
      \booltrue{@draft}
      \booltrue{TR@fulldraft}
    }{}
  \fi
  \AfterTRoptions{
    \ifthenelse{\boolean{@draft}}{
      \@pushback@classoption{draft}
      \ifthenelse{\not\boolean{TR@fulldraft}}{
        \PassOptionsToPackage{draft=false}{scrlayer-scrpage}
        \PassOptionsToPackage{final}{listings}
        \AtBeginDocument{\Gin@draftfalse}
      }{}
    }{}
  }
}
\TRStdOption{final}{draft=false}
\TRStdOption{draft}{draft=true}

%% name of the base class
\providecommand*\TR@BaseClass{\@empty}

%% proceedings?
\newbool{TR@proceedings}
\newbool{TR@inproceedings}
\newbool{TR@contribtools}
\newbool{TR@chapters}
\booltrue{TR@chapters}
\TRnewifStd{chapterbib}
\TRStdOption{chapterbib}{chapterbib=true}
\TRKey{trtype}{
  \TRsetnumc{trtype}{@tempa}{%
    {singlearticle}{0},{article}{0},%
    {singlereport}{1},{report}{1},%
    {proceedings}{2},%
    {collection}{3},%
    {inproceedings}{4}%
  }{#1}
  \ifcase \@tempa\relax
    \renewcommand*\TR@BaseClass{scrartcl}
    \boolfalse{TR@proceedings}
    \boolfalse{TR@chapters}
    \boolfalse{TR@contribtools}
  \or
    \renewcommand*\TR@BaseClass{scrreprt}
    \boolfalse{TR@proceedings}
    \booltrue{TR@chapters}
    \boolfalse{TR@contribtools}
  \or
    \renewcommand*\TR@BaseClass{scrbook}
    \booltrue{TR@proceedings}
    \booltrue{TR@contribtools}
    \booltrue{TR@chapters}
    \booltrue{TR@chapterbib}
  \or
    \renewcommand*\TR@BaseClass{scrbook}
    \boolfalse{TR@proceedings}
    \booltrue{TR@contribtools}
    \booltrue{TR@chapters}
  \or
    \renewcommand*\TR@BaseClass{scrartcl}
    \booltrue{TR@proceedings}
    \booltrue{TR@contribtools}
    \boolfalse{TR@chapters}
    \boolfalse{TR@chapterbib}
    \booltrue{TR@inproceedings}
    \AtBeginDocument{%
      \booltrue{TR@firsttitleseen}%
      \clearheadinfo%
      }
  \fi
}
\TRStdOption{single}{trtype=singlereport}
\TRStdOption{singlereport}{trtype=singlereport}
\TRStdOption{singlearticle}{trtype=singlearticle}
\TRStdOption{proceedings}{trtype=proceedings}
\TRStdOption{inproceedings}{trtype=inproceedings}
\TRStdOption{collection}{trtype=collection}

\TRnewifStd{inproceedingspagenumbers}

\TRnewifStd{todotools}
\TRnewifStd{egiecomma}

%% execute the standard options
\TRExecuteOptions{
  trtype=singlereport,%
}

\FamilyProcessOptions{hpitr}\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load base class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass{\TR@BaseClass}

%%
%% early stuff
%%
\ifthenelse{\boolean{xetex} \or \boolean{luatex}}{}{%
  \RequirePackage[utf8]{inputenc}
}

\KOMAoptions{
  twocolumn=false,
  fontsize=12pt,
  footinclude=false,
  headinclude=false,
}
\KOMAoptions{%
  pagesize=auto,
  paper=a4,
  DIV=11,
  twoside=semi,
}
\AtEndPreamble{\recalctypearea}
\ifthenelse{\boolean{TR@proceedings}\AND\boolean{TR@chapters}}{
  \KOMAoption{open}{right}
}{}
\RequirePackage{fixltx2e}[2014/06/10]
\RequirePackage{scrhack}

\PassOptionsToPackage{log-declarations=false}{xparse}
\RequirePackage{expl3}[2011/09/05]
\RequirePackage{xparse}
\ExplSyntaxOn
\cs_if_free:NTF \fp_div:Nn
  {
    \cs_new_protected:Npn \fp_div:Nn #1 #2
      {
        \fp_set:Nn #1 { #1/#2 }
      }
  }{}
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Title.
%%
%% No actual title, only a titlepage page when in draft mode.
%%
%% However, we collect the information for the pdf and also for
%% convenience.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\@ifpackagelater{scrbase}{2013/12/19}{%
  \KOMAoption{titlepage}{firstiscover}
}{
  \KOMAoption{titlepage}{yes}
}

\apptocmd{\title}{%
  \AfterPreamble{
    \begingroup
    \appto\pdfstringdefPreHook{\def\\{\space\ignorespaces}}
    \hypersetup{pdftitle={#1}}
    \endgroup}}
{}{%
  \TR@warn{Cannot patch \string\title to set pdftitle}}

\apptocmd{\author}{%
  \AfterPreamble{
    \begingroup
    \appto\pdfstringdefPreHook{\def\and{,\space\ignorespaces}}
    \hypersetup{pdfauthor={#1}}
    \endgroup}
  }
{}{%
  \TR@warn{Cannot patch \string\author to set pdfauthor}}

\providecommand*\email[1]{\href{mailto:#1}{\nolinkurl{#1}}\xspace}
\providecommand*\hairspace{\ifmmode\mskip1mu\else\kern0.08em\fi}
\ifthenelse{\boolean{TR@egiecomma}}{
  \providecommand*\eg{e.\hairspace{}g.,\xspace}
  \providecommand*\Eg{E.\hairspace{}g.,\xspace}
  \providecommand*\Ie{I.\hairspace{}e.,\xspace}
  \providecommand*\ie{i.\hairspace{}e.,\xspace}
}{
  \providecommand*\eg{e.\hairspace{}g.\xspace}
  \providecommand*\Eg{E.\hairspace{}g.\xspace}
  \providecommand*\Ie{I.\hairspace{}e.\xspace}
  \providecommand*\ie{i.\hairspace{}e.\xspace}
}
\providecommand*\zB{z.\hairspace{}B.\xspace}
\providecommand*\ZB{Z.\hairspace{}B.\xspace}
\providecommand*\dh{d.\hairspace{}h.\xspace}
\providecommand*\Dh{D.\hairspace{}h.\xspace}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifthenelse{\boolean{@draft}}{
  \AtBeginDocument{
    \setkomafont{author}{\normalfont\normalsize}
    \setkomafont{date}{\normalfont\normalsize}
    \setkomafont{dedication}{\normalfont\normalsize}
    \setkomafont{publishers}{\normalfont\normalsize}
    \setkomafont{subtitle}{\normalfont\small}
    \setkomafont{title}{\normalfont\normalsize}
    \setkomafont{titlehead}{\normalfont\normalsize}
  }
  \pretocmd{\titlepage}{%
    \ifthenelse{\boolean{@mainmatter}}{\pagenumbering{Roman}}{}
    \let\center\flushright%
    \let\endcenter\endflushright%
    \let\huge\normalsize%
  }{}{%
    \TR@warn{Cannot patch \string\maketitle}}
  \apptocmd{\endtitlepage}{%
    \cleardoubleemptypage%
    \ifthenelse{\boolean{@mainmatter}}{%
      \pagenumbering{arabic}}{%
      \pagenumbering{roman}}
      \ifthenelse{\boolean{TR@inproceedingspagenumbers}}{}{%
        \setcounter{page}{5}%
      }
    \relax%
  }{}{%
    \TR@warn{Cannot patch \string\maketitle}}
}{%
  \def\maketitle{%
    \ifthenelse{\boolean{TR@inproceedingspagenumbers}}{}{%
      \setcounter{page}{5}%
    }\relax}
}

\ifthenelse{\boolean{TR@proceedings}\OR\boolean{TR@contribtools}}{
%% Title of the event
  \newcommand*\event[1]{%
    \gdef\@eventtitle{#1}
    \AfterPreamble{\hypersetup{pdfsubject = {Technical Report: #1}}}
  }
  \def\@eventtitle{%
    \TR@warn{No \string\event\space given}
    \global\cslet{@eventtitle}\@empty}
  \newcommand*\noevent{\gdef\@eventtitle{}}
%% Paper number
  \newcommand{\papernumber}[1]{%
    \def\@papernumber{#1}
    \ifx\@papernumber\empty
    \else
      \renewcommand*{\thepage}{\@papernumber-\arabic{page}}
    \fi
  }
  \let\@papernumber\@empty

  \RequirePackage{ragged2e}
  \ifthenelse{\boolean{TR@inproceedings}}{}{%
    \AtEndPreamble{%
      \RequirePackage{biblatex}}
    }
  \providecommand\TR@contributions{}
  \newcommand*{\contributions}[1]{%
    \xdef\TR@contributions{#1}%
    \configureContributions%
  }
  \newcommand*{\TR@preamble}[1]{%
    \InputIfFileExists {#1/preamble}{}{}}

  \newcommand*{\configureContributions}{%
    \def\doit{}%
    \@for\next:=\TR@contributions\do{%
      \ifx\@empty\next\relax\else%
      \expandafter\appto\expandafter\doit\expandafter%
      {\expandafter\TR@preamble\expandafter{\next}}%
      \fi%
    }%
    \doit{}%
  }
  \newcommand*{\includeContributionContents}{%
    \def\doit{}%
    \@for\next:=\TR@contributions\do{%
      \ifx\@empty\next\else%
      \expandafter\appto\expandafter\doit\expandafter%
      {\expandafter\TR@includedir\expandafter{\next}}%
      \fi%
    }%
    \doit{}%
  }
  \newcommand*{\TR@includedir}[1]{%
    \global\let\TR@saved@include\include
    \global\let\TR@saved@input\input
    \gdef\include##1{\TR@saved@include{#1/##1}}
    \gdef\input##1{\TR@saved@input{#1/##1}}
    \graphicspath{{#1/}}
    \TR@includedir@{#1}
    \global\let\include\TR@saved@include%
    \global\let\input\TR@saved@input%
  }
  \ifthenelse{\boolean{TR@chapterbib}}{%
    \newcommand*{\TR@includedir@}[1]{%
      \begin{refsection}[#1/references.bib]
        \ifthenelse{\boolean{TR@proceedings}}{%
          \cleardoubleemptypage}{\clearpage}%
        \TR@saved@input{#1/content}%
        \printbibliography[%
          heading=subbibliography, %
          title=\refname, %
        ]%
      \end{refsection}}
  }{%
    \newcommand*{\TR@includedir@}[1]{%
      \ifthenelse{\boolean{TR@proceedings}}{\cleardoubleemptypage}{\clearpage}%
      \TR@saved@input{#1/content}%
    }
  }

  \def\clearheadinfo{\gdef\@author{No Author Given}%
    \gdef\@title{No Title Given}%
    \gdef\@subtitle{}%
    \gdef\@institute{No Institute Given}%
    \gdef\@group{}%
    \gdef\@organization{}%
    \gdef\@thanks{}%
    \gdef\@email{}%
    \global\let\@titlerunning\@empty% only non-proceedings
  }
  \newkomafont{abstract}{\normalfont\small}

  \def\institute#1{\gdef\@institute{#1}}
  \def\organisation#1{\gdef\@organization{#1}}
  \let\organization\organisation
  \def\group#1{\gdef\@group{#1}}
  \ifcsundef{email}{\newcommand*\email{}}
  \renewcommand*\email[1]{\gdef\@email{#1}}

  \ifthenelse{\boolean{TR@proceedings}}{%
    \newcounter{@inst}
    \newcounter{@auth}
    \newcounter{auco}
    \newbox\headrun
    \newtoks\authorrunning
    \newtoks\tocauthor
    \newtoks\titlerunning
    \newtoks\toctitle

    \def\institutename{\par\begingroup
      \parskip=\z@
      \parindent=\z@
      \setcounter{@inst}{1}%
      \def\and{\par\stepcounter{@inst}%
        \noindent$^{\the@inst}$\enspace\ignorespaces}%
      \setbox0=\vbox{\def\thanks##1{}\@institute}%
      \ifnum\c@@inst=1\relax
        \gdef\fnnstart{0}%
      \else
        \xdef\fnnstart{\c@@inst}%
        \setcounter{@inst}{1}%
        \noindent$^{\the@inst}$\enspace
      \fi
      \ignorespaces
      \ifx\@organization\@empty\relax%
        \@institute%
      \else%
        \@group \\ \@organization \\ \href{mailto:\@email}{\nolinkurl{\@email}}%
       \fi%
       \par
      \endgroup}

    \def\inst#1{\unskip$^{#1}$}
    \def\fnmsep{\unskip$^,$}

    \def\l@title#1#2{%
      \addpenalty{-\@highpenalty}
      \addvspace\baselineskip
      \@tempdima \z@
      \begingroup
        \parindent \z@ \rightskip \@tocrmarg
        \advance\rightskip by 0pt plus 2cm
        \parfillskip -\rightskip \pretolerance=10000
        \leavevmode \advance\leftskip\@tempdima \hskip -\leftskip
        \begingroup%
          \setlength{\RaggedRightRightskip}{0pt plus 1fil}%
          \RaggedRight%
          #1\nobreak
          \leaders\hbox{$\m@th \mkern \@dotsep mu.\mkern
            \@dotsep mu$}\hfill
          \nobreak\hbox to\@pnumwidth{\hss #2}\par
        \endgroup
        % \penalty\@highpenalty \endgroup
        \penalty10000\endgroup}

      \def\l@author#1#2{%\addpenalty{\@highpenalty}
        \addpenalty{10000}
        \@tempdima=15\p@ %\z@
        \begingroup%
          \parindent \z@ \rightskip \@tocrmarg%
          \advance\rightskip by 0pt plus 2cm%
          \pretolerance=10000
          \leavevmode \advance\leftskip\@tempdima %\hskip -\leftskip
          {\itshape #1\par}
          % \penalty\@highpenalty
          \penalty0\relax
          \endgroup}

    %%% to avoid hyperref warnings
    \providecommand*{\toclevel@author}{999}
    %%% to make title-entry parent of section-entries
    \providecommand*{\toclevel@title}{0}
%%% /if proceedings
  }{}
  \newbool{TR@firsttitleseen}
  \boolfalse{TR@firsttitleseen}

  \let\TR@firsttitle@maketitle\maketitle
  \renewcommand*\maketitle{
    \ifthenelse{\boolean{TR@firsttitleseen}}{%
      \TR@contrib@maketitle%
      }{
        \TR@firsttitle@maketitle%
        \clearheadinfo%
        \booltrue{TR@firsttitleseen}}}
    % we switch to title seen also when people do not use \maketitle
    \apptocmd{\tableofcontents}{\booltrue{TR@firsttitleseen}}{}{%
      \TR@warn{Cannot patch \string\tableofcontents}}

  \let\TR@firsttitle@author\author
  \renewcommand*\author{
    \ifthenelse{\boolean{TR@firsttitleseen}}%
    {\TR@contrib@author}%
    {\TR@firsttitle@author}}

  \AtEndOfClass{
    \let\TR@firsttitle@keywords\keywords
    \renewcommand*\keywords{%
      \ifthenelse{\boolean{TR@firsttitleseen}}%
      {\TR@contrib@keywords}%
      {\TR@firsttitle@keywords}}
  }

  \providecaptionname{english}{\andname}{and}
  \providecaptionname{english}{\lastandname}{\unskip, and}
  \providecaptionname{german}{\andname}{und}
  \providecaptionname{german}{\lastandname}{und}
  \providecaptionname{ngerman}{\andname}{und}
  \providecaptionname{ngerman}{\lastandname}{und}

  \def\TR@authcount#1{\setcounter{auco}{#1}\setcounter{@auth}{1}}
  \pretocmd{\tableofcontents}{%
    \let\authcount\TR@authcount%
    \def\lastand{\ifnum\value{auco}=2\relax
        \unskip{} \andname\
      \else
        \unskip \lastandname\
      \fi}%
    \def\and{\stepcounter{@auth}\relax
      \ifnum\value{@auth}=\value{auco}%
        \lastand
      \else
        \unskip,
      \fi}%
  }{}{%
    \TR@warn{Cannot patch \string\tableofcontents}}

  \ifthenelse{\boolean{TR@proceedings}}{%
    \newcommand*\TR@contrib@maketitle{\newpage
      \phantomsection
      \ifthenelse{\boolean{TR@chapters}}{%
        \refstepcounter{chapter}%
      }{}
      \stepcounter{section}%
      \setcounter{section}{0}%
      \setcounter{subsection}{0}%
      \setcounter{figure}{0}
      \setcounter{table}{0}
      \setcounter{equation}{0}
      \setcounter{footnote}{0}%
      \begingroup
      \parindent=\z@
      \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \TR@contrib@@maketitle
      \ifthenelse{\boolean{TR@chapters}}{%
        \thispagestyle{\chapterpagestyle}%
      }{%
        \thispagestyle{empty}%
      }
      \@thanks
      \def\\{\unskip\ \ignorespaces}\def\inst##1{\unskip{}}%
      \def\thanks##1{\unskip{}}\def\fnmsep{\unskip}%
      \if!\the\toctitle!\addcontentsline{toc}{title}{\@title}\else
        \addcontentsline{toc}{title}{\the\toctitle}\fi
      \if!\the\titlerunning!\else
        \edef\@title{\the\titlerunning}%
      \fi
      \ifx\@author\empty\relax%
        \xdef\@runninghead{\ignorespaces\@title}
      \else
        \if!\the\tocauthor!\relax
          {\def\and{\noexpand\protect\noexpand\and}%
            \protected@xdef\toc@uthor{\@author}}%
        \else
          \def\\{\noexpand\protect\noexpand\newline}%
          \protected@xdef\scratch{\the\tocauthor}%
          \protected@xdef\toc@uthor{\scratch}%
        \fi
        \addtocontents{toc}{\noexpand\protect\noexpand\authcount{\the\c@auco}}%
        \addcontentsline{toc}{author}{\toc@uthor}%

        \if!\the\authorrunning!
          \value{@inst}=\value{@auth}%
          \setcounter{@auth}{1}%
        \else
          \edef\@author{\the\authorrunning}%
        \fi

        \xdef\@runninghead{\unskip\ignorespaces\@author: \@title}
      \fi

      \global\setbox\headrun=\hbox{\usekomafont{pagehead}\@runninghead}%
      \ifdim\wd\headrun>\hsize
        \TR@warn{Title and author names too long for running head. Please supply
          a shorter form with \string\titlerunning\space and
          \string\authorrunning\space prior to \string\maketitle}%
        \xdef\@runninghead{Authors/Title Suppressed Due to Excessive Length}%
      \fi
      \ifthenelse{\boolean{TR@chapters}}{%
        \addchapmark{\@runninghead}%
      }{%
        \xdef\TR@titlemark{\@runninghead}%
        \xdef\TR@authormark{\@author}%
      }%
      \endgroup
      \setcounter{footnote}{\fnnstart}%
      \clearheadinfo%
      \relax%
      \ignorespaces}

    \newcommand*\TR@contrib@@maketitle{\newpage
      \def\lastand{\ifnum\value{@inst}=2\relax
          \unskip{} \andname\
         \else
           \unskip \lastandname\
         \fi}%
       \def\and{\stepcounter{@auth}\relax
         \ifnum\value{@auth}=\value{@inst}%
           \lastand
         \else
           \unskip,
         \fi}%
       \begin{center}%
         \let\newline\\
         {\Large \bfseries\boldmath
           \pretolerance=10000
           \@title \par}\vskip .8cm
         \if!\@subtitle!\else {\large \bfseries\boldmath
           \vskip -.65cm
           \pretolerance=10000
           \@subtitle \par}\vskip .8cm\fi
         \setbox0=\vbox{\setcounter{@auth}{1}\def\and{\stepcounter{@auth}}%
           \def\thanks##1{}\@author}%
         \global\value{@inst}=\value{@auth}%
         \global\value{auco}=\value{@auth}%
         \setcounter{@auth}{1}%
         {\lineskip .5em
           \noindent\ignorespaces
           \@author\vskip.35cm}
         {\small\institutename}
       \end{center}%
     }

     \newcommand*\TR@contrib@author[1]{\gdef\@author{#1}}
     \newcommand*{\TR@contrib@keywords}[1]{%
       \par\addvspace\baselineskip%
       \noindent\keywordname\enspace\ignorespaces#1}%

   \ifthenelse{\boolean{TR@chapters}}{%
     \renewcommand*\thesection{\@arabic\c@section}
     \renewcommand*\thefigure{\@arabic\c@figure}
     \renewcommand*\thetable{\@arabic\c@table}
     \renewcommand*\theequation{\@arabic\c@equation}
     \@addtoreset{equation}{chapter}
     \BeforePackage{hyperref}{%
       \newcommand*\theHequation{\theHsection.\arabic{equation}}%
       \newcommand*\theHchapter    {\arabic{chapter}}%
       \newcommand*\theHfigure     {\theHchapter.\arabic{figure}}%
       \newcommand*\theHtable      {\theHchapter.\arabic{table}}%
       \newcommand*\theHsection    {\theHchapter.\arabic{section}}%
       \newcommand*\theHsubsection   {\theHsection.\arabic{subsection}}
       \newcommand*\theHsubsubsection{\theHsubsection.\arabic{subsubsection}}
       \newcommand*\theHparagraph    {\theHsubsubsection.\arabic{paragraph}}
       \newcommand*\theHsubparagraph {\theHparagraph.\arabic{subparagraph}}
       \newcommand*\theHtheorem      {\theHsection.\arabic{theorem}}
       \newcommand*\theHthm          {\theHsection.\arabic{thm}}
     }
   }{}
  \AtBeginDocument{%
    \setcounter{tocdepth}{0}
  }

  }{%%%% collection
    \let\TR@contrib@author\@gobble
    \let\TR@contrib@keywords\@gobble
    \let\institute\@gobble
    \let\authorrunning\@gobble
    \let\toctitle\@gobble
    \let\tocauthor\@gobble

    \let\@titlerunning\@empty
    \setkomafont{abstract}{\footnotesize\itshape}
    \newcommand*\titlerunning[1]{\gdef\@titlerunning{#1}}
    \newcommand*\TR@contrib@maketitle{%
      \ifcsempty{@titlerunning}{%
        \expandafter\chapter\expandafter{\@title}%
      }{%
        \expandafter\chapter\expandafter[\expandafter\@titlerunning\expandafter]\expandafter{\@title}%
      }
      \edef\@templ{lbl:chaper-\thechapter}%
      \expandafter\label\expandafter{\@templ}%
      \clearheadinfo%
    }
  }

  \AfterPackage{listings}{
    \lstset{numberbychapter=true}}
  \ifthenelse{\boolean{TR@proceedings}}{%
    \AfterPackage{listings}{
      \AtBeginDocument{
        \def\thelstlisting{\@arabic\c@lstlisting}%
        \def\theHlstnumber{\ifx\lst@@caption\@empty \lst@neglisting
                                                 \else \theHlstlisting \fi%
                                                 .\thelstnumber}}}
  }{}

    \@ifundefined{abstract}{%
      \newenvironment{abstract}{}{}}{}%
    \renewenvironment{abstract}{%
      \ifthenelse{\boolean{TR@firsttitleseen}}{
        \list{}{%\advance\topsep by0.35cm\relax
          \setlength{\topsep}{0pt}%
          \setlength{\leftmargin}{2em}%
          \setlength{\rightmargin}{\leftmargin}%
          \setlength{\listparindent}{\parindent}%
          \setlength{\itemindent}{\parindent}%
          \setlength{\parsep}{\parskip}%
          \usekomafont{abstract}
          }\item[]\noindent\ignorespaces%
      }{%
        \TR@error{Proceedings should not have \MessageBreak
          abstracts. Please remove it.}}
    }%
    {\ifthenelse{\boolean{TR@firsttitleseen}}{\endlist}{}}

  %for compat with swathesis
  \let\supervisors\@gobble
  \let\statements\relax
}{}
\newcommand*\keywords[1]{
  \AfterPreamble{
    \begingroup
    \appto\pdfstringdefPreHook{\def\\{\space\ignorespaces}}
    \hypersetup{pdfkeywords={#1}}
    \endgroup}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Language
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{hyphsubst}
\HyphSubstLet{ngerman}{ngerman-x-latest}
\RequirePackage{babel}
\newcommand*\TR@lang{}\let\TR@lang\@empty

\AfterPackage{hyperref}{
  % https://tex.stackexchange.com/questions/193025/babel-hyperref-redefining-shorthand-several-times-per-page
  \patchcmd{\pdfstringdef}
    {\csname HyPsd@babel@}
    {\let\bbl@info\@gobble\csname HyPsd@babel@}
    {}{}
}

{
  \def\@l#1{\equal{\languagename}{#1}}
  \def\@L#1{\gdef\TR@lang{#1}}
\ifthenelse{\@l{afrikaans}}{\@L{af}}{}
\ifthenelse{\@l{bahasa}\OR\@l{indonesian}\OR\@l{indon}\OR%
  \@l{bahasai}\OR\@l{bahasam}\OR\@l{malay}\OR\@l{meyalu}}{\@L{id}}{}
\ifthenelse{\@l{basque}}{\@L{eu}}{}
\ifthenelse{\@l{breton}}{\@L{br}}{}
\ifthenelse{\@l{bulgarian}}{\@L{bg}}{}
\ifthenelse{\@l{catalan}}{\@L{ca}}{}
\ifthenelse{\@l{croatian}}{\@L{hr}}{}
\ifthenelse{\@l{czech}}{\@L{cs}}{}
\ifthenelse{\@l{danish}}{\@L{da}}{}
\ifthenelse{\@l{dutch}}{\@L{nl}}{}
\ifthenelse{\@l{english}\OR\@l{USenglish}\OR\@l{american}\OR%
  \@l{UKenglish}\OR\@l{british}\OR\@l{canadian}\OR%
  \@l{australian}\OR\@l{newzealand}}{\@L{en}}{}
\ifthenelse{\@l{esperanto}}{\@L{eo}}{}
\ifthenelse{\@l{estonian}}{\@L{et}}{}
\ifthenelse{\@l{finnish}}{\@L{fi}}{}
\ifthenelse{%
  \@l{french}\OR\@l{francais}\OR\@l{canadien}\OR\@l{acadian}}{\@L{fr}}{}
\ifthenelse{\@l{galician}}{\@L{gl}}{}
\ifthenelse{\@l{german}\OR\@l{germanb}\OR\@l{ngerman}\OR%
  \@l{ngermanb}\OR\@l{austrian}\OR\@l{naustrian}}{\@L{de}}{}
\ifthenelse{\@l{greek}\OR\@l{polutonikogreek}}{\@L{el}}{}
\ifthenelse{\@l{hebrew}}{\@L{he}}{}
\ifthenelse{\@l{magyar}\OR\@l{hungarian}}{\@L{hu}}{}
\ifthenelse{\@l{icelandic}}{\@L{is}}{}
\ifthenelse{\@l{interlingua}}{\@L{ia}}{}
\ifthenelse{\@l{irish}}{\@L{ga}}{}
\ifthenelse{\@l{italian}}{\@L{it}}{}
\ifthenelse{\@l{latin}}{\@L{la}}{}
\ifthenelse{\@l{samin}}{\@L{se}}{}
\ifthenelse{\@l{norsk}}{\@L{no}}{}
\ifthenelse{\@l{nynorsk}}{\@L{nn}}{}
\ifthenelse{\@l{polish}}{\@L{pl}}{}
\ifthenelse{%
  \@l{portuges}\OR\@l{portuguese}\OR\@l{brazilian}\OR\@l{brazil}}{\@L{pt}}{}
\ifthenelse{\@l{romanian}}{\@L{ro}}{}
\ifthenelse{\@l{russian}}{\@L{ru}}{}
\ifthenelse{\@l{scottish}}{\@L{gd}}{}
}
\ifthenelse{\boolean{luatex}}{%
  \RequirePackage[final]{microtype}[2013/05/23]
}{
  \RequirePackage[final,babel=true]{microtype}[2013/05/23]
}
\RequirePackage[T1]{fontenc}
\ifthenelse{\boolean{luatex} \or \boolean{xetex}}{%
  \RequirePackage{fontspec}[2014/06/21]
}{}

\RequirePackage[euler-digits,T1]{eulervm}
\let\mathbf\mathbold
\ifthenelse{\boolean{luatex} \or \boolean{xetex}}{%
  \setmainfont{texgyrepagella}[ExternalLocation,%
      Numbers={Proportional,OldStyle},%
      UprightFont= *-regular,%
      BoldFont=*-bold,%
      ItalicFont=*-italic,%
      BoldItalicFont=*-bolditalic,%
      Ligatures={Common,TeX},%
      ]
  \RequirePackage[scale=MatchLowercase,semibold]{sourcecodepro}
  \RequirePackage[scale=MatchLowercase,semibold,osf]{sourcesanspro}
}{
  \RequirePackage[scale=.9,semibold]{sourcecodepro}
  \RequirePackage[scale=.9,semibold,osf]{sourcesanspro}
  \RequirePackage[osf,sc]{mathpazo}
}
\linespread{1.05} % a bit more for Palatino

\let\footnotesize\small

\ifthenelse{\boolean{xetex}\OR\boolean{luatex}}{
  \microtypesetup{stretch=9,shrink=15,step=3}
}{
  \microtypesetup{stretch=9,shrink=15,step=3,tracking=smallcaps,letterspace=75}
}

\addtokomafont{disposition}{\rmfamily}
\setkomafont{title}{\rmfamily\mdseries}
\addtokomafont{descriptionlabel}{\rmfamily}
\renewcommand*\labelitemii{\normalfont\textendash}
\setfootnoterule{4cc}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Text companion fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{textcomp}
\RequirePackage{mathcomp}
\RequirePackage{relsize}

%%%
%%% Details
%%%
\KOMAoptions{
  headings=big
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Page breaks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% no footnote breaks
\interfootnotelinepenalty = 1000

%% avoid widows (Hurenkinder) and orphans (Schusterjungen)
\clubpenalty = \@M
\widowpenalty = \@M

\setlength{\textfloatsep}{2\baselineskip}
\setlength{\floatsep}{\baselineskip}
\setlength{\intextsep}{2\baselineskip}

\AtEndPreamble{
  \frenchspacing
  \raggedbottom
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Headers and footers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\KOMAoptions{
  headsepline=false,
  footsepline=false,
}
\RequirePackage{scrlayer-scrpage}
\pagestyle{scrheadings}

\ifthenelse{\boolean{TR@chapters}}{
  \renewcommand*\chapterpagestyle{plain.scrheadings}
  \automark[chapter]{chapter}
  \automark*[section]{}
}{
  \ifthenelse{\boolean{TR@inproceedings}}{
    \lehead{\TR@titlemark}
  }{
    \lehead{\@title}
  }
  \automark*[section]{}
}

\lefoot[]{}\lofoot[]{}
\refoot[]{}\rofoot[]{}
\ifthenelse{\boolean{TR@inproceedings}}{
  \ifthenelse{\boolean{TR@inproceedingspagenumbers}}{
    \cefoot[\pagemark]{\pagemark}
    \cofoot[\pagemark]{\pagemark}
  }{
    \cefoot[]{}
    \cofoot[]{}
  }
}{
  \cefoot[\pagemark]{\pagemark}
  \cofoot[\pagemark]{\pagemark}
}

%%  \ifthenelse{\boolean{TR@proceedings}\OR\boolean{TR@contribtools}}{
%%   \lefoot[\@eventtitle]{\@eventtitle}
%%   \lofoot[\@eventtitle]{\@eventtitle}
%% }{}

 %\setkomafont{pagefoot}{}
\setkomafont{pagehead}{\itshape}
\setkomafont{pageheadfoot}{\normalcolor}
\setkomafont{pagenumber}{\normalfont}

\ifthenelse{\boolean{TR@chapters}}{
  \renewcommand*{\chapterheadstartvskip}{\vspace*{3\baselineskip}}
  \renewcommand*{\chapterheadendvskip}{\vspace*{2\baselineskip}}
}{}
\def\TR@patchw{\TR@warn{Cannot patch sectioning command.\MessageBreak This is
    not severe.}}
\patchcmd{\section}{-3.5ex \@plus -1ex \@minus -.2ex}{-2\baselineskip}{}{\TR@patchw}
\patchcmd{\section}{2.3ex \@plus.2ex}{\baselineskip}{}{\TR@patchw}
\patchcmd{\subsection}{-3.25ex\@plus -1ex \@minus -.2ex}{-\baselineskip}{}{\TR@patchw}
\patchcmd{\subsection}{1.5ex \@plus .2ex}{\baselineskip}{}{\TR@patchw}
\patchcmd{\subsubsection}{-3.25ex\@plus -1ex \@minus -.2ex}{-\baselineskip}{}{\TR@patchw}
\patchcmd{\subsubsection}{1.5ex \@plus .2ex}{1sp \@plus 1sp \@minus 1sp}{}{\TR@patchw}
\patchcmd{\paragraph}{3.25ex \@plus1ex \@minus .2ex}{\baselineskip}{}{\TR@patchw}
\patchcmd{\subparagraph}{3.25ex \@plus1ex \@minus .2ex}{\baselineskip}{}{\TR@patchw}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDF links and bookmarks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\PassOptionsToPackage{hyphens}{url}
\PassOptionsToPackage{%
  final,%
  unicode=true,%
  plainpages=false,%
  pdfpagelabels=true,%
}{hyperref}
\AtEndPreamble{%
  \RequirePackage{hyperref}%
  \RequirePackage{hyperxmp}
}
\AtBeginDocument{%
  \hypersetup{%
    breaklinks=true,
    %pdfborder = 0 0 0,
    bookmarksnumbered = true,
    pdfsubject = {Technical Report},
    pdfkeywords = {},
    pdfcreator = {HPI},
    pdfcopyright = {Copyright (c) \the\year, HPI},
    pdfmetalang = {en},
    pdfproducer = {\TR@ClassName - Technical Reports at the HPI},
    pdflang = {\TR@lang},
    pdfdisplaydoctitle = false,
    pdfpagemode = UseOutlines,
  }
}
%%
%%
%% Table of contents
%%
%% no protrusion there
%% starts on own page.

\RequirePackage{tocbasic}
\setcounter{tocdepth}{1}
\tocbasicautomode
\setuptoc{toc}{noprotrusion}

\AfterPackage{listings}{
  \setuptoc{lol}{noprotrusion}
}

\ifthenelse{\boolean{TR@chapters}}{
  \renewcommand*\raggedchapterentry{\raggedright}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifthenelse{\boolean{TR@proceedings}\OR\boolean{TR@contribtools}}{}{
  \renewenvironment{abstract}{%
    \thispagestyle{plain.scrheadings}
    \null\vfil\leavevmode%
    \noindent%
    \ignorespaces
  }{%
    \par\vfil%
    \cleardoublepage%
  }
}

\PassOptionsToPackage{style=numeric-comp,firstinits=true}{biblatex}
\AfterPackage{biblatex}{
  \setcounter{biburllcpenalty}{7000}
  \setcounter{biburlucpenalty}{8000}
  \ExecuteBibliographyOptions{
    url=false,%
    urldate=iso8601,%
    abbreviate=false,%
    maxnames=20,%
  }
  \PreventPackageFromLoading[\message{%
    ^^J^^JERROR: You tried to load  the cite package that is not compatible
    with biblatex.^^J^^J%
  }]{cite}
}
\AtEndPreamble{
  \@ifpackageloaded{biblatex}{}{
    \bibliographystyle{plain}
  }
}

%%%%
%%
%%%
\ifthenelse{\boolean{TR@chapters}}{%
  \global\let\@auto@bibname\refname
  \global\let\bibname\refname
  \defcaptionname{ngerman}{\bibname}{\refname}
  \defcaptionname{german}{\bibname}{\refname}
  \defcaptionname{english}{\bibname}{\refname}
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Math mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath}
\RequirePackage{amssymb}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{booktabs}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Graphics and Floats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}
\RequirePackage{grffile}

\AtEndPreamble{
  \@ifpackageloaded{float}{}{% mock float
    \providecommand*\floatname[2]{\@namedef{fname@#1}{#2}}
    \providecommand*\floatplacement[2]{\@namedef{fps@#1}{#2}}
    \floatplacement{figure}{htbp}
    \floatplacement{table}{htp}
  }
}

\AfterPackage{float}{
  \def\@float@HH#1{%
    \TR@error{The [H] specifier for floats is forbidden for\MessageBreak
      the hpitr class.}}
  \floatstyle{komabelow}
}

\setcapindent{1em}
\addtokomafont{captionlabel}{\bfseries}
\PassOptionsToPackage{ruled}{algorithm2e}

\providecommand*\TR@listingfont{}
\ifthenelse{\boolean{xetex}}{%
  \newcommand*\TRlistingfont[1]{\gdef\TR@listingfont{#1\addfontfeature{Mapping=}}}%
}{%
  \ifthenelse{\boolean{luatex}}{%
    \newcommand*\TRlistingfont[1]{\gdef\TR@listingfont{#1\addfontfeature{RawFeature={-tlig;-trep}}}}%
  }{
    \newcommand*\TRlistingfont[1]{\gdef\TR@listingfont{#1}}}
}{}
\TRlistingfont{\ttfamily\small}

\AfterPackage{verbatim}{
  \renewcommand*\verbatim@font{\TR@listingfont}
}
\AfterPackage{listings}{
  \AtEndPreamble{
    \lstset{%
      basicstyle=\TR@listingfont,
      floatplacement=htbp,
      captionpos=t,
      abovecaptionskip=0pt,
      belowcaptionskip=0pt,
      upquote=true,
      showstringspaces=false,
      inputencoding=utf8,
    }
  }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{color}
\RequirePackage[table,svgnames,dvipsnames]{xcolor}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% include PDF Documents
%% with more than 1 page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifthenelse{\boolean{TR@proceedings}}{
  \RequirePackage{pdfpages}
  \ifthenelse{\boolean{xetex}}{}{\pdfinclusioncopyfonts = 1}
  \includepdfset{pagecommand={\thispagestyle{plain.scrheadings}}}
}{}


\ifthenelse{\boolean{TR@todotools}}{%
  \RequirePackage[obeyDraft,colorinlistoftodos]{todonotes}
  \newcommand*\todosec{\par\noindent\todo[inline]}
  \newcommand*\secmissing{\par\noindent\todo[color=red,inline,size=\Large]}
  \newcommand\todolist[2]{%
    \par\noindent%
    \todo[inline,color={red!100!green!50},caption={#1}]{%
      \begin{minipage}{\linewidth}%
        \begin{itemize}
          #2%
        \end{itemize}
      \end{minipage}
    }%
  }
  \newcommand\todoauthor[2][\empty]{
    \expandafter\newcommand\csname #2\endcsname[2][\empty]{%
      \todo[color=#1,##1]{#2: ##2}}}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Draft Stuff
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifthenelse{\boolean{@draft}}{%
  \RequirePackage{blindtext}
  \errorcontextlines=999
  \RequirePackage{eso-pic}
  \newkomafont{draftline}{\sffamily}
  \newsavebox{\TR@draftPageLine}
  \AddToShipoutPicture{%
    \AtPageUpperLeft{%
      \raisebox{-\height}[\height][0pt]{\usebox{\TR@draftPageLine}}}%
    \AtPageLowerLeft{%
      \raisebox{\depth}[\height][0pt]{\usebox{\TR@draftPageLine}}}%
  }
  \AddToShipoutPicture{
    \begingroup
    \setlength{\@tempdima}{.5pt}%
    \setlength{\@tempdimb}{\dimexpr\paperwidth-1.75pt\relax}%
    \setlength{\@tempdimc}{\dimexpr\paperheight-1.5pt\relax}%
    \thicklines%
    \put(\LenToUnit{\@tempdima},\LenToUnit{\@tempdima}){%
      \framebox(\LenToUnit{\@tempdimb},\LenToUnit{\@tempdimc}){}}%
    \endgroup
  }
  \AtBeginDocument{
    \hypersetup{
      colorlinks = true,
      linkcolor=MidnightBlue,%
      citecolor=MidnightBlue,%
      urlcolor=MidnightBlue,%
    }
    \def\TR@draftInfo{%
      {\usekomafont{draftline}
      Draft Draft Draft%
      \hspace*{4cm}\today\hspace*{4cm}%
      Draft Draft Draft%
    }}
    \sbox{\TR@draftPageLine}{%
      \colorbox{black!10}{%
        % enlarge box vertically by 2/3 lines
        \raisebox{0pt}%
        [\dimexpr .33\baselineskip + \height]%
        [\dimexpr .33\baselineskip + \depth]{%
          \makebox[\paperwidth]{\color{black!50}\TR@draftInfo}}}}
  }
  \ifthenelse{\boolean{TR@todotools}}{
    \AtEndDocument{\listoftodos}}{}
}{
  \let\blindtext\relax
  \let\Blindtext\relax
  \let\blinddocument\relax
  \let\Blinddocument\relax
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Show the page layout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\PreventPackageFromLoading[%
\message{%
  ^^J^^JERROR: You tried to load a package that is not to be used with this class.^^J^^J}]{%
  geometry,a4,a4wide,%
  mathptmx,helvet,courier,newtxtext,newtxmath,fourier,%
  fancyhdr,%
  ae,aecompl,zefonts,times,mathptm,pslatex,palatino,mathpple,%
  utopia,euler,%
  isolatin,umlaut,t1enc,%
  epsf,psfig,epsfig,subfig,subfigure%
  fancyheadings,scrpage,caption2,glossary,SIstyle,SIunits,%
  doublespace%
}

\csgappto{bf}{\TR@fonterror}
\csgappto{it}{\TR@fonterror}
\csgappto{sc}{\TR@fonterror}
\csgappto{rm}{\TR@fonterror}
\csgappto{sc}{\TR@fonterror}
\csgappto{sf}{\TR@fonterror}
\csgappto{sl}{\TR@fonterror}
\csgappto{tt}{\TR@fonterror}

%% Warn about global use of sloppy
\let\TR@sloppy\sloppy
\patchcmd{\sloppypar}{\sloppy}{\TR@sloppy}{}{}
\patchcmd{\@arrayparboxrestore}{\sloppy}{\TR@sloppy}{}{}
\patchcmd{\thebibliography}{\sloppy}{\TR@sloppy}{}{}
\def\sloppy{\TR@warn{You should not use \string\sloppy. \MessageBreak
Instead, use a sloppypar, when necessary:\MessageBreak
\MessageBreak
\string\begin{sloppypar}\MessageBreak
\space\space...\MessageBreak
\string\end{sloppypar}}%
\TR@sloppy}

%%%%%%% Set counter to 5 (or v), respectively (See above)

\ifthenelse{\boolean{TR@inproceedingspagenumbers}}{}{%
  \setcounter{page}{5}
}
\ifcsdef{frontmatter}{
  \apptocmd{\frontmatter}{%
    \ifthenelse{\boolean{TR@inproceedingspagenumbers}}{}{%
      \setcounter{page}{5}%
    }%
  }{}{\TR@warn{Cannot patch \string\frontmatter}}
}{}

\RequirePackage{xspace}
\RequirePackage{csquotes}
\ifthenelse{\boolean{luatex}\OR\boolean{xetex}}{
  %% http://tex.stackexchange.com/a/16995
  \DeclareUTFcharacter[\UTFencname]{x201C}{\grqq}
  \DeclareUTFcharacter[\UTFencname]{x201E}{\glqq}
}{}
\PassOptionsToPackage{binary-units}{siunitx}
\AtEndPreamble{\RequirePackage{siunitx}}

\endinput
%%
%% End of file `hpitr.cls'.
