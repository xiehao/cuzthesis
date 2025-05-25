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
\ProvidesClass{cuzthesis}[2019/01/07 v2.0 LaTeX document class]%
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
\newif\ifcuz@showcoadvisor \cuz@showcoadvisortrue
\DeclareOption{nocoadvisor}{
    \cuz@showcoadvisorfalse%
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
\RequirePackage{adjustbox}% for image alignment
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
    \renewcommand{\sectionmark}[1]{\markright{\MakeUppercase{#1}}{}}%
    %- deactivate uppercase effect
    \renewcommand{\MakeUppercase}[1]{#1}%
    %- Define different kinds of header and footer for different parts
    \fancypagestyle{frontmatterstyle}{% style for frontmatter
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        \fancyfoot[LEO]{\footnotesize \cuz@footer@author{\cuz@value@author}}% page number
        \fancyfoot[REO]{\footnotesize \cuz@footer@pagenumber{\thepage\ }{\pageref{LastPage}\ }}% page number
        \renewcommand{\headrulewidth}{0.8pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \frontmatter to include the change
    \providecommand{\frontmatter}{}% compatibility for non-book classes
    \let\cuzfrontmatter\frontmatter%
    \renewcommand{\frontmatter}{%
        \cuzfrontmatter%
        \pagestyle{frontmatterstyle}%
    }
    \fancypagestyle{mainmatterstyle}{% style for mainmatter
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        \fancyfoot[LEO]{\footnotesize \cuz@footer@author{\cuz@value@author}}% page number
        \fancyfoot[REO]{\footnotesize \cuz@footer@pagenumber{\thepage\ }{\pageref{LastPage}\ }}% page number
        \renewcommand{\headrulewidth}{0.5pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \mainmatter to include the change
    \providecommand{\mainmatter}{}% compatibility for non-book classes
    \let\cuzmainmatter\mainmatter%
    \renewcommand{\mainmatter}{%
        \cuzmainmatter%
        \pagestyle{mainmatterstyle}%
    }
    \fancypagestyle{backmatterstyle}{% header and footer style for backmatter
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        \fancyfoot[LEO]{\footnotesize \cuz@footer@author{\cuz@value@author}}% page number
        \fancyfoot[REO]{\footnotesize \cuz@footer@pagenumber{\thepage\ }{\pageref{LastPage}\ }}% page number
        \renewcommand{\headrulewidth}{0.5pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \backmatter to include the change
    \providecommand{\backmatter}{}% compatibility for non-book classes
    \let\cuzbackmatter\backmatter%
    \renewcommand{\backmatter}{%
        \cuzbackmatter%
        \pagestyle{backmatterstyle}%
    }
    %- Some Latex commands, like \chapter, use the \thispagestyle command
    %- to automatically switch to the plain page style, thus ignoring the
    %- page style currently in effect. To customize such pages you must
    %- redefine the plain pagestyle. If you want the plain style inherits
    %- the current style, comment all the lines in plain style definition.
    \fancypagestyle{plain}{%
        %\fancyhf{}% clear fields
        %\renewcommand{\headrulewidth}{0pt}% header rule
        %\renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \plainmatter to include the change
    \providecommand{\plainmatter}{}% compatibility for non-book classes
    \let\cuzplainmatter\plainmatter%
    \renewcommand{\plainmatter}{%
        \cuzplainmatter%
        \pagestyle{plain}%
    }
    \fancypagestyle{noheaderstyle}{% header and footer style for no header
        \fancyhf{}% clear fields
        %\fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        %\fancyhead[REO]{\footnotesize \@title}% structure elements
        \fancyfoot[LEO]{\footnotesize \cuz@footer@author{\cuz@value@author}}% page number
        \fancyfoot[REO]{\footnotesize \cuz@footer@pagenumber{\thepage\ }{\pageref{LastPage}\ }}% page number
        \renewcommand{\headrulewidth}{0pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \noheadermatter to include the change
    \providecommand{\noheadermatter}{}% compatibility for non-book classes
    \let\cuznoheadermatter\noheadermatter%
    \renewcommand{\noheadermatter}{%
        \cuznoheadermatter%
        \pagestyle{noheaderstyle}%
    }
    \fancypagestyle{nofooterstyle}{% header and footer style for no footer
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \ifcuz@blinded\cuz@label@blindedtext\else\cuz@label@university\fi\cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        % \fancyfoot[LEO]{\footnotesize \thepage}% page number
        % \fancyfoot[REO]{\footnotesize \thepage}% page number
        \renewcommand{\headrulewidth}{0.5pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    %- Redefine \nofootermatter to include the change
    \providecommand{\nofootermatter}{}% compatibility for non-book classes
    \let\cuznofootermatter\nofootermatter%
    \renewcommand{\nofootermatter}{%
        \cuznofootermatter%
        \pagestyle{nofooterstyle}%
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
\newcommand{\declaredate}[1]{\gdef\cuz@value@declaredate{#1}}
\newcommand{\signature}[1]{\gdef\cuz@value@signature{#1}}
%-
%-> Redefine Chinese style
%-
% \newcounter{iline}
% \newcounter{numbertitlelines}
% \newcount\numbertitlelines
% \newbox\titlebox
% Define a macro to calculate the number of title lines
% #1: The length of title line (set by paper)
% #2: The text of title (set by user)
% \def\cuz@macro@numbertitlelines#1#2{
%     \setbox\titlebox=\vbox{\hsize=#1 \cuz@macro@titleformat
%         #2\par
%         \global\numbertitlelines=\the\prevgraf
%     }
%     \setcounter{numbertitlelines}{\the\numbertitlelines}
% }
% Define a macro to calculate the lift of title rules
% #1: The number of title lines (calculated by \cuz@macro@numbertitlelines)
% #2: The base height (set by user)
% #2: The height of one line (set by user)
% \newlength{\titlerulelift}
% \def\cuz@macro@titlerulelift#1#2#3{
%     \setlength{\titlerulelift}{#2}
%     \setcounter{iline}{1}
%     \@whilenum\value{iline}<\value{#1}\do{
%         \stepcounter{iline}
%         \addtolength{\titlerulelift}{#3}
%     }
% }
% Define a macro to calculate the total title height
% #1: The number of title lines (calculated by \cuz@macro@numbertitlelines)
% #2: The base height (set by user)
% #2: The height of one line (set by user)
% \newlength{\titleheight}
% \def\cuz@macro@titleheight#1#2#3{
%     \setlength{\titleheight}{#2}
%     \setcounter{iline}{1}
%     \@whilenum\value{iline}<\value{#1}\do{
%         \stepcounter{iline}
%         \addtolength{\titleheight}{#3}
%     }
% }
% Define a macro for underlined title with adaptive multilines
% #1: The length of title line (set by paper)
% #2: The thickness of title line (set by paper)
% #3: The text of title (set by user)
% \def\cuz@macro@multiunderline#1#2#3{
%     \cuz@macro@titleformat
%     \cuz@macro@numbertitlelines{#1}{#3}
%     \cuz@macro@titlerulelift{numbertitlelines}{3.5ex}{4.0ex}
%     \def\ULthickness{#2}
%     \centering #3 \\
%     \raisebox{\titlerulelift}[0pt][0pt]{
%         \parbox[t][][t]{#1}{
%             \setcounter{iline}{0}
%             \@whilenum\value{iline}<\value{numbertitlelines}\do{
%                 \stepcounter{iline}
%                 \rule{#1}{\ULthickness}\\
%             }
%         }
%     }
% }

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
            \def\cuz@label@major{\cuz@label@gradmajor}%
            \def\cuz@label@institute{\cuz@label@gradinstitute}%
        }{%
            \def\cuz@label@thesis{\cuz@label@docthesis}%
            \def\cuz@label@major{\cuz@label@gradmajor}%
            \def\cuz@label@institute{\cuz@label@gradinstitute}%
        }}%
    \cleardoublepage
    \thispagestyle{empty}
    \par
    \begin{center}
        {\cuz@value@schoollogo}\par
        \vspace{24mm}
        {
            {\lishu \zihao{-0} \bfseries \cuz@label@thesis} \par
            \vspace{5mm}
            {\heiti \zihao{-2} (\;\cuz@value@graduateyear 届\;)}
        }\par
    \end{center}
    \vspace{4mm}
    \begin{center}
        \begin{tabular}[t]{>{\zihao{2}\heiti\mdseries}rc}
            \cuz@label@thesistitle & {
                    \cuz@macro@titleformat
                    \cuz@macro@exmultiunderline{\cuz@length@titlelinewidth}{0.8pt}{\cuz@value@title}
            }                          \\%
            \rule{0pt}{4.5ex}      & {
                    \cuz@macro@englishtitleformat
                    \cuz@macro@exmultiunderline{\cuz@length@titlelinewidth}{0.8pt}{\MakeTextUppercase{\cuz@value@englishtitle}}
            }                          \\
        \end{tabular}
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
            \\
            \ifcuz@showcoadvisor
            \rule{0pt}{10mm}
            \makebox[6.5em][s]{\cuz@label@coadvisor}： &
            \cuz@macro@exmultiunderline{\cuz@length@leftinfowidth}{0.6pt}{\cuz@value@coadvisor} &
            \makebox[2.5em][s]{\cuz@label@coadvisortitle}： &
            \cuz@macro@exmultiunderline{\cuz@length@rightinfowidth}{0.6pt}{\cuz@value@coadvisortitle}
            \fi
        \end{tabular}
    \end{center}
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{2}
        \songti\zihao{4}
        \vspace*{3ex}

        \begin{center}
            {
                \heiti\zihao{-2}\bfseries\sffamily\makebox[6em][s]{\cuz@value@declare@create}
            }
        \end{center}
        \vspace{3ex}

        {\cuz@value@declare@creativity}

        \vspace{4ex}
        {
            \heiti\zihao{-3}\bfseries\sffamily
            % \hfill{} {\cuz@value@declare@s \hspace*{8em}}
            % \vspace{1ex}

            % \hfill{} {\cuz@value@declare@d \hspace*{8em}}
            \renewcommand\arraystretch{1.3}
            \begin{tabular}{@{}p{0.4\linewidth}cl@{}}
                 & \cuz@value@declare@s & \ifdefined\cuz@value@signature\adjustbox{valign=m}{\includegraphics[width=6em]{\cuz@value@signature}}\fi \\
                 & \multicolumn{2}{r}{\ifdefined\cuz@value@declaredate\cuz@value@declaredate\else\cuz@value@declare@d\fi} \\
            \end{tabular} \par
        }
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- define spacing and length
\def\@dotsep{1mu}% spacing for dots
\def\@pnumwidth{1em}% spacing between titles and page numbers
\def\@tocrmarg{1em}% right margin indentation
\def\@chaptervspace{1ex}% spacing between chapter titles
%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
            \parindent #2\relax\@afterindenttrue
            \interlinepenalty\@M
            \leavevmode \zihao{-4}%\sffamily
            \@tempdima #3\relax
            \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
            {#4}\nobreak
            % \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}
            \leaders\hbox{$\m@th\mkern \@dotsep \hbox{.}\mkern \@dotsep$}
            \hfill
            \nobreak
            \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
            \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
        \parindent \z@ \rightskip \@pnumwidth
        \parfillskip -\@pnumwidth
        {
            \leavevmode\zihao{-4}%\sffamily
            #1
            % \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \leaders\hbox{$\m@th\mkern \@dotsep \hbox{.}\mkern \@dotsep$}
            \hfil \hb@xt@\@pnumwidth{\hss #2}
        }\par
        \nobreak
        \global\@nobreaktrue
        \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        % \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
        \parindent \z@ \rightskip \@pnumwidth
        \parfillskip -\@pnumwidth
        \leavevmode \zihao{-4}%\sffamily
        \advance\leftskip\@tempdima
        \hskip -\leftskip
        #1\nobreak
        % \leaders\hbox{$\m@th\mkern \@dotsep \cdots\mkern \@dotsep$}% add dotted toc line
        \leaders\hbox{$\m@th\mkern \@dotsep \hbox{.}\mkern \@dotsep$}
        \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
        \penalty\@highpenalty
        \endgroup
    \fi
}
\renewcommand*\l@section{\@dottedtocline{1}{2em}{2.1em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4em}{3em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{6em}{3.8em}}
%---------------------------------------------------------------------------%
%->> Redefine Chapter styles
%---------------------------------------------------------------------------%
\renewcommand\chapter{%
  \ifcuz@doublesided\cleardoublepage\else\clearpage\fi%
  \phantomsection	%
  \global\@topnum\z@ %
  \@afterindenttrue % indentation of the first paragraph
  \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
        \if@mainmatter
            \refstepcounter{chapter}%
            \addcontentsline{toc}{chapter}{\protect\numberline{\CTEXthechapter}#1}
        \else
            \addcontentsline{toc}{chapter}{#1}%
        \fi
    \else
        \addcontentsline{toc}{chapter}{#1}%
    \fi
    \chaptermark{#1}%
    % add 10pt space at the corresponding position of figure list and table list
    %\addtocontents{lof}{\protect\addvspace{10\p@}}%
    %\addtocontents{lot}{\protect\addvspace{10\p@}}%
    \@makechapterhead{#2}
    \@afterheading
}
\def\@makechapterhead#1{%
    % \vspace{1.5ex} %\vspace*{20\p@}%
    {
            \parindent \z@ % \centering
            \songti\zihao{4}\bfseries\rmfamily
            \ifnum \c@secnumdepth >\m@ne
                \if@mainmatter
                    \CTEXthechapter \hskip 0.5em%
                \fi
            \fi
            \interlinepenalty\@M
            #1\par\nobreak
        }
    \vspace{.6ex}
}
\def\@schapter#1{%
    \@makeschapterhead{#1}
    \@afterheading
}
\def\@makeschapterhead#1{%
    % \vspace*{1.5ex} % \vspace*{20\p@}%
    {
            \parindent \z@ \centering
            \heiti\zihao{3}\bfseries%\sffamily
            \interlinepenalty\@M
            #1\par\nobreak
        }
    % \vspace{1.5ex} % \vskip 24\p@
}
%---------------------------------------------------------------------------%
%->> Define some useful environments
%---------------------------------------------------------------------------%
%- define Chinese keywords
\newcommand{\chinesekeywords}[1]{%
    % \vspace{\baselineskip}
    {\bfseries\cuz@label@chinesekeywords} #1
}
%- define Chinese abstract
\newenvironment{chineseabstract}[1]{%
    \clearpage
    % \setlength{\parskip}{0.0\baselineskip}
    \begin{center}
        \zihao{3}\heiti\cuz@value@title
    \end{center}
    \par
    % \vspace{2ex}
    {\bfseries\cuz@label@chineseabstract：}%\hspace{-0.8em}
    \def\temp{\chinesekeywords{#1}}
}{
    \par\temp\par
}
%- define Engish keywords
\newcommand{\englishkeywords}[1]{%
    % \vspace{\baselineskip}
    {\bfseries\cuz@label@englishkeywords} #1
}
%- define English abstract
\newenvironment{englishabstract}[1]{%
    % \vspace{8ex} % no clear page, right after the Chinese abstract, a wired style.
    % \setlength{\parskip}{0.0\baselineskip}
    \begin{center}
        \zihao{3}\bfseries\MakeTextUppercase{\cuz@value@englishtitle}
    \end{center}
    \par
    % \vspace{2ex}
    {\bfseries\cuz@label@englishabstract:}\hspace{-.5em}
    \def\temp{\englishkeywords{#1}}
}{
    \par\temp\par
}
%- define acknowledgement
\newenvironment{acknowledgement}{
    \intotoc{\cuz@label@acknowledgement}% should be placed first
    \chapter*{\songti\cuz@label@acknowledgement}
    \chaptermark{\cuz@label@acknowledgement}
    \vspace{2ex}
    % \linespread{1.3}
    % \renewcommand{\baselinestretch}{1.3}
    % \setlength{\parskip}{0.4\baselineskip}
    % \selectfont
}{
    \par
}
%- define appendices
\newenvironment{appendices}{
    \intotoc{\cuz@label@appendices}% should be placed first
    \chapter*{\songti\cuz@label@appendices}
    \chaptermark{\cuz@label@appendices}
    \vspace{2ex}
    \setcounter{equation}{0}
}{
    \par
}
\newenvironment{cuzchapter}[2]{
    \chapter{#1}
    \label{#2}
    % \renewcommand{\baselinestretch}{1.3}
    % \setlength{\parskip}{0.4\baselineskip}
    % \selectfont
}{
    \par
}
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
%---------------------------------------------------------------------------%
\endinput

