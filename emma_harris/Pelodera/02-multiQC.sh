#!/bin/bash
#SBATCH --job-name=fastqc_multiqc
#SBATCH --output=logs/fastqc_multiqc_%j.out
#SBATCH --error=logs/fastqc_multiqc_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --partition=localQ

# exit if a command fails
set -euo pipefail

# load modules
module load multiqc/1.8

# inputs
FASTQ= ### <- fastq

# outputs
OUTDIR=/ ### <- output directory

# setup
FASTQC_DIR= ### <- fastQC output directory
MULTIQC_DIR= ### <- multiQC output directory
REPORT_NAME= ### <- multiQC report name
mkdir -p logs "${FASTQC_DIR}" "${MULTIQC_DIR}"

# fastQC
fastqc \
    --threads ${SLURM_CPUS_PER_TASK} \
    --outdir "${FASTQC_DIR}" \
    "${FASTQ_DIR}"/*.fastq.gz

# multiQC
multiqc "${FASTQC_DIR}" \
    --outdir "${MULTIQC_DIR}" \
    --filename "${REPORT_NAME}" \
    --title "Illumina QC" \
    --force

    echo "multiQC.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]