#!/bin/bash

echo "This is a script to automatically generate project structure for chapter 2 of my thesis [Divergence and selection in DNA seq samples from natural populations"


#!/bin/bash

# Constants
README_CONTENT="### Few pointers for Project Organization\n- Use GitHub for collaborating, sharing, and version control of your scripts!\n- Add your raw data, backup data, and any large files >50 Mb to .gitignore file.\n- Use a pipeline management tool such as snakemake or nextflow\n- Process and analyze results in a Jupyter notebook or an Rmarkdown document"

# Function to create directory with validation
create_directory() {
    if [ ! -d "$1" ]; then
        mkdir "$1"
        echo "Created directory: $1"
    else
        echo "Directory '$1' already exists. Skipping..."
    fi
}

# User input for project name
read -p "Enter the name of your project (avoid spaces, use underscores): " project_name

# Create project directory
create_directory "$project_name"

# Create subdirectories
create_directory "$project_name/data"
create_directory "$project_name/data/raw_reads"
create_directory "$project_name/data/aligned_reads"
create_directory "$project_name/data/snp_calls"
create_directory "$project_name/data/population_genetics"

create_directory "$project_name/docs"
create_directory "$project_name/docs/protocols"
create_directory "$project_name/docs/analysis_notes"

create_directory "$project_name/scripts"
create_directory "$project_name/scripts/alignment_scripts"
create_directory "$project_name/scripts/snp_calling_scripts"
create_directory "$project_name/scripts/population_genetics_scripts"

create_directory "$project_name/results"
create_directory "$project_name/results/snp_stats"
create_directory "$project_name/results/population_genetics_results"

create_directory "$project_name/tmp"
create_directory "$project_name/tmp/alignment_tmp"
create_directory "$project_name/tmp/snp_calling_tmp"

# Create readme files
echo "$README_CONTENT" > "$project_name/README.md"
echo "This directory is for raw reads from each sample." > "$project_name/data/raw_reads/readme.md"
echo "This directory is for aligned reads from each sample." > "$project_name/data/aligned_reads/readme.md"
echo "This directory is for SNP calls from each sample." > "$project_name/data/snp_calls/readme.md"
echo "This directory is for input/output files related to population genetics calculations." > "$project_name/data/population_genetics/readme.md"

echo "This directory contains protocols for various steps." > "$project_name/docs/protocols/readme.md"
echo "This directory contains analysis notes for each sample." > "$project_name/docs/analysis_notes/readme.md"

echo "This directory contains scripts for aligning reads." > "$project_name/scripts/alignment_scripts/readme.md"
echo "This directory contains scripts for SNP calling." > "$project_name/scripts/snp_calling_scripts/readme.md"
echo "This directory contains scripts for population genetics calculations." > "$project_name/scripts/population_genetics_scripts/readme.md"

echo "This directory contains SNP statistics for each sample." > "$project_name/results/snp_stats/readme.md"
echo "This directory contains results from population genetics calculations." > "$project_name/results/population_genetics_results/readme.md"

# Success message
echo "Project Initialization completed successfully!"
tree "$project_name"
