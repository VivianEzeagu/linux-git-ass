#!/bin/bash

###############################################################################
# CoreDataEngineers - Simple Bash ETL Pipeline
#
# Purpose:
#   1. Extract the Annual Enterprise Survey CSV file.
#   2. Transform the data:
#      - Rename Variable_code to variable_code
#      - Select year, Value, Units and variable_code
#   3. Load the transformed file into the Gold directory.
#
# Author: Data Engineer
###############################################################################

# Exit immediately if a command fails.
set -e
###############################################################################
# 1. ENVIRONMENT VARIABLES
###############################################################################

# URL of the source CSV file.
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Project directory.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Define directories.
RAW_DIR="$PROJECT_DIR/raw"
TRANSFORMED_DIR="$PROJECT_DIR/Transformed"
GOLD_DIR="$PROJECT_DIR/Gold"

# Define filenames.
RAW_FILE="$RAW_DIR/annual-enterprise-survey-2023-financial-year-provisional.csv"
TRANSFORMED_FILE="$TRANSFORMED_DIR/2023_year_finance.csv"
GOLD_FILE="$GOLD_DIR/2023_year_finance.csv"

###############################################################################
# 2. CREATE REQUIRED DIRECTORIES
###############################################################################

echo "============================================================"
echo "       COREDATAENGINEERS BASH ETL PIPELINE"
echo "============================================================"

echo ""
echo "[STEP 1] Checking required directories..."

mkdir -p "$RAW_DIR"
mkdir -p "$TRANSFORMED_DIR"
mkdir -p "$GOLD_DIR"

echo "Required directories are ready."

echo ""
echo "[STEP 2] EXTRACT"
echo "Downloading CSV file..."

# Download the source CSV file.
# -f = fail silently on HTTP errors
# -L = follow redirects
# -s = silent mode
# -S = show errors
curl -fLsS "$CSV_URL" -o "$RAW_FILE"

# Confirm that the file exists and is not empty.
if [[ -s "$RAW_FILE" ]]; then
    echo "SUCCESS: CSV file has been saved in:"
    echo "        $RAW_FILE"
else
    echo "ERROR: CSV file was not downloaded successfully."
    exit 1
fi

###############################################################################
# 4. TRANSFORM
###############################################################################

echo ""
echo "[STEP 3] TRANSFORM"
echo "Renaming Variable_code and selecting required columns..."

# Use awk to:
#   1. Read the header.
#   2. Find the positions of year, Value, Units and Variable_code.
#   3. Rename Variable_code to variable_code.
#   4. Output only the four required columns.
#
# The resulting file is written to the Transformed directory.

awk -F',' '
BEGIN {
    OFS=","
}

NR == 1 {

    # Locate the required columns from the header.
    for (i = 1; i <= NF; i++) {

        if ($i == "Year")
            year_col = i

        else if ($i == "Value")
            value_col = i

        else if ($i == "Units")
            units_col = i

        else if ($i == "Variable_code")
            variable_code_col = i
    }

    # Make sure all required columns were found.
    if (!year_col || !value_col || !units_col || !variable_code_col) {
        print "ERROR: One or more required columns were not found." > "/dev/stderr"
        exit 1
    }

    # Write the transformed header.
    print "year", "Value", "Units", "variable_code"

    next
}

{
    # Write only the four required columns.
    print $year_col, $value_col, $units_col, $variable_code_col
}
' "$RAW_FILE" > "$TRANSFORMED_FILE"

# Confirm the transformed file exists and is not empty.
if [[ -s "$TRANSFORMED_FILE" ]]; then
    echo "SUCCESS: Transformed file has been created:"
    echo "        $TRANSFORMED_FILE"
else
    echo "ERROR: Transformation failed."
    exit 1
fi

###############################################################################
# 5. LOAD
###############################################################################

echo ""
echo "[STEP 4] LOAD"
echo "Loading transformed data into Gold..."

# Copy the transformed dataset into the Gold directory.
cp "$TRANSFORMED_FILE" "$GOLD_FILE"

# Confirm that the file exists in Gold.
if [[ -s "$GOLD_FILE" ]]; then
    echo "SUCCESS: File has been loaded into Gold:"
    echo "        $GOLD_FILE"
else
    echo "ERROR: File could not be loaded into Gold."
    exit 1
fi

###############################################################################
# 6. PIPELINE SUMMARY
###############################################################################

echo ""
echo "============================================================"
echo "              ETL PIPELINE COMPLETED"
echo "============================================================"

echo "Extracted file:"
echo "  $RAW_FILE"

echo ""
echo "Transformed file:"
echo "  $TRANSFORMED_FILE"

echo ""
echo "Gold file:"
echo "  $GOLD_FILE"

echo ""
echo "ETL process completed successfully."
echo "============================================================"


