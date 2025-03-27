% 创建一个基础类文件，包含所有共享的选项和功能
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{cuzbase}[2024/10/18 v2.0 CUZ Base LaTeX document class]%

%---------------------------------------------------------------------------%
%->> 声明共享选项
%---------------------------------------------------------------------------%
%-
%-> 布局选项
%-
\DeclareOption{singlesided}{% 启用单面打印
    \PassOptionsToClass{oneside}{ctexbook}%
}
\newif\ifcuz@doublesided \cuz@doublesidedfalse
\DeclareOption{doublesided}{% 启用双面打印
    \PassOptionsToClass{twoside}{ctexbook}%
    \cuz@doublesidedtrue%
}
\newif\ifcuz@hdr \cuz@hdrfalse
\DeclareOption{cuzhdr}{% 启用自定义页眉页脚样式
    \cuz@hdrtrue%
}
\newif\ifcuz@printcopy \cuz@printcopyfalse
\DeclareOption{printcopy}{% 启用打印布局
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
%-> 草稿版本信息
%-
\newif\ifcuz@versioninfo \cuz@versioninfofalse
\DeclareOption{draftversion}{%
    \cuz@versioninfotrue%
}
%-
%-> 处理未实现的选项
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> 终止所有选项处理
%-
\ProcessOptions\relax%

%---------------------------------------------------------------------------%
%->> 加载基础类信息
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}

%---------------------------------------------------------------------------%
%->> 加载共享的必要包
%---------------------------------------------------------------------------%
\RequirePackage{iftex}% LaTeX引擎检测（替代ifxetex）
\RequirePackage{etoolbox}% 编程工具箱
\RequirePackage{textcase}% 大小写字母处理
\RequirePackage{hologo}% 一些有用的标志
\RequirePackage{framed}% 带框段落
\RequirePackage{lineno}% 行号
\RequirePackage{setspace}% 行间距
\RequirePackage{multirow}% 表格多行
% \RequirePackage{geometry}% 页面布局

% 定义通用的命令扩展控制
\newcommand{\cuzifstreq}{\expandafter\ifstrequal\expandafter}% 扩展控制
\newcommand{\cuzifstrbk}{\expandafter\ifblank\expandafter}% 扩展控制

%---------------------------------------------------------------------------%
%->> 加载类配置
%---------------------------------------------------------------------------%
\AtEndOfPackage{% 在包加载后加载配置文件，使前导命令生效
    \makeatletter
    \InputIfFileExists{styles/cuzthesis.cfg}{}{}
    \makeatother
}

%---------------------------------------------------------------------------%
%->> 页面布局
%---------------------------------------------------------------------------%
% 设置页边距和纸张大小
\RequirePackage[a4paper, margin=2.5cm]{geometry}

% 段落间距
\setlength{\parskip}{0.0\baselineskip}
% 行间距
\linespread{1.25}% 行间距设置

%---------------------------------------------------------------------------%
%->> 页眉页脚
%---------------------------------------------------------------------------%
\ifcuz@hdr% 用户自定义页眉页脚样式
    \RequirePackage{fancyhdr}
    \RequirePackage{lastpage}
    \pagestyle{fancy}%
    \providecommand{\chaptermark}{}% 兼容非书籍类
    \providecommand{\thechapter}{}% 兼容非书籍类
    \providecommand{\CTEXthechapter}{\thechapter.}% 兼容非ctex类
    %- 重置章节标记样式为实际名称
    \renewcommand{\chaptermark}[1]{\markboth{\MakeUppercase{#1}}{}}%
    %- 禁用大写效果
    \renewcommand{\MakeUppercase}[1]{#1}%
    \fancypagestyle{nostyle}{% 无页脚的页眉页脚样式
        \fancyhf{}% 清除字段
        \renewcommand{\headrulewidth}{0pt}% 页眉线
        \renewcommand{\footrulewidth}{0pt}% 页脚线
    }
    %- 重定义\nomatter以包含更改
    \providecommand{\nomatter}{}% 兼容非书籍类
    \let\cuznomatter\nomatter%
    \renewcommand{\nomatter}{%
        \cuznomatter%
        \pagestyle{nostyle}%
    }
\fi

%---------------------------------------------------------------------------%
%->> 样式控制命令
%---------------------------------------------------------------------------%
%- 重定义cleardoublepage以具有页面样式参数
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
            \thispagestyle{#1}%
            \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}

%- 下划线
\ifxetex% 使用xeCJKfntef的下划线
    % 可以根据需要取消注释以下行
    % \renewcommand{\CJKunderlinecolor}{\color[rgb]{0,0,0}}% 设置下划线颜色
    % \renewcommand{\uline}[1]{\CJKunderline{#1}}% 统一名称
\else% 使用ulem的下划线
    \RequirePackage{ulem}%
\fi

\newcommand{\ulenhance}[2][1pt]{% 增强的下划线
    \def\ULthickness{#1}% 设置厚度
    \uline{#2}}
\newcommand{\ulhshift}{-4em}% 下划线上的水平偏移
\newcommand{\ulextend}[2][350pt]{% 扩展下划线长度
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}

%---------------------------------------------------------------------------%
%->> 标题页基础命令
%---------------------------------------------------------------------------%
\newcommand{\confidential}[1]{\gdef\cuz@value@confidential{#1}}
\newcommand{\schoollogo}[2]{
    \gdef\cuz@value@schoollogo{
        \ifcuz@blinded
            \vspace*{4.5em}
        \else
            \includegraphics[#1]{#2}
        \fi
    }
}

% 导出类，使其可以被其他类使用
\endinput