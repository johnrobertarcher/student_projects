#!/bin/bash
#SBATCH --job-name=illumina_map_to_pelodera
#SBATCH --output=illumina_map_to_pelodera%j.out
#SBATCH --error=illumina_map_to_pelodera%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --partition=localQ
set -euo pipefail

# exit if a command fails
set -e

# input
ASSEMBLY="/home/john/student_projects/emma_harris/emma_ONT_hifi-asm_assembly_primary.fasta"
R1="/Data2/john/student_projects/emma_harris/illumina/00_fastq/emma-pelodera1_R1_001.fastq.gz"
R2="/Data2/john/student_projects/emma_harris/illumina/00_fastq/emma-pelodera1_R2_001.fastq.gz"

# input (generated during script)
SAM="illumina_reads_mapped_to_pelodera_primary_assembly.sam"
BAM="illumina_reads_mapped_to_pelodera_primary_assembly.bam"
SORTED_BAM="illumina_reads_mapped_to_pelodera_primary_assembly.sorted.bam"

# load enviroment
module load bwa/0.7.17
module load samtools/1.9

# bwa index assembly
bwa index "$ASSEMBLY"

# map illumina reads to Pelodera ONT assembly
bwa mem \
    -t "$SLURM_CPUS_PER_TASK" \
    -o "$SAM" \
    "$ASSEMBLY" \
    "$R1" \
    "$R2"

# mapping stats
samtools flagstat "$SAM"

# convert SAM to BAM
samtools view \
    -@ "$SLURM_CPUS_PER_TASK" \
    -b \
    -o "$BAM" \
    "$SAM"

# sort BAM
samtools sort \
    -@ "$SLURM_CPUS_PER_TASK" \
    -o "$SORTED_BAM" \
    "$BAM"

# index sorted BAM
samtools index \
    "$SORTED_BAM"

echo "illumina_map_to_ONT.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]