@echo off
setlocal enabledelayedexpansion

@rem ------------------------------------------------
@rem            LaTeX Automated Compiler
@rem                <By Huangrui Mo>
@rem              <Modified by Hao XIE>
@rem Copyright (C) Hao XIE <oaheix@gmail.com>
@rem This is free software: you can redistribute it
@rem and/or modify it under the terms of the GNU General
@rem Public License as published by the Free Software
@rem Foundation, either version 3 of the License, or
@rem (at your option) any later version.
@rem ------------------------------------------------

@rem ------------------------------------------------
@rem ->> Check for required programs
@rem ------------------------------------------------
where latex >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: LaTeX is not installed or not in PATH
    exit /b 1
)

where bibtex >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: BibTeX is not installed or not in PATH
    exit /b 1
)

where xelatex >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: XeLaTeX is not installed or not in PATH
    exit /b 1
)

@rem ------------------------------------------------
@rem ->> Set tex compiler
@rem ------------------------------------------------
set CompilerOrder="2"
@rem ------------------------------------------------
if %CompilerOrder% == "1" (
    set CompileName="pdflatex"
) else (
    set CompileName="xelatex"
)

@rem ------------------------------------------------
@rem ->> Get source filename
@rem ------------------------------------------------
set FileFound=0
for %%F in (*.tex) do (
    if !FileFound! == 1 (
        echo Error: Multiple .tex files found. Please specify the target file.
        exit /b 1
    )
    set FileName=%%~nF
    set FileFound=1
)

if !FileFound! == 0 (
    echo Error: No .tex files found in current directory.
    exit /b 1
)

@rem ------------------------------------------------
@rem ->> Create and check cache directory
@rem ------------------------------------------------
if not exist "cache" (
    mkdir "cache" 2>nul
    if errorlevel 1 (
        echo Error: Failed to create cache directory
        exit /b 1
    )
)

if not exist "cache\contents" (
    mkdir "cache\contents" 2>nul
    if errorlevel 1 (
        echo Error: Failed to create cache\contents directory
        exit /b 1
    )
)

@rem ------------------------------------------------
@rem ->> Set environmental variables
@rem ------------------------------------------------
set TEXINPUTS=./;./src/;./src/common/;./src/thesis/frontmatter/;./src/thesis/mainmatter/;./src/thesis/backmatter/;%TEXINPUTS%
set BIBINPUTS=./bibliography/;%BIBINPUTS%
set BSTINPUTS=./bibliography/;%BSTINPUTS%

@rem ------------------------------------------------
@rem ->> Build textual content
@rem ------------------------------------------------
%CompileName% -output-directory=cache %FileName%
if errorlevel 1 (
    echo Error: Failed during first %CompileName% run
    exit /b 1
)

@rem ------------------------------------------------
@rem ->> Build references and links
@rem ------------------------------------------------
bibtex ./cache/%FileName%
if errorlevel 1 (
    echo Error: Failed during bibtex run
    exit /b 1
)

%CompileName% -output-directory=cache %FileName%
if errorlevel 1 (
    echo Error: Failed during second %CompileName% run
    exit /b 1
)

%CompileName% -output-directory=cache %FileName%
if errorlevel 1 (
    echo Error: Failed during third %CompileName% run
    exit /b 1
)

@rem ------------------------------------------------
@rem ->> Check if PDF was generated
@rem ------------------------------------------------
if not exist "cache\%FileName%.pdf" (
    echo Error: PDF file was not generated
    exit /b 1
)

@rem ------------------------------------------------
@rem ->> View compiled file
@rem ------------------------------------------------
start "" /max "cache\%FileName%.pdf"
if errorlevel 1 (
    echo Error: Failed to open PDF file
    exit /b 1
)

echo ------------------------------------------------
echo %CompileName% compilation finished successfully
echo ------------------------------------------------
