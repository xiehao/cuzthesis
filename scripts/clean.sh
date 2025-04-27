#!/bin/bash
set -e

#---------------------------------------------------------------------------#
#-                       LaTeX Cleanup Script                              -#
#-                          <By Hao XIE>                                   -#
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

# Define cache directory
Cache="cache"

#---------------------------------------------------------------------------#
#->> Cleanup options
#---------------------------------------------------------------------------#
# Default is to clean only intermediate files
clean_all=false
clean_pdf=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--all)
            clean_all=true
            shift
            ;;
        -p|--pdf)
            clean_pdf=true
            shift
            ;;
        -h|--help)
            echo "---------------------------------------------------------------------------"
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -a, --all    Remove all generated files including PDFs"
            echo "  -p, --pdf    Remove PDF files only"
            echo "  -h, --help   Show this help message"
            echo "---------------------------------------------------------------------------"
            exit 0
            ;;
        *)
            error_exit "Unknown option: $1"
            ;;
    esac
done

#---------------------------------------------------------------------------#
#->> Cleaning process
#---------------------------------------------------------------------------#
echo "---------------------------------------------------------------------------"
echo "Starting cleanup process..."

# Check if cache directory exists
if [[ -d "$Cache" ]]; then
    # Remove intermediate files
    echo "Removing LaTeX intermediate files..."
    find "$Cache" -type f -name "*.aux" -delete
    find "$Cache" -type f -name "*.bak" -delete
    find "$Cache" -type f -name "*.bbl" -delete
    find "$Cache" -type f -name "*.bcf" -delete
    find "$Cache" -type f -name "*.blg" -delete
    find "$Cache" -type f -name "*.idx" -delete
    find "$Cache" -type f -name "*.ilg" -delete
    find "$Cache" -type f -name "*.ind" -delete
    find "$Cache" -type f -name "*.lof" -delete
    find "$Cache" -type f -name "*.log" -delete
    find "$Cache" -type f -name "*.lot" -delete
    find "$Cache" -type f -name "*.out" -delete
    find "$Cache" -type f -name "*.toc" -delete
    find "$Cache" -type f -name "*.run.xml" -delete
    find "$Cache" -type f -name "*.synctex.gz" -delete
    find "$Cache" -type f -name "*.fls" -delete
    find "$Cache" -type f -name "*.fdb_latexmk" -delete
    find "$Cache" -type f -name "*.xdv" -delete

    # Remove minted cache files
    echo "Removing minted cache files from cache directory..."
    find "$Cache" -type d -name "_minted-*" -exec rm -rf {} \; 2>/dev/null || true

    # Remove PDF files if requested
    if [[ "$clean_pdf" == true ]]; then
        echo "Removing PDF files..."
        find "$Cache" -type f -name "*.pdf" -delete
    fi

    # Remove entire cache directory if clean_all is true
    if [[ "$clean_all" == true ]]; then
        echo "Removing all generated files including PDFs..."
        rm -rf "$Cache"
    fi

    echo "Cleanup completed successfully."
else
    echo "Cache directory not found. Nothing to clean."
fi

# Clean minted cache files from all directories
echo "Removing minted cache files from all directories..."
find . -type d -name "_minted*" -exec rm -rf {} \; 2>/dev/null || true

# Also remove pygments cache files
find . -name "*.pygtex" -delete 2>/dev/null || true
find . -name "*.pygstyle" -delete 2>/dev/null || true

# Remove other common LaTeX temporary files in the root directory
echo "Removing temporary files from root directory..."
rm -f *.aux *.bak *.bbl *.bcf *.blg *.idx *.ilg *.ind *.lof *.log *.lot *.out *.toc *.run.xml *.synctex.gz *.fls *.fdb_latexmk *.xdv

# Clean up any remaining minted-related files
echo "Final check for minted-related files..."
find . -name "*.pyg" -delete 2>/dev/null || true
find . -name "_minted*" -delete 2>/dev/null || true

echo "---------------------------------------------------------------------------"
