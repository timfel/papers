%%
%%
%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
% \ifx\swathesisloaded\undefined
% \else
% \message{^^J==^^JLoading from format.}
% \swathesisloaded
% \expandafter\endinput\fi
% \RequirePackage[l2tabu, orthodox, experimental]{nag}
% %%%this nag does not work.
% \makeatletter\let\@largefloatcheck\relax\makeatother
\ProvidesClass{swathesis}[2011/11/29 v0.1
^^J LaTeX document class for Theses at the SWA Group]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrbook}}

\ProcessOptions

\RequirePackage{expl3} 
\RequirePackage{etoolbox}

\providecommand*\printmode{false}


\LoadClass{scrbook}
% \newcommand\swathesis@doits{}
% \newcommand\swathesis@dyn[1]{%
%   \def\@tempa{#1}
%   \message{Recording: \meaning\@tempa ^^J^^J}
%   \ifundefinedorrelax{endofdump}%
%   {#1}%
%   {\g@addto@macro\swathesis@doits{{\swa@do{#1}}}}}
% \newcommand\swathesisloaded{%
% \long\def\swa@do##1{\def\@tempa{##1}\message{Replay \meaning\@tempa ^^J}}\swathesis@doits{}%
% \long\def\swa@do##1{##1}\swathesis@doits{}%
% }



\RequirePackage{swa-platform}
\RequirePackage{swa-language}
\RequirePackage{swa-document}


\RequirePackage{swa-graphics}
\RequirePackage{swa-listings}

\RequirePackage{swa-font}
\RequirePackage{swa-font-garamond}
\RequirePackage{swa-abstract}
\RequirePackage{swa-acronyms}

\RequirePackage{swa-bibliography}

% koma-hacks
\RequirePackage{scrhack}

% undo babel thing in tocbasic
\unsettoc{toc}{nobabel}
\unsettoc{lof}{nobabel}
\unsettoc{lot}{nobabel}

\setuptoc{toc}{noprotrusion}
\setuptoc{lof}{noprotrusion}
\setuptoc{lot}{noprotrusion}
\setuptoc{lol}{noprotrusion}
\setuptoc{loa}{noprotrusion}

\tocbasicautomode




\newcommand\hairspace{\ifmmode\mskip1mu\else\kern0.08em\fi}
\RequirePackage{xspace}



%\recalctypearea
\raggedbottom

%redo document stuff:
\ifundefinedorrelax{hypersetup}{}{%
\let\swa@document\document
\gdef\document{%
  \hypersetup{
      pdftitle={\@title{}: \@subtitle},
      pdfauthor={\@author},
      pdfsubject={\@subject}
    }
  \swa@document%
  }
}

\csname
endofdump\endcsname

%%% Local Variables: 
%%% mode: latex
%%% End: 
