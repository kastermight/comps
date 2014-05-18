\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myarticleREFnum}[2003/07/16 v2.80 SPIE Proceedings class]

\LoadClassWithOptions{article}  % build on standard article class


% setting counter for alphabetic page numbering
\newcounter{apg}
\setcounter{apg}{1}
\def\ps@myheadings{%
    \def\@oddfoot{\hfil\thepage\hfil}%
    \def\@evenfoot{\hfil\thepage\hfil}%
    \def\@evenhead{\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil}%
    \let\@mkboth\@gobbletwo
    \let\sectionmark\@gobble
    \let\subsectionmark\@gobble
    }

\renewcommand\thesection      {\@Roman\c@section.} 
\renewcommand\thesubsection   {\hspace{6pt}\@roman\c@subsection.} 
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {1.3ex \@plus.2ex}%
                                   {\normalfont\Large\bf}}
\renewcommand\subsection{\@startsection {subsection}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {1.3ex \@plus.2ex}%
                                   {\normalfont\large\bf}}

%%%% Add theorem, lemma, and definition environments %%%%
% kmh - noindent
\def\@begintheorem#1#2{
   \par\noindent\bgroup{\sc #1\ #2. }\it\ignorespaces}
\def\@opargbegintheorem#1#2#3{
   \par\bgroup{\sc #1\ #2\ (#3). }\it\ignorespaces}
\def\@endtheorem{\egroup}
\def\proof{\par{\it Proof}. \ignorespaces}
\def\endproof{{\ \vbox{\hrule\hbox{%
   \vrule height1.3ex\hskip0.8ex\vrule}\hrule
  }}\par}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{definition}[theorem]{Definition}
%%%% Citations are superscripts (from aip.sty) %%%%
\def\@cite#1#2{\unskip\nobreak\relax
    \def\@tempa{$\m@th^{\hbox{\the\scriptfont0 #1}}$}%
    \futurelet\@tempc\@citexx}
\def\@citexx{\ifx.\@tempc\let\@tempd=\@citepunct\else
    \ifx,\@tempc\let\@tempd=\@citepunct\else
    \let\@tempd=\@tempa\fi\fi\@tempd}
\def\@citepunct{\@tempc\edef\@sf{
    \spacefactor=\the\spacefactor\relax}\@tempa
    \@sf\@gobble}

% \citenum emits the plain citation number without ornament
% \citea puts its argument into the ornamentation for citations
% thus \cite{foo} is equivalent to \citea{\citenum{foo}}
\def\citenum#1{{\def\@cite##1##2{##1}\cite{#1}}}
\def\citea#1{\@cite{#1}{}}

% Collapse citation numbers to ranges.  Non-numeric and undefined labels
% are handled.  No sorting is done.  E.g., 1,3,2,3,4,5,foo,1,2,3,?,4,5
% gives 1,3,2-5,foo,1-3,?,4,5
\newcount\@tempcntc
\def\@citexzzz[#1]#2{\if@filesw\immediate\write\@auxout{\string\citation{#2}}\fi
  \@tempcnta\z@\@tempcntb\m@ne\def\@citea{}\@cite{\@for\@citeb:=#2\do
    {\@ifundefined
       {b@\@citeb}{\@citeo\@tempcntb\m@ne\@citea\def\@citea{,}{\bf ?}\@warning
       {Citation `\@citeb' on page \thepage \space undefined}}%
    {\setbox\z@\hbox{\global\@tempcntc0\csname b@\@citeb\endcsname\relax}%
     \ifnum\@tempcntc=\z@ \@citeo\@tempcntb\m@ne
       \@citea\def\@citea{,}\hbox{\csname b@\@citeb\endcsname}%
     \else
      \advance\@tempcntb\@ne
      \ifnum\@tempcntb=\@tempcntc
      \else\advance\@tempcntb\m@ne\@citeo
      \@tempcnta\@tempcntc\@tempcntb\@tempcntc\fi\fi}}\@citeo}{#1}}
\def\@citeozzz{\ifnum\@tempcnta>\@tempcntb\else\@citea\def\@citea{,}%
  \ifnum\@tempcnta=\@tempcntb\the\@tempcnta\else
   {\advance\@tempcnta\@ne\ifnum\@tempcnta=\@tempcntb \else \def\@citea{--}\fi
    \advance\@tempcnta\m@ne\the\@tempcnta\@citea\the\@tempcntb}\fi\fi}


% begin citesort.sty
% A replacement for \@citex which sorts citation numbers as well as
% compressing and allowing breaks.  Based on cite.sty by Donald
% Arseneau.
%
% for use in LaTeX say, \documentstyle[...,citesort,...]{...}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Allow, but strongly discourage, line breaks within a long
%     series of citations.  Compress lists of successive numbers
%     to one number range, e.g., 5,6,7,8,9 --> 5--9.  Compatible
%     with versions of \@cite that use exponents.
%              -- Donald Arseneau  1989
%
% Modified to sort the numbers so they come out in increasing order,
% regardless of the way they appear in the source. O(N^2) sort!
% Ian Green, CUED, 10-Dec-1991.  Improvements to img@eng.cam.ac.uk
% please. Version 1

\newcount\@minsofar
\newcount\@min
\newcount\@cite@temp
\def\@citex[#1]#2{%
\if@filesw \immediate \write \@auxout {\string \citation {#2}}\fi
\@tempcntb\m@ne \let\@h@ld\relax \def\@citea{}%
\@min\m@ne%
\@cite{%
  \@for \@citeb:=#2\do {\@ifundefined {b@\@citeb}%
    {\@h@ld\@citea\@tempcntb\m@ne{\bf ?}%
    \@warning {Citation `\@citeb ' on page \thepage \space undefined}}%
{\@minsofar\z@ \@for \@scan@cites:=#2\do {%
  \@ifundefined{b@\@scan@cites}%
    {\@cite@temp\m@ne}
    {\@cite@temp\number\csname b@\@scan@cites \endcsname \relax}%
\ifnum\@cite@temp > \@min% select the next one to list
    \ifnum\@minsofar = \z@
      \@minsofar\number\@cite@temp
      \edef\@scan@copy{\@scan@cites}\else
    \ifnum\@cite@temp < \@minsofar
      \@minsofar\number\@cite@temp
      \edef\@scan@copy{\@scan@cites}\fi\fi\fi}\@tempcnta\@min
  \ifnum\@minsofar > \z@ % some more
    \advance\@tempcnta\@ne
    \@min\@minsofar
    \ifnum\@tempcnta=\@minsofar %   Number follows previous--hold on to it
      \ifx\@h@ld\relax
        \edef \@h@ld{\@citea\csname b@\@scan@copy\endcsname}%
      \else \edef\@h@ld{\ifmmode{-}\else--\fi\csname b@\@scan@copy\endcsname}%
      \fi
    \else \@h@ld\@citea\csname b@\@scan@copy\endcsname
          \let\@h@ld\relax
  \fi % no more
\fi}%
\def\@citea{,\penalty\@highpenalty\,}}\@h@ld}{#1}}


%\newlength\abovecaptionskip
%\newlength\belowcaptionskip
\setlength\abovecaptionskip{0\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\footnotesize #1. #2}%
  \ifdim \wd\@tempboxa >\hsize
   {\footnotesize  #1. #2}\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}


% end of citesort.sty

%% end of spie.cls
