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

