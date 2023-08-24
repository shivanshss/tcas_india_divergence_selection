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
    "$bwa" mem -B 8 -t "$num_threads" "$reference_genome" "$read1" "$read2" > "${sample_name}_aligned.sam"

    # Step 2: Convert SAM to BAM
    "$samtools" view -S -b "${sample_name}_aligned.sam" > "${sample_name}_aligned.bam"

    # Step 3: Sort BAM
    "$samtools" sort -@ "$num_threads" -o "${sample_name}_sorted.bam" "${sample_name}_aligned.bam"

    # Step 4: Index BAM
    "$samtools" index "${sample_name}_sorted.bam"

    # Clean up intermediate files
    rm "${sample_name}_aligned.sam" "${sample_name}_aligned.bam"


    # Step 5: Remove PCR duplicates using PicardTools
    java -jar "$picard_jar" MarkDuplicates I=${sample_name}_sorted.bam O=${sample_name}_deduplicated.bam M=${sample_name}_dedup_metrics.txt REMOVE_DUPLICATES=T REMOVE_SEQUENCING_DUPLICATES=T

    # Step 6: Call SNPs using GATK HaplotypeCaller
    "$gatk" HaplotypeCaller -R "$reference_genome" -I ${sample_name}_deduplicated.bam -O ${sample_name}_raw_variants.vcf -ERC GVCF --variant_index_type LINEAR --variant_index_parameter 128000

    # Step 7: Convert genotyped VCF to VCF format using GenotypeGVCFs
    "$gatk" --java-options "-Xmx128g" GenotypeGVCFs -R "$reference_genome" -V ${sample_name}_raw_variants.vcf -O ${sample_name}_merged_variants.vcf
        
    # Step 8: Filter merged VCF
    "$gatk" VariantFiltration -R "$reference_genome" -V ${sample_name}_merged_variants.vcf -filter "QD < 2.0" --filterName "QD2" -filter "QUAL < 30.0" --filterName "QUAL30" -filter "SOR > 3.0" --filterName "SOR3" -filter "FS > 60.0" --filterName "FS60" -filter "MQ < 40.0" --filterName "MQ40" -filter "MQRankSum < -12.5" --filterName "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filterName "ReadPosRankSum-8" -O ${sample_name}_filtered_variants.vcf

    # Step 9: Annotate SNPs using ANNOVAR
    perl "$annovar" ${sample_name}_filtered_variants.vcf "$annovar_db" -out ${sample_name}_annotated -vcfinput -remove -protocol refGeneWithVer -operation g -format vcf4 -allsample -withfreq -withzyg -nastring . -csvout -polish

done


echo "Analysis complete!"

