\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{polze}[2011/06/01 Class for typesetting papers and proceedings]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% name of the base class
\let\@BaseClass\@empty
%% a part document? 
\newif\if@independent
%% proceedings?
\newif\if@proceedings


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% single paper
\DeclareOption{single}{%
	\def\@BaseClass{article}
	\@independenttrue
	\@proceedingsfalse
}
%% part of the proceedings
\DeclareOption{inproceedings}{%
	\def\@BaseClass{article}
	\@independentfalse
	\@proceedingsfalse
}
%% proceedings
\DeclareOption{proceedings}{%
	\def\@BaseClass{book}
	\@independenttrue
	\@proceedingstrue
}

%% execute the standard options
\ExecuteOptions{single}

%% pass unknown options to the base class file
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@BaseClass}}

%% process the options
\ProcessOptions*


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load base class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass[a4paper, twoside, 12pt]{\@BaseClass}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Environmental variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Title
\renewcommand{\title}[1]{%
	\gdef\@title{#1}
	\ifpdf
		\hypersetup{pdftitle = {#1}}
	\fi
}
%% Author
\renewcommand{\author}[1]{%
	\gdef\@author{#1}
	\ifpdf
		\hypersetup{pdfauthor = {#1}}
	\fi
}
%% Research group
\newcommand{\group}[1]{\def\@group{#1}}
\let\@group\@empty
%% Organisation, school or institute
\newcommand{\organisation}[1]{%
	\def\@organisation{#1}
	\ifpdf
		\hypersetup{pdfproducer = {#1}}
	\fi
}
\let\@organisation\@empty
%% E-Mail address of the author
\newcommand{\email}[1]{\def\@email{#1}}
\def\@email{\@latex@warning{No \noexpand\email given}}
%% Title of the event
\newcommand{\event}[1]{%
	\def\@eventtitle{#1}
	\ifpdf
		\hypersetup{pdfsubject = {#1}}
	\fi
}
\def\@eventtitle{\@latex@warning{No \noexpand\event given}}
%% Paper number
\newcommand{\papernumber}[1]{%
	\def\@papernumber{#1}
	\ifx\@papernumber\empty
	\else
		\renewcommand*{\thepage}{\@papernumber-\arabic{page}}
	\fi
}
\let\@papernumber\@empty


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conditional statements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{ifthen}
\RequirePackage{ifpdf}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Language
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{babel}
\let\@languagetag\@empty
%% Afrikaans
\ifthenelse{\equal{\languagename}{afrikaans}}{\def\@languagetag{af}}{}
%% Bahasa
\ifthenelse{%
	\equal{\languagename}{bahasa} \or%
	\equal{\languagename}{indonesian} \or%
	\equal{\languagename}{indon} \or%
	\equal{\languagename}{bahasai} \or%
	\equal{\languagename}{bahasam} \or%
	\equal{\languagename}{malay} \or%
	\equal{\languagename}{meyalu}
}{%
	\def\@languagetag{id}
}{}
%% Basque
\ifthenelse{\equal{\languagename}{basque}}{\def\@languagetag{eu}}{}
%% Breton
\ifthenelse{\equal{\languagename}{breton}}{\def\@languagetag{br}}{}
%% Bulgarian
\ifthenelse{\equal{\languagename}{bulgarian}}{\def\@languagetag{bg}}{}
%% Catalan
\ifthenelse{\equal{\languagename}{catalan}}{\def\@languagetag{ca}}{}
%% Croatian
\ifthenelse{\equal{\languagename}{croatian}}{\def\@languagetag{hr}}{}
%% Czech
\ifthenelse{\equal{\languagename}{czech}}{\def\@languagetag{cs}}{}
%% Danish
\ifthenelse{\equal{\languagename}{danish}}{\def\@languagetag{da}}{}
%% Dutch
\ifthenelse{\equal{\languagename}{dutch}}{\def\@languagetag{nl}}{}
%% English
\ifthenelse{%
	\equal{\languagename}{english} \or%
	\equal{\languagename}{USenglish} \or%
	\equal{\languagename}{american} \or%
	\equal{\languagename}{UKenglish} \or%
	\equal{\languagename}{british} \or%
	\equal{\languagename}{canadian} \or%
	\equal{\languagename}{australian} \or%
	\equal{\languagename}{newzealand}
}{%
	\def\@languagetag{en}
}{}
%% Esperanto
\ifthenelse{\equal{\languagename}{esperanto}}{\def\@languagetag{eo}}{}
%% Estonian
\ifthenelse{\equal{\languagename}{estonian}}{\def\@languagetag{et}}{}
%% Finnish
\ifthenelse{\equal{\languagename}{finnish}}{\def\@languagetag{fi}}{}
%% French
\ifthenelse{%
	\equal{\languagename}{french} \or%
	\equal{\languagename}{francais} \or%
	\equal{\languagename}{canadien} \or%
	\equal{\languagename}{acadian}
}{%
	\def\@languagetag{fr}
}{}
%% Galician
\ifthenelse{\equal{\languagename}{galician}}{\def\@languagetag{gl}}{}
%% German
\ifthenelse{%
	\equal{\languagename}{german} \or%
	\equal{\languagename}{germanb} \or%
	\equal{\languagename}{ngerman} \or%
	\equal{\languagename}{austrian} \or%
	\equal{\languagename}{naustrian}
}{%
	\def\@languagetag{de}
	\RequirePackage{german}
}{}
%% Greek
\ifthenelse{%
	\equal{\languagename}{greek} \or%
	\equal{\languagename}{polutonikogreek}
}{%
	\def\@languagetag{el}
}{}
%% Hebrew
\ifthenelse{\equal{\languagename}{hebrew}}{\def\@languagetag{he}}{}
%% Hungarian
\ifthenelse{%
	\equal{\languagename}{magyar} \or%
	\equal{\languagename}{hungarian}
}{%
	\def\@languagetag{hu}
}{}
%% Icelandic
\ifthenelse{\equal{\languagename}{icelandic}}{\def\@languagetag{is}}{}
%% Interlingua
\ifthenelse{\equal{\languagename}{interlingua}}{\def\@languagetag{ia}}{}
%% Irish Gaelic
\ifthenelse{\equal{\languagename}{irish}}{\def\@languagetag{ga}}{}
%% Italian
\ifthenelse{\equal{\languagename}{italian}}{\def\@languagetag{it}}{}
%% Latin
\ifthenelse{\equal{\languagename}{latin}}{\def\@languagetag{la}}{}
%% North Sami
\ifthenelse{\equal{\languagename}{samin}}{\def\@languagetag{se}}{}
%% Norwegian
\ifthenelse{\equal{\languagename}{norsk}}{\def\@languagetag{no}}{}
%% Norwegian Nynorsk
\ifthenelse{\equal{\languagename}{nynorsk}}{\def\@languagetag{nn}}{}
%% Polish
\ifthenelse{\equal{\languagename}{polish}}{\def\@languagetag{pl}}{}
%% Portuguese
\ifthenelse{%
	\equal{\languagename}{portuges} \or%
	\equal{\languagename}{portuguese} \or%
	\equal{\languagename}{brazilian} \or%
	\equal{\languagename}{brazil}
}{%
	\def\@languagetag{pt}
}{}
%% Romanian
\ifthenelse{\equal{\languagename}{romanian}}{\def\@languagetag{ro}}{}
%% Russian
\ifthenelse{\equal{\languagename}{russian}}{\def\@languagetag{ru}}{}
%% Scottish Gaelic
\ifthenelse{\equal{\languagename}{scottish}}{\def\@languagetag{gd}}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{mathptmx}
\RequirePackage{courier}
\RequirePackage{helvet}
\renewcommand{\familydefault}{\sfdefault}
\RequirePackage[T1]{fontenc}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Borders
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (paper format: DIN A4 / font size: 12pt)
%% horizontal
\setlength{\hoffset}{\z@}
\setlength{\oddsidemargin}{30mm}
\setlength{\evensidemargin}{20mm}
\setlength{\textwidth}{160mm}
\setlength{\marginparwidth}{\z@}
\setlength{\marginparsep}{\z@}
%% vertical
\setlength{\voffset}{\z@}
\setlength{\topmargin}{18mm}
\setlength{\headheight}{10mm}
\setlength{\headsep}{10mm}
\setlength{\textheight}{45\baselineskip}			% 45 lines continuous text
\addtolength{\textheight}{\topskip}
\setlength{\footskip}{12mm}
\setlength{\marginparpush}{\z@}
%% Reference point adjustment
\addtolength{\oddsidemargin}{-1in}
\addtolength{\evensidemargin}{-1in}
\addtolength{\topmargin}{-1in}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Headers and footers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{fancyhdr}
%% Fancy style
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\leftmark}
\fancyhead[RO]{\rightmark}
\renewcommand{\headrulewidth}{.3\p@}
\if@independent
	\fancyfoot[LE,RO]{\thepage}    
	\fancyfoot[RE,LO]{\@eventtitle}
	\renewcommand{\footrulewidth}{.3\p@}
\else
	\renewcommand{\footrulewidth}{\z@}
\fi
%% Plain style
\fancypagestyle{plain}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{\z@}
	\if@independent
		\fancyfoot[LE,RO]{\thepage}    
		\fancyfoot[RE,LO]{\@eventtitle}  
		\renewcommand{\footrulewidth}{.3\p@}
	\else
		\renewcommand{\footrulewidth}{\z@}
	\fi
}
%% Empty style
\fancypagestyle{empty}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{\z@}
	\renewcommand{\footrulewidth}{\z@}
}
%% Header content
\if@proceedings
	\renewcommand{\chaptermark}[1]{\markboth{#1}{}}
	\renewcommand{\sectionmark}[1]{\markright{\thesection\quad #1}}
\else
	\renewcommand{\sectionmark}[1]{\markboth{\@title}{\thesection\quad #1}}
	\renewcommand{\subsectionmark}[1]{}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% include PDF Documents
%% with more than 1 page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\if@proceedings
	\RequirePackage{pdfpages}
	\pdfinclusioncopyfonts = 1
	\includepdfset{pagecommand = {\thispagestyle{plain}}}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDF links and bookmarks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{url}
\AtEndOfClass{\RequirePackage[bookmarks]{hyperref}}
%% PDF settings
\AtBeginDocument{%
	\ifpdf
		\hypersetup{%
			colorlinks = false,								%% Colors the text of links and anchors.
			pdfborder = 0 0 0,								%% The style of box around links; (0, 0, 1) defaults to a box with lines of 1pt thickness,
																	%% but the colorlinks option resets it to produce no border.
			bookmarksopenlevel = 1,							%% level (\maxdimen) to which bookmarks are open
			bookmarksnumbered = true,						%% If Acrobat bookmarks are requested, include section numbers.
			pdfkeywords = {},	 								%% Sets the document information Keywords field
			pdfcreator = {},									%% Sets the document information Creator field
			pdfproducer = {\@organisation},				%% Sets the document information Producer field
			pdflang = {\@languagetag},						%% PDF language identifier (RFC 3066)
			pdfpagemode = UseOutlines,						%% Determines how the file is opening in Acrobat; the possibilities are UseNone, UseThumbs (show thumbnails),
																	%% UseOutlines (show bookmarks), FullScreen, UseOC (PDF 1.5), and UseAttachments (PDF 1.6). If no mode
																	%% is explicitly chosen, but the bookmarks option is set, UseOutlines is used.
			pdfview  = FitV,									%% Sets the default PDF view for each link
																	%% Fit   ... Fits the page to the window.
																	%% FitH  ... Fits the width of the page to the window.
																	%% FitV  ... Fits the height of the page to the window.
																	%% FitR  ... Fits the rectangle specified by the four coordinates (left, bottom, right, top) to the window.
																	%% FitB  ... Fits the page bounding box to the window.
																	%% FitBH ... Fits the width of the page bounding box to the window.
																	%% FitBV ... Fits the height of the page bounding box to the window.
			pdfstartpage = 1,									%% Determines on which page the PDF file is opened.
			pdfstartview = Fit,								%% Set the startup page view (see 'pdfview')
			pdfdirection = L2R,								%% direction setting (an empty value disables the option)
																	%% valid values are L2R (Left to Right) and R2L (Right to Left)
			pdfduplex = DuplexFlipLongEdge,				%% paper handling option for print dialog (an empty value disables the option)
																	%% valid values are Simplex, DuplexFlipShortEdge and DuplexFlipLongEdge
			pdfnonfullscreenpagemode = UseOutlines,	%% page mode setting on exiting full-screen mode
			pdfpagelayout = OneColumn						%% set layout of PDF pages
																	%% SinglePage     ... Displays a single page; advancing flips the page
																	%% OneColumn      ... Displays the document in one column; continuous scrolling.
																	%% TwoColumnLeft  ... Displays the document in two columns, odd-numbered pages to the left.
																	%% TwoColumnRight ... Displays the document in two columns, odd-numbered pages to the right.
																	%% TwoPageLeft    ... Displays two pages, odd-numbered pages to the left (since PDF 1.5).
																	%% TwoPageRight   ... Displays two pages, odd-numbered pages to the right (since PDF 1.5).
		}
	\fi
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% References
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% well formed numeric citations
\RequirePackage{cite}
%% adds page references to 'normal' references
\RequirePackage[\languagename]{varioref}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Titlepage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\if@proceedings
\else
	\renewcommand{\maketitle}{%
		\thispagestyle{plain}
		\begin{center}
			\huge\@title\par
		\end{center}
		\vspace{1.3em}
		\begin{center}
			\small
			\@author\par
			\vspace{.4em}
			\ifx\@group\@empty\else\@group\linebreak\fi
			\ifx\@organisation\@empty\else\@organisation\linebreak\fi
			\@email\par
		\end{center}
		\vspace{.5em}
		\par
	}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% (environment: book.cls)
\if@proceedings
	%% show the header content of the page in normal style
	\renewcommand{\tableofcontents}{%
		\if@twocolumn
			\@restonecoltrue
			\onecolumn
		\else
			\@restonecolfalse
		\fi
		\chapter*{%
			\contentsname
			\markboth{\contentsname}{\contentsname}
		}
		\@starttoc{toc}
		\if@restonecol
			\twocolumn
		\fi
	}
	
	%% Entry styles
	\renewcommand{\@pnumwidth}{4em}

	%% Chapters without numbering
	\renewcommand*{\thechapter}{}
	
	\renewcommand*{\l@chapter}[2]{%
		\ifnum \c@tocdepth > \m@ne
			\addpenalty{-\@highpenalty}
			\vskip 1.0em \@plus \p@
			\setlength\@tempdima{\z@}
			\begingroup
				\parindent \z@
				\rightskip \@pnumwidth
				\parfillskip -\@pnumwidth
				\leavevmode \bfseries
				\hskip -\leftskip
				{#1}\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
				\penalty\@highpenalty
			\endgroup
		\fi
	}
	
	%% Sections without numbering
	\renewcommand*{\thesection}{}

	\renewcommand*{\l@section}[2]{%
		\ifnum \c@tocdepth > \z@
			\vskip \z@ \@plus .2\p@
			\setlength\@tempdima{\z@}
			\begingroup
				\parindent 1.5em
				\rightskip \z@
				\parfillskip \z@
				\leavevmode \mdseries
				{#1}\nobreak\hfil \nobreak\par
			\endgroup
		\fi
	}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\if@proceedings
\else
	\renewenvironment{abstract}{}{}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Footnotes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\footnoterule}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bibliographystyle{plain}

%% show the header content of the page in normal style
\renewenvironment{thebibliography}[1]{%
	\section*{\refname}
	\markboth{\refname}{\refname}
	\list{\@biblabel{\@arabic\c@enumiv}}{%
		\settowidth\labelwidth{\@biblabel{#1}}
		\leftmargin\labelwidth
		\advance\leftmargin\labelsep
		\@openbib@code
		\usecounter{enumiv}
		\let\p@enumiv\@empty
		\renewcommand\theenumiv{\@arabic\c@enumiv}
	}
	\sloppy
	\clubpenalty 4000
	\@clubpenalty \clubpenalty
	\widowpenalty 4000
	\sfcode`\.\@m
}{%
	\def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}
	\endlist
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Math mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{bm}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{hhline}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}
\RequirePackage[hang, tight, FIGBOTCAP, TABBOTCAP]{subfigure}
\renewcommand{\subfigcapskip}{3\p@}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{color}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Proceedings file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% print special information into a separate file (*.prc)
\if@independent
\else
	\AtEndDocument{%
		\addtocontents{prc}{\protect\title{\@title}}
		\addtocontents{prc}{\protect\author{\@author}}
		\addtocontents{prc}{\protect\event{\@eventtitle}}
		\addtocontents{prc}{\protect\papernumber{\@papernumber}}
		\addtocontents{prc}{\protect\file{\jobname.pdf}}
		\if@filesw
			\expandafter\newwrite\csname tf@prc\endcsname
			\immediate\openout \csname tf@prc\endcsname \jobname.prc\relax
		\fi
	}
\fi
