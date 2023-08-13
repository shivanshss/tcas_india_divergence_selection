# tcas_india_divergence_selection
This repository contains scripts, test data, and sample output files for analysis done for chapter 2 of my PhD thesis

[Step 1](https://github.com/shivanshss/tcas_india_divergence_selection/blob/main/step1/step1.README)


Population Genomic Analysis Pipeline Step 1


1. Alignment and Data Preparation:
        Short reads from the sample dataset are aligned to a reference genome using a suitable aligner (e.g., BWA, Li and Durban, 2009).
        Unaligned or partially aligned reads are filtered out to ensure data quality.
        PCR duplicates are eliminated using tools like PicardTools to prevent inflated variant counts.

2. Variant Calling:
        Single nucleotide polymorphisms (SNPs) are identified using a variant caller (e.g., GATK haplotype caller, DePristo et al, 2011).
        The variant caller incorporates read information across potential variant sites for accurate variant detection.

3. VCF File Conversion and Merging:
        Genotyped VCF files produced by the variant caller are standardized and merged using relevant tools.
        The merged VCF file consolidates variant information across multiple samples.

4. Variant Filtering:
        The merged VCF file is subject to stringent filtering criteria to ensure reliable variant calls.
        Filters include parameters like minimum quality score, read depth thresholds, allele frequency bounds, and individual missingness.
        After filtering, variants meeting quality criteria are retained for further analysis.

5. SNP Annotation:
        ANNOVAR (Wang et al, 2010) is employed to annotate retained SNPs based on a genomic annotation file (e.g., GFF3).
        Annotations provide functional context by associating variants with genomic features.

6. Population Genomic Analysis:
        The filtered and annotated VCF dataset serves as the foundation for population genomic analysis.
        This analysis investigates aspects like genetic diversity, population structure, allele frequencies, and potential evolutionary insights.


