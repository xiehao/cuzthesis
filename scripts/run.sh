#!/bin/bash
set -e

#---------------------------------------------------------------------------#
#-                       LaTeX Automated Compiler                          -#
#-                          <By Huangrui Mo>                               -#
#-                        <Modified by Hao XIE>                            -#
#- Copyright (C) Hao XIE <oaheix@gmail.com>                                -#
#- This is free software: you can redistribute it and/or modify it         -#
#- under the terms of the GNU General Public License as published by       -#
#- the Free Software Foundation, either version 3 of the License, or       -#
#- (at your option) any later version.                                     -#
#---------------------------------------------------------------------------#

# Error handling function
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check for required commands
command -v latex >/dev/null 2>&1 || error_exit "LaTeX is not installed. Please install TeX Live or MacTeX."
command -v bibtex >/dev/null 2>&1 || error_exit "BibTeX is not installed."
command -v xelatex >/dev/null 2>&1 || error_exit "XeLaTeX is not installed."

#---------------------------------------------------------------------------#
#->> Preprocessing
#---------------------------------------------------------------------------#
#-
#-> Get source filename
#-
if [[ "$#" == "1" ]]; then
    FileName=$(echo *.tex) || error_exit "No .tex files found in current directory."
    # Check if multiple .tex files exist
    if [[ "$FileName" == *" "* ]]; then
        error_exit "Multiple .tex files found. Please specify the target file."
    fi
elif [[ "$#" == "2" ]]; then
    FileName="$2"
    # Check if specified file exists
    if [[ ! -f "$FileName" ]]; then
        error_exit "File '$FileName' not found."
    fi
else
    echo "---------------------------------------------------------------------------"
    echo "Usage: $0  <l|p|x>< |a|b>  <filename>"
    echo "TeX engine parameters: <l:lualatex>, <p:pdflatex>, <x:xelatex>"
    echo "Bib engine parameters: < :none>, <a:bibtex>, <b:biber>"
    echo "---------------------------------------------------------------------------"
    exit 1
fi

FileName=${FileName/.tex}

#-
#-> Get tex compiler
#-
if [[ $1 == *'l'* ]]; then
    command -v lualatex >/dev/null 2>&1 || error_exit "LuaLaTeX is not installed."
    TexCompiler="lualatex"
else
    if [[ $1 == *'p'* ]]; then
        command -v pdflatex >/dev/null 2>&1 || error_exit "pdfLaTeX is not installed."
        TexCompiler="pdflatex"
    else
        TexCompiler="xelatex -shell-escape"
    fi
fi

#-
#-> Get bib compiler
#-
if [[ $1 == *'a'* ]]; then
    BibCompiler="bibtex"
elif [[ $1 == *'b'* ]]; then
    command -v biber >/dev/null 2>&1 || error_exit "Biber is not installed."
    BibCompiler="biber"
else
    BibCompiler=""
fi

#---------------------------------------------------------------------------#
#->> Set compilation out directory resembling the inclusion hierarchy
#---------------------------------------------------------------------------#
Cache="cache"
mkdir -p "$Cache/src/thesis/"{frontmatter,mainmatter,backmatter} || error_exit "Failed to create cache directory."
mkdir -p "$Cache/src/"{assignment,opening,review} || error_exit "Failed to create cache directory."

#-
#-> Set LaTeX environmental variables to add subdirs into search path
#-
export TEXINPUTS=".//:./src//:./src/thesis/frontmatter//:./src/thesis/mainmatter//:./src/thesis/backmatter//:$TEXINPUTS"
export BIBINPUTS="./bibliography//:$BIBINPUTS"
export BSTINPUTS="./bibliography//:$BSTINPUTS"
#---------------------------------------------------------------------------#
#->> Compiling
#---------------------------------------------------------------------------#
#-
#-> Build textual content and auxiliary files
#-
$TexCompiler -output-directory="$Cache" "$FileName" || error_exit "Failed during first $TexCompiler run."

#-
#-> Build references and links
#-
if [[ -n $BibCompiler ]]; then
    #- fix the inclusion path for hierarchical auxiliary files
    sed -i.bak -e "s|\@input{|\@input{$Cache/|g" "$Cache/$FileName.aux" || error_exit "Failed to process auxiliary files."
    #- extract and format bibliography database via auxiliary files
    $BibCompiler "$Cache/$FileName" || error_exit "Failed during $BibCompiler run."
    #- insert reference indicators into textual content
    $TexCompiler -output-directory="$Cache" "$FileName" || error_exit "Failed during second $TexCompiler run."
    #- refine citation references and links
    $TexCompiler -output-directory="$Cache" "$FileName" || error_exit "Failed during third $TexCompiler run."
fi
#---------------------------------------------------------------------------#
#->> Postprocessing
#---------------------------------------------------------------------------#
#-
#-> Set PDF viewer
#-
System_Name=$(uname)
if [[ $System_Name == "Linux" ]]; then
    PDFviewer="xdg-open"
elif [[ $System_Name == "Darwin" ]]; then
    PDFviewer="open"
else
    PDFviewer="open"
fi

#-
#-> Check if PDF was generated
#-
if [[ ! -f "$Cache/$FileName.pdf" ]]; then
    error_exit "PDF file was not generated."
fi

#-
#-> Open the compiled file
#-
$PDFviewer "$Cache/$FileName.pdf" || error_exit "Failed to open PDF file."

echo "---------------------------------------------------------------------------"
echo "$TexCompiler $BibCompiler '$FileName.tex' compilation finished successfully."
echo "---------------------------------------------------------------------------"

