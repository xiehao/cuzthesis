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
\ProvidesClass{cuzopening}[2024/10/11 v2.0 LaTeX document class]%
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
\RequirePackage{tcolorbox}
\newcommand{\cuzifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\cuzifstrbk}{\expandafter\ifblank\expandafter}% expansion control
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
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
            \thispagestyle{#1}%
            \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex% use underline from xeCJKfntef
    % \renewcommand{\CJKunderlinecolor}{\color[rgb]{0,0,0}}% set underline color
    % \renewcommand{\uline}[1]{\CJKunderline{#1}}% unified name
\else% use underline from ulem
    \RequirePackage{ulem}%
\fi
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \uline{#2}}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
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
\newcommand{\authorid}[1]{\gdef\cuz@value@authorid{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\advisor}[1]{\gdef\cuz@value@advisor{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\advisortitle}[1]{\gdef\cuz@value@advisortitle{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\coadvisor}[1]{\gdef\cuz@value@coadvisor{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\coadvisortitle}[1]{\gdef\cuz@value@coadvisortitle{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\degree}[1]{\gdef\cuz@value@degree{#1}}
\newcommand{\degreetype}[1]{\gdef\cuz@value@degreetype{#1}}
\newcommand{\major}[1]{\gdef\cuz@value@major{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\class}[1]{\gdef\cuz@value@class{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\institute}[1]{\gdef\cuz@value@institute{\ifcuz@blinded\cuz@label@blindedtext\else#1\fi}}
\newcommand{\graduateyear}[1]{\gdef\cuz@value@graduateyear{#1}}
\newcommand{\openingdate}[1]{\gdef\cuz@value@openingdate{#1}}
\newcommand{\reviewdate}[1]{\gdef\cuz@value@reviewdate{#1}}

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
\newcommand{\cuz@macro@titleformat}{\zihao{-2}\heiti\centering}
\newcommand{\cuz@macro@englishtitleformat}{\zihao{3}\rmfamily\centering}
\newcommand{\cuz@macro@otherinfoformat}{\zihao{3}\songti\centering}
\newlength{\cuz@length@titlelinewidth}
\addtolength{\cuz@length@titlelinewidth}{300pt}
\newlength{\cuz@length@leftinfowidth}
\addtolength{\cuz@length@leftinfowidth}{115pt}
\newlength{\cuz@length@rightinfowidth}
\addtolength{\cuz@length@rightinfowidth}{145pt}
\renewcommand{\maketitle}{%
    \cuzifstreq{\cuz@value@degree}{学士}{%
        \def\cuz@label@thesis{\cuz@label@bacthesis}%
        \def\cuz@label@major{\cuz@label@ungradmajor}%
        \def\cuz@label@institute{\cuz@label@ungradinstitute}%
    }{%
        \cuzifstreq{\cuz@value@degree}{硕士}{%
            \def\cuz@label@thesis{\cuz@label@masthesis}%
        }{%
            \def\cuz@label@thesis{\cuz@label@docthesis}%
        }
        \def\cuz@label@major{\cuz@label@gradmajor}%
        \def\cuz@label@institute{\cuz@label@gradinstitute}%
    }%
    \cleardoublepage
    \thispagestyle{empty}
    \par
    \begin{center}
        {\cuz@value@schoollogo}
        \vfill
        {
            \zihao{-1}\heiti\bfseries%
            \cuz@label@opening%
        }
        \vfill
        \cuz@macro@otherinfoformat
        \begin{tabular}{cccc}
            \makebox[6.5em][s]{\cuz@label@author}：                                              &
            \cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@author}    &
            \makebox[2.5em][s]{\cuz@label@authorid}：                                            &
            \cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@authorid}
            \\
            \rule{0pt}{10mm}
            \makebox[6.5em][s]{\cuz@label@institute}：                                           &
            \cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@institute} &
            \makebox[2.5em][s]{\cuz@label@major}：                                               &
            \cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@major}
            \\
            \rule{0pt}{10mm}
            \makebox[6.5em][s]{\cuz@label@advisor}：                                             &
            \cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@advisor}   &
            \makebox[2.5em][s]{\cuz@label@advisortitle}：                                        &
            \cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@advisortitle}
            % \\
            % \rule{0pt}{10mm}
            % \makebox[6.5em][s]{\cuz@label@coadvisor}： &
            % \cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@coadvisor} &
            % \makebox[2.5em][s]{\cuz@label@coadvisortitle}： &
            % \cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@coadvisortitle}
        \end{tabular}\par
        \vspace{6ex}%
        \cuz@label@date\cuz@value@openingdate\par%
        \makebox[12.5em][s]{\bfseries\cuz@label@maker}%
    \end{center}
}
%---------------------------------------------------------------------------%
%->> Redefine Section and Subsection styles
%---------------------------------------------------------------------------%
\titleformat{\section}[hang]
{\normalfont\zihao{-4}\bfseries}
{\thesection、}
{0.0em}
{}
\titlespacing{\section}{0em}{2ex}{1.5ex}
\renewcommand{\thesection}{\chinese{section}}
\titleformat{\subsection}[block]
{\normalfont\zihao{-4}\bfseries}
{\thesubsection.}
{0.3em}
{}
\renewcommand{\thesubsection}{\arabic{subsection}}
%---------------------------------------------------------------------------%
%->> Customized bibliography settings
%---------------------------------------------------------------------------%
% \ifcuz@plain%
%     \def\bibetal{\cuz@value@englishbibetal}
%     \def\biband{\cuz@value@englishbiband}
% \else%
%     \def\bibetal{\cuz@value@chinesebibetal}
%     \def\biband{\cuz@value@chinesebiband}
% \fi
% \RequirePackage{xpatch}
%     \xapptocmd{\NAT@bibsetnum}{
%         \setlength{\leftmargin}{0pt}
%         \setlength{\itemindent}{\labelwidth}
%         \addtolength{\itemindent}{\labelsep}
%     }{}{}
\AfterEndPreamble{
    \renewcommand{\bibsection}{\vspace{-1.2ex}}
    \renewcommand{\bibfont}{\zihao{-4}}
}
%---------------------------------------------------------------------------%
\tcbuselibrary{most}
\endinput

