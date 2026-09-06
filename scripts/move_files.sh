#!/bin/bash

###############################################################################
# CoreDataEngineers - CSV and JSON File Management Script
#
# Purpose:
#   Move all CSV and JSON files from a source directory into the
#   json_and_CSV directory.
#
# The script supports:
#   - One CSV file
#   - Multiple CSV files
#   - One JSON file
#   - Multiple JSON files
#   - A mixture of CSV and JSON files
###############################################################################

set -e

###############################################################################
# CONFIGURATION
###############################################################################

# Project directory.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source directory.
SOURCE_DIR="$PROJECT_DIR/sample_files"

# Destination directory.
DEST_DIR="$PROJECT_DIR/json_and_CSV"

###############################################################################
# CREATE DESTINATION DIRECTORY
###############################################################################

echo "============================================================"
echo "       CSV AND JSON FILE MOVEMENT SCRIPT"
echo "============================================================"

echo ""
echo "Creating destination directory if it does not exist..."

mkdir -p "$DEST_DIR"

###############################################################################
# CHECK SOURCE DIRECTORY
###############################################################################

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory does not exist:"
    echo "$SOURCE_DIR"
    exit 1
fi

###############################################################################
# MOVE CSV AND JSON FILES
###############################################################################

echo ""
echo "Searching for CSV and JSON files..."

files_found=0

# Find all CSV and JSON files in the source directory.
# -maxdepth 1 ensures that only files directly inside the source directory
# are processed.
while IFS= read -r -d '' file; do

    echo "Moving: $(basename "$file")"

    mv "$file" "$DEST_DIR/"

    files_found=1

done < <(
    find "$SOURCE_DIR" -maxdepth 1 -type f \
        \( -iname "*.csv" -o -iname "*.json" \) \
        -print0
)

###############################################################################
# RESULT
###############################################################################

if [[ "$files_found" -eq 1 ]]; then

    echo ""
    echo "SUCCESS: CSV and JSON files have been moved to:"
    echo "$DEST_DIR"

else

    echo ""
    echo "No CSV or JSON files were found in:"
    echo "$SOURCE_DIR"

fi

echo ""
echo "============================================================"
echo "              FILE MOVEMENT COMPLETED"
echo "============================================================"
