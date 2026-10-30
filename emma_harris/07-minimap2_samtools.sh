#!/bin/bash
#SBATCH --job-name=emma_primary_mapping
#SBATCH --output=map_%j.log
#SBATCH --error=map_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --partition=localQ
set -euo pipefail

# exit if a command fails
set -e

# load modules
module load minimap2/2.25
module load samtools/1.17

# map ONT reads to primary assembly (using minimap2) and sort directly to BAM (using samtools)
minimap2 -ax map-ont -t 16 \
    emma_ONT_hifi-asm_assembly_primary.fasta \
    combined.fastq.gz |
samtools sort -@ 16 -o emma_primary.bam

# index BAM
samtools index emma_primary.bam

# generate mapping statistics
samtools flagstat emma_primary.bam > emma_primary_flagstat.txt

echo "minimap2_samtools.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]