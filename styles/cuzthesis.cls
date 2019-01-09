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
\newif\ifcuz@singlesided \cuz@singlesidedfalse
\DeclareOption{singlesided}{% enable single-sided printing
    \cuz@singlesidedtrue%
}
\newif\ifcuz@doublesided \cuz@doublesidedfalse
\DeclareOption{doublesided}{% enable double-sided printing
    \cuz@doublesidedtrue%
}
\newif\ifcuz@hdr \cuz@hdrfalse
\DeclareOption{cuzhdr}{% enable cuz-styled header and footer
    \cuz@hdrtrue%
}
\newif\ifcuz@printcopy \cuz@printcopyfalse
\DeclareOption{printcopy}{% enable print copy layout
    \cuz@doublesidedtrue% auto enable double-sided style
    \cuz@printcopytrue%
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
\ifcuz@doublesided% if double-sided printing enabled
    \LoadClass[UTF8,a4paper,twoside,zihao=-4]{ctexbook}
\else% if double-sided printing isn't enabled
    \LoadClass[UTF8,a4paper,oneside,zihao=-4]{ctexbook}
\fi
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
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
% \setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
% %- line spacing
% \linespread{1.5}% line space setting
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
        \fancyhead[CE]{\footnotesize \@title}% structure elements
        \fancyhead[CO]{\footnotesize \leftmark}% structure elements
        \fancyfoot[CE]{\footnotesize \thepage}% page number
        \fancyfoot[CO]{\footnotesize \thepage}% page number
        \renewcommand{\headrulewidth}{0.8pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    \fancypagestyle{mainmatterstyle}{% style for mainmatter
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        \fancyfoot[LEO]{\footnotesize \cuz@footer@author{\cuz@value@author}}% page number
        \fancyfoot[REO]{\footnotesize \cuz@footer@pagenumber{\thepage\ }{\pageref{LastPage}\ }}% page number
        \renewcommand{\headrulewidth}{0.5pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    \fancypagestyle{backmatterstyle}{% header and footer style for backmatter
        \fancyhf{}% clear fields
        \fancyhead[CE]{\footnotesize \@title}% structure elements
        \fancyhead[CO]{\footnotesize \leftmark}% structure elements
        \fancyfoot[LE]{\footnotesize \thepage}% page number
        \fancyfoot[RO]{\footnotesize \thepage}% page number
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
    %- Redefine \mainmatter to include the change
    \providecommand{\mainmatter}{}% compatibility for non-book classes
    \let\cuzmainmatter\mainmatter%
    \renewcommand{\mainmatter}{%
        \cuzmainmatter%
        \pagestyle{mainmatterstyle}%
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
    \fancypagestyle{noheaderstyle}{% header and footer style for no header
        \fancyhf{}% clear fields
        %\fancyhead[CE]{\footnotesize \@title}% structure elements
        %\fancyhead[CO]{\footnotesize \leftmark}% structure elements
        \fancyfoot[LE]{\footnotesize \thepage}% page number
        \fancyfoot[RO]{\footnotesize \thepage}% page number
        \renewcommand{\headrulewidth}{0pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
    }
    \fancypagestyle{nofooterstyle}{% header and footer style for no footer
        \fancyhf{}% clear fields
        \fancyhead[LEO]{\footnotesize \cuz@label@header@bacthesis}% structure elements
        \fancyhead[REO]{\footnotesize \@title}% structure elements
        % \fancyfoot[LEO]{\footnotesize \thepage}% page number
        % \fancyfoot[REO]{\footnotesize \thepage}% page number
        \renewcommand{\headrulewidth}{0.5pt}% header rule
        \renewcommand{\footrulewidth}{0pt}% footer rule
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
    \renewcommand{\CJKunderlinecolor}{\color[rgb]{0,0,0}}% set underline color
    \renewcommand{\uline}[1]{\CJKunderline{#1}}% unified name
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
\def\cuz@value@confidential{}
\newcommand{\confidential}[1]{\def\cuz@value@confidential{#1}}
\def\cuz@value@schoollogo{}
\newcommand{\schoollogo}[2]{\def\cuz@value@schoollogo{\includegraphics[#1]{#2}}}
\def\cuz@value@title{}
\def\cuz@value@titlemark{}
\renewcommand{\title}[2][\cuz@value@title]{%
    \def\cuz@value@title{#2}
    %\def\cuz@value@titlemark{\MakeUppercase{#1}}}
    \def\cuz@value@titlemark{#1}}
\renewcommand{\@title}{\cuz@value@titlemark}
\def\cuz@value@author{}
\renewcommand{\author}[1]{\def\cuz@value@author{#1}}
\def\cuz@value@advisor{}
\newcommand{\advisor}[1]{\def\cuz@value@advisor{#1}}
\def\cuz@value@advisorsec{}
\newcommand{\advisorsec}[1]{\def\cuz@value@advisorsec{#1}}
\def\cuz@value@degree{}
\newcommand{\degree}[1]{\def\cuz@value@degree{#1}}
\def\cuz@value@degreetype{}
\newcommand{\degreetype}[1]{\def\cuz@value@degreetype{#1}}
\def\cuz@value@major{}
\newcommand{\major}[1]{\def\cuz@value@major{#1}}
\def\cuz@value@institute{}
\newcommand{\institute}[1]{\def\cuz@value@institute{#1}}
\def\cuz@value@chinesedate{}
\newcommand{\chinesedate}[1]{\def\cuz@value@chinesedate{#1}}
%-
%-> Redefine Chinese style
%-
\renewcommand{\maketitle}{%
    \cuzifstreq{\cuz@value@englishdegree}{Bachelor}{%
        \def\cuz@label@thesis{\cuz@label@bacthesis}%
        \def\cuz@label@major{\cuz@label@ungradmajor}%
        \def\cuz@label@institute{\cuz@label@ungradinstitute}%
    }{%
    \cuzifstreq{\cuz@value@englishdegree}{Master}{%
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
    \begin{center}
        \linespread{1.5}
        \zihao{4}\bfseries

        \hfill{} \cuzifstrbk{\cuz@value@confidential}{}{\cuz@label@confidential \ulenhance{\ulextend[50pt]{\hspace*{-\ulhshift}\zihao{5}\cuz@value@confidential}}}

        \vspace*{\stretch{4}}

        {\cuz@value@schoollogo}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\cuz@label@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\ \cuz@value@title\ }}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \cuz@label@author & \ulenhance[1.2pt]{\ulextend{\cuz@value@author}}\\
            \cuz@label@advisor & \ulenhance[1.2pt]{\ulextend{\cuz@value@advisor}}\\
            & \ulenhance[1.2pt]{\ulextend{\cuz@value@advisorsec}}\\
            \cuz@label@degree & \ulenhance[1.2pt]{\ulextend{\cuz@value@degreetype\cuz@value@degree}}\\
            \cuz@label@major & \ulenhance[1.2pt]{\ulextend{\cuz@value@major}}\\
            \cuz@label@institute & \ulenhance[1.2pt]{\ulextend{\cuz@value@institute}}\\
        \end{tabular}

        \vspace*{\stretch{4.5}}

        {\cuz@value@chinesedate}

        \vspace*{\stretch{3.5}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifcuz@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifcuz@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
}
%-
%-> English item commands
%-
\def\cuz@value@englishtitle{}
\newcommand{\englishtitle}[1]{\def\cuz@value@englishtitle{#1}}
\def\cuz@value@englishauthor{}
\newcommand{\englishauthor}[1]{\def\cuz@value@englishauthor{#1}}
\def\cuz@value@englishadvisor{}
\newcommand{\englishadvisor}[1]{\def\cuz@value@englishadvisor{#1}}
\def\cuz@value@englishdegree{}
\newcommand{\englishdegree}[1]{\edef\cuz@value@englishdegree{\zap@space#1 \@empty}}% expand and remove space
\def\cuz@value@englishdegreetype{}
\newcommand{\englishdegreetype}[1]{\def\cuz@value@englishdegreetype{#1}}
\def\cuz@value@englishthesistype{}
\newcommand{\englishthesistype}[1]{\def\cuz@value@englishthesistype{#1}}
\def\cuz@value@englishmajor{}
\newcommand{\englishmajor}[1]{\def\cuz@value@englishmajor{#1}}
\def\cuz@value@englishinstitute{}
\newcommand{\englishinstitute}[1]{\def\cuz@value@englishinstitute{#1}}
\def\cuz@value@englishdate{}
\newcommand{\englishdate}[1]{\def\cuz@value@englishdate{#1}}
%-
%-> Redefine English style
%-
\newcommand{\makeenglishtitle}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.5}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{-3}\bfseries \ulenhance[1.5pt]{\ \cuz@value@englishtitle\ }}

        \vspace*{\stretch{2}}

        {\cuz@label@englishstatement}

        {By}

        {\cuz@value@englishauthor}

        {\cuz@value@englishadvisor}

        \vspace*{\stretch{3}}

        {\cuz@value@englishinstitute}

        \vspace*{\stretch{1}}

        {\cuz@value@englishdate}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.5}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \cuz@value@declare@create}
        \end{center}

        {\cuz@value@declare@creativity}

        \vspace*{3ex}

        {\hfill{} {\cuz@value@declare@s \hspace*{14em}}}

        {\hfill{} {\cuz@value@declare@d \hspace*{14em}}}

        \vspace*{6ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \cuz@value@declare@right}
        \end{center}

        {\cuz@value@declare@rights}

        {\cuz@value@declare@rule}

        \vspace*{3ex}

        {\hfill{} {\cuz@value@declare@s \hspace*{10em} \cuz@value@declare@t \hspace*{9em}}}

        {\hfill{} {\cuz@value@declare@d \hspace*{10em} \cuz@value@declare@d \hspace*{9em}}}

        \vspace*{3ex}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \cuz@label@keywords} #1}
%- define engish keywords
\newcommand{\englishkeywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \cuz@label@englishkeywords} #1}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- define spacing and length
\def\@dotsep{1.5mu}% spacing for dots
\def\@pnumwidth{2em}% spacing between titles and page numbers
\def\@tocrmarg{2em}% right margin indentation
\def\@chaptervspace{1ex}% spacing between chapter titles
%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
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
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
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
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%---------------------------------------------------------------------------%
\endinput

