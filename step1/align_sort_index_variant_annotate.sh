# Read config file
if [ $# -ne 1 ]; then
    echo "Usage: $0 <config_file>"
    exit 1
fi

config_file="$1"
if [ ! -f "$config_file" ]; then
    echo "Config file not found: $config_file"
    exit 1
fi

source "$config_file"

# Step 1: Loop through sample_info and process each sample
for sample_name in "${!sample_info[@]}"; do
    read_files="${sample_info[$sample_name]}"
    read_files_arr=($read_files)
    read1="${read_files_arr[0]}"
    read2="${read_files_arr[1]}"

    # Step 1: Align reads using BWA
    "$bwa" mem -t "$num_threads" "$reference_genome" "$read1" "$read2" > "${sample_name}_aligned.sam"

    # Step 2: Convert SAM to BAM
    "$samtools" view -S -b "${sample_name}_aligned.sam" > "${sample_name}_aligned.bam"

    # Step 3: Sort BAM
    "$samtools" sort -@ "$num_threads" -o "${sample_name}_sorted.bam" "${sample_name}_aligned.bam"

    # Step 4: Index BAM
    "$samtools" index "${sample_name}_sorted.bam"

    # Clean up intermediate files
    rm "${sample_name}_aligned.sam" "${sample_name}_aligned.bam"
done

# Step 5: Remove PCR duplicates using PicardTools
java -jar "$picard_jar" MarkDuplicates I=sample1_sorted.bam O=sample1_deduplicated.bam M=sample1_dedup_metrics.txt

# Step 6: Call SNPs using GATK HaplotypeCaller
"$gatk" HaplotypeCaller -R "$reference_genome" -I sample1_deduplicated.bam -O sample1_raw_variants.vcf

# Step 7: Convert genotyped VCF to VCF format using GenotypeGVCFs
"$gatk" GenotypeGVCFs -R "$reference_genome" -V sample1.vcf -O sample1_merged.vcf

# Step 8: Filter merged VCF
"$gatk" VariantFiltration -R "$reference_genome" -V sample1_merged.vcf --filter-expression "QUAL < 20 || DP < 5 || DP > 500 || AF < 0.1 || AF > 0.8 || ExcessHet > 54.69 || InbreedingCoeff < -0.3" --filter-name "custom_filter" -O sample1_filtered.vcf

# Step 9: Annotate SNPs using ANNOVAR
"$annovar" sample1_filtered.vcf "$annovar_db" -buildver "$genome_build" -out sample1_annotated -remove -protocol refGene -operation g

echo "Analysis complete!"

