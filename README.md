**CDE Linux and Git project**

***Overview***

This project involves an ETL pipeline with cron job scheduling and a file moving system documented using a bash script,
all versioned on Github.

The project contains two Bash scripts:

etl.sh — performs a simple Extract, Transform and Load (ETL) pipeline.

move_files.sh — moves CSV and JSON files from one directory into another.


***Project Structure***

linux-git/

│
├── README.md

│
├── scripts/

│    ├── *etl.sh*

│    └── *move_files.sh*
│

├── raw/

├── Transformed/

├── Gold/

├── json_and_CSV/
│

├── sample_files/

│    ├── *file1.csv*

     ├── *file2.csv*
    
     ├── *file1.json*
    
│    └── *file2.json*
│

└── scheduled cron job

***1. ETL Pipeline***


***Extract***

The ETL script downloads the Annual Enterprise Survey 2023 financial-year provisional CSV dataset from Statistics New Zealand.

The source URL is stored in an environment variable:
CSV_URL

The downloaded file is saved into:
raw/

The script checks that the downloaded file exists and is not empty.
Transform

The transformation performs two operations:

***Rename column***

The column:
Variable_code

is renamed to:
variable_code

***Select columns***

Only the following columns are retained:
year
Value
Units
variable_code

The transformed dataset is saved as:
Transformed/2023_year_finance.csv

***Load***

The transformed file is copied into the Gold layer:
Gold/2023_year_finance.csv

The script confirms that the file has successfully been saved.

***2. Running the ETL Pipeline***

Give the script execute permission:
chmod +x scripts/etl.sh

Run the script:
./scripts/etl.sh

The script reports whether each stage completed successfully.

***3. Cron Scheduling***

The ETL pipeline is scheduled to run automatically every day at 12:00 AM.

The cron expression is:
0 0 * * *
The output and errors from the scheduled process are written to: [here]([url](https://github.com/VivianEzeagu/linux-git-ass/new/main?filename=README.md#:~:text=scheduled-,%2D,-cron%2Djob.png)
) 

***4. CSV and JSON File Movement***

The move_files.sh script searches a source directory for files ending in:

.csv

.json

It supports both single and multiple files.

Running:

./scripts/move_files.sh

moves all matching files into:

json_and_CSV/

The script does not require filenames to be hardcoded.

***5. Running the File Movement Script***

Give the script execute permission:

chmod +x scripts/move_files.sh

Run:

./scripts/move_files.sh

Verify the destination:

ls -la json_and_CSV/

***6. Technologies Used***

Linux
Bash
Cron
Git
GitHub
No Python, Pandas, or other programming languages are used in the ETL or file-management scripts.

***7. ETL Flow***

Statistics New Zealand

        │
        │ Extract
        ▼
        
      raw/
        │
        │ Transform
        │ Rename Variable_code
        │ Select required columns
        ▼
  
   Transformed/
   
        │
        │ Load
        ▼
        
      Gold/
      
***8. Expected Output***
    
After a successful ETL run, the following files should exist:

raw/

└── annual-enterprise-survey-2023-financial-year-provisional.csv

Transformed/

└── 2023_year_finance.csv

Gold/

└── 2023_year_finance.csv

The transformed and Gold files should contain:
year,Value,Units,variable_code

***Conclusion***

This project demonstrates the use of Bash scripting to automate a basic data pipeline, Linux cron to schedule recurring jobs, shell utilities to manage files, and Git/GitHub was used to version and document the work.
