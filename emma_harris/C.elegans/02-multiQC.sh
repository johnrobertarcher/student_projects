#!/bin/bash
#SBATCH --job-name=fastqc-multiqc
#SBATCH --output=fastqc_multiqc_%j.out
#SBATCH --error=fastqc_multiqc_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --partition=localQ

# exit if a command fails
set -euo pipefail

# load modules
module load fastQC/0.11.7
module load multiqc/1.8

# input
FASTQ_DIR="/Data2/john/student_projects/emma_harris/C.elegans/Cross/40-1376067336/00_fastq"

# output
FASTQC_DIR="${FASTQ_DIR}/fastqc"
MULTIQC_DIR="${FASTQ_DIR}/multiqc"

# setup
mkdir -p "${FASTQ_DIR}/fastqc"
mkdir -p "${FASTQ_DIR}/multiqc"

# fastQC
fastqc \
    --threads "$SLURM_CPUS_PER_TASK" \
    --outdir "$FASTQC_DIR" \
    "$FASTQ_DIR"/*.fastq.gz

# multiQC
multiqc \
    "$FASTQC_DIR" \
    --outdir "$MULTIQC_DIR"

echo "multiQC.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]