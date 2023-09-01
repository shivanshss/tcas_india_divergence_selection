# tcas_india_divergence_selection
This repository contains scripts, test data, and sample output files for analysis done for chapter 2 of my PhD thesis

In this project, I use Illumina short-read sequences from many samples across many populations. Here we align paired-end short reads to a reference, call variants (SNPs) and annotate those variants on the basis of a genomic feature file (gff).
We then use these SNPs to understand divergence and selection in the genomes. 

[Step 1](https://github.com/shivanshss/tcas_india_divergence_selection/blob/main/step1/step1.README)


Population Genomic Analysis Pipeline Step 1


## The script performs the following tasks:

    Input Validation and Setup:
        It checks for the correct number of command-line arguments.
        It verifies the existence of the provided configuration file.
        It sources the configuration file to load required settings.

    Output Directory Creation:
        It creates an output directory named "output" to store analysis results.

    Sample Processing Loop:

        For each sample specified in the configuration file, the script performs the following steps:

        a. Read Trimming using Trimmomatic:
            Trims low-quality reads and adapter sequences using Trimmomatic.
            Generates log files for trimming.

        b. FastQC Analysis:
            Runs FastQC on trimmed reads to assess read quality.
            Stores the FastQC results in a "fastqc_trimmed" subdirectory.

        c. Read Alignment with BWA:
            Aligns trimmed reads to a reference genome using BWA.
            Generates a SAM file.

        d. Convert SAM to BAM:
            Converts the SAM file to the more efficient BAM format.

        e. BAM Sorting:
            Sorts the BAM file for efficient processing.

        f. BAM Indexing:
            Creates an index for the sorted BAM file.

        g. PCR Duplicate Removal:
            Removes PCR duplicates from the sorted BAM file using PicardTools.

        h. Variant Calling with GATK HaplotypeCaller:
            Calls variants (SNPs) using GATK HaplotypeCaller.
            Outputs raw variant calls in VCF format.

        i. GenotypeGVCFs:
            Converts genotyped VCFs into merged VCF format using GenotypeGVCFs.

        j. Variant Filtering with GATK:
            Filters variants based on various quality criteria using GATK VariantFiltration.

        k. Variant Annotation with ANNOVAR:
            Annotates variants using ANNOVAR, providing additional information about the variants.

    Clean-Up:
        Removes intermediate files (SAM, unsorted BAM) to conserve disk space.

    Completion Message:
        Displays "Analysis complete!" when all samples have been processed.

## Usage

To use the script, follow these steps:

    Prerequisites:
        Ensure you have all the required tools and dependencies installed, including Trimmomatic, FastQC, BWA, Samtools, PicardTools, GATK, and ANNOVAR.
        Place the reference genome and adapter sequences in the appropriate locations as specified in your configuration file.

    Configuration File:
        Create a configuration file (e.g., config.txt) containing the necessary settings for your analysis. Refer to the script's source code for the expected format of this file.

    Run the Script:
        Execute the script by providing the path to your configuration file as the only command-line argument.
        Example: ./analysis_script.sh config.txt

    Monitor Progress:
        The script will process each sample as defined in the configuration file.
        You can monitor the progress and check for any potential issues by examining the output and log files in the "output" directory.

    Results:
        Once the script completes the analysis for all samples, you can find the final annotated variant files in the respective sample directories within the "output" directory.

