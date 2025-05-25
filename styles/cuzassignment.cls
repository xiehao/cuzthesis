%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Hao XIE <oaheix@gmail.com>
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{cuzassignment}[2024/10/18 v2.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{singlesided}{% enable single-sided printing
    \PassOptionsToClass{oneside}{ctexbook}%
}
\newif\ifcuz@doublesided \cuz@doublesidedfalse
\DeclareOption{doublesided}{% enable double-sided printing
    \PassOptionsToClass{twoside}{ctexbook}%
    \cuz@doublesidedtrue%
}
\newif\ifcuz@hdr \cuz@hdrfalse
\DeclareOption{cuzhdr}{% enable cuz-styled header and footer
    \cuz@hdrtrue%
}
\newif\ifcuz@printcopy \cuz@printcopyfalse
\DeclareOption{printcopy}{% enable print copy layout
    \PassOptionsToClass{twoside}{ctexbook}%
    \cuz@printcopytrue%
}
\newif\ifcuz@plain \cuz@plainfalse
\DeclareOption{plain}{
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \cuz@plaintrue%
}
\newif\ifcuz@blinded \cuz@blindedfalse
\DeclareOption{blinded}{
    \cuz@blindedtrue%
}
%-
%-> Draft version info
%-
\newif\ifcuz@versioninfo \cuz@versioninfofalse
\DeclareOption{draftversion}{%
    \cuz@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\RequirePackage{textcase}% Uppercase and lowercase letters
\RequirePackage{hologo}% Some useful logos
\RequirePackage{framed}% Framed paragraphs
\RequirePackage{lineno}
\RequirePackage{setspace}
\RequirePackage{multirow}
\RequirePackage{titlesec}
\RequirePackage{lipsum}
\RequirePackage{longtable}
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\RequirePackage{styles/cuzcommon}% common definitions
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{styles/cuzthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
% %- part one -- horizontal widths
% %- left side width + textwidth + right side width = paperwidth
% %- binding side width + textwidth + nonbinding side width = paperwidth
% %- binding side width of [odd, even] page = [left, right] side width
% %- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
% %- assuming A4 paper (210mm x 297mm)
% \setlength{\textwidth}{160mm}% set required text width first
% \setlength{\hoffset}{0mm}% set horizontal offset
% \ifcuz@printcopy% if print copy layout enabled
%     \setlength{\oddsidemargin}{12.6mm}% binding side margin
%     \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
% \else
%     \setlength{\oddsidemargin}{0mm}% left side margin
%     \setlength{\evensidemargin}{0mm}% ensure uniform left side width for EThesis
% \fi
% % \setlength{\marginparwidth}{35pt}% width of margin notes
% % \setlength{\marginparsep}{10pt}% width of space between body text and margin notes
% %- part two -- vertical heights
% %- top height + textheight + bottom height = paperheight
% %- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep
% \setlength{\textheight}{246.2mm}% set required text height first
% \setlength{\voffset}{-17.4mm}% set vertical offset
% \setlength{\topmargin}{20pt}% vertical margin above header
% \setlength{\headheight}{12pt}% header height
% \setlength{\headsep}{17.5pt}% vertical margin between header and body text
% \setlength{\footskip}{29.5pt}% vertical margin between footer and body text
% %- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.0\baselineskip}
% %- line spacing
\linespread{1.25}% line space setting
% \raggedbottom% prevent adding vertical white space in strange places
% %- default pagestyle is page number at bottom without headers and footers
% \pagestyle{plain}
\RequirePackage[a4paper, margin=2.5cm]{geometry}
%---------------------------------------------------------------------------%
%->> Page headers and footers
%---------------------------------------------------------------------------%
\ifcuz@hdr% user defined header and footer style
    \RequirePackage{fancyhdr}
    \RequirePackage{lastpage}
    \pagestyle{fancy}%
    \providecommand{\chaptermark}{}% compatibility for non-book classes
    \providecommand{\thechapter}{}% compatibility for non-book classes
    \providecommand{\CTEXthechapter}{\thechapter.}% compatibility for non ctex classes
    %- reset style of chapter and section mark to actual name
    \renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{#1}}{}}%
    % \renewcommand{\sectionmark}[1]{\markright{\MakeUppercase{#1}}{}}%
    %- deactivate uppercase effect
    \renewcommand{\MakeUppercase}[1]{#1}%
    \fancypagestyle{nostyle}{% header and footer style for no footer
        \fancyhf{}% clear fields
        % \fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        % \fancyhead[REO]{\footnotesize \@title}% structure elements
        % \fancyfoot[LEO]{\footnotesize \thepage}% page number
        % \fancyfoot[REO]{\footnotesize \thepage}% page number
        \renewcommand{\headrulewidth}{0pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \nomatter to include the change
    \providecommand{\nomatter}{}% compatibility for non-book classes
    \let\cuznomatter\nomatter%
    \renewcommand{\nomatter}{%
        \cuznomatter%
        \pagestyle{nostyle}%
    }
\fi
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- Common style commands are defined in cuzcommon.sty
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-

% \newcommand{\cuzunderline}[2][\cuz@length@otherinfowidth]{
%     \uline{\hbox to #1{\hss#2\hss}}\hskip3pt
% }
\newcommand{\confidential}[1]{\gdef\cuz@value@confidential{#1}}
\newcommand{\schoollogo}[2]{
    \gdef\cuz@value@schoollogo{
        \ifcuz@blinded
            \vspace*{4.5em}
        \else
            \includegraphics[width=#1\textwidth]{#2}
        \fi
    }
}
\renewcommand{\title}[2][\cuz@value@title]{%
    \gdef\cuz@value@title{#2}
    \gdef\cuz@value@titlemark{\MakeUppercase{#1}}
}
\newcommand{\englishtitle}[1]{\gdef\cuz@value@englishtitle{#1}}
\renewcommand{\@title}{\cuz@value@titlemark}
\renewcommand{\author}[1]{\gdef\cuz@value@author{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
%- Other common commands are defined in cuzcommon.sty

% Define a macro for underlined text with adaptive multilines
% #1: The width of text line, not text itself (set by paper)
% #2: The thickness of text line (set by paper)
% #3: The content of text (set by user)
\def\cuz@macro@exmultiunderline#1#2#3{
    \begin{minipage}[t][][t]{#1}
        \centering\internallinenumbers
        \renewcommand{\makeLineNumber}{\rule[-0.6ex]{\textwidth}{#2}\hss}
        #3\par
    \end{minipage}
}
%- Assignment-specific formatting (different from common definitions)
\newcommand{\cuz@macro@otherinfoformat}{\zihao{4}\songti\centering}
\newlength{\cuz@length@leftinfowidth}
\addtolength{\cuz@length@leftinfowidth}{14em}
\newlength{\cuz@length@rightinfowidth}
\addtolength{\cuz@length@rightinfowidth}{13em}
\renewcommand{\maketitle}{%
    \cleardoublepage
    \thispagestyle{empty}
    \par
    \begin{center}
        {
            \zihao{-1}\weibei\bfseries
            \cuz@label@university
            \vspace{1.5ex}
        } \par
        {
            \zihao{-2}\heiti\bfseries%
            \cuz@label@assignment%
            \vspace{1.5ex}
        } \par
        {
            \cuz@macro@otherinfoformat
            \newcommand{\cuz@padding}{\hspace{-1em}}
            \begin{tabular}{cccc}
                \cuz@padding\makebox[4em][s]{\cuz@label@major}                                               &
                \cuz@padding\cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@major}  &
                \cuz@padding\makebox[4em][s]{\cuz@label@class}                                               &
                \cuz@padding\cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@class}
                \\
                \rule{0pt}{3.5ex}
                \cuz@padding\makebox[4em][s]{\cuz@label@author}                                              &
                \cuz@padding\cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@author} &
                \cuz@padding\makebox[4em][s]{\cuz@label@advisor}                                             &
                \cuz@padding\cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@advisor}
            \end{tabular}\par
        }
    \end{center}
}
%---------------------------------------------------------------------------%
%->> Redefine Section and Subsection styles
%---------------------------------------------------------------------------%
\titleformat{\section}[hang]
{\normalfont\zihao{-4}}
{\thesection、}
{0.0em}
{}
\titlespacing{\section}{0em}{2ex}{1.5ex} % BUG: the spacing above section title has no effect, only if no contents are above the first \section
\renewcommand{\thesection}{\chinese{section}}
\titleformat{\subsection}[block]
{\normalfont\zihao{-4}}
{\thesubsection.}
{0.3em}
{}
\renewcommand{\thesubsection}{\arabic{subsection}}
%---------------------------------------------------------------------------%
%->> Customized bibliography settings
%---------------------------------------------------------------------------%
\ifcuz@plain%
    \def\bibetal{\cuz@value@englishbibetal}
    \def\biband{\cuz@value@englishbiband}
\else%
    \def\bibetal{\cuz@value@chinesebibetal}
    \def\biband{\cuz@value@chinesebiband}
\fi
\AfterEndPreamble{
    \renewcommand{\bibsection}{\vspace{-1.2ex}}
    \renewcommand{\bibfont}{\zihao{5}}
	\renewcommand{\thefigure}{\arabic{figure}}% configure the label style
	\renewcommand{\thetable}{\arabic{table}}% configure the label style
}
\tcbuselibrary{most}
%---------------------------------------------------------------------------%
\endinput

