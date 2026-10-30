#!/bin/bash
#SBATCH --job-name=nanoplot
#SBATCH --output=logs/nanoplot_%j.out
#SBATCH --error=logs/nanoplot_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --partition=localQ

# exit if a command fails
set -euo pipefail

# load modules
module load NanoPlot/1.46.2

# inputs
FASTQ= "/Data2/john/student_projects/emma_harris/combined.fastq.gz"

# outputs
OUTDIR=/ ### <- output directory

# setup
mkdir -p logs "${OUTDIR}"

# nanoplot
NanoPlot \
    --threads ${SLURM_CPUS_PER_TASK} \
    --fastq "${FASTQ}" \
    --outdir "${OUTDIR}/${SAMPLE}" \
    --prefix "${SAMPLE}_" \
    --title "${SAMPLE}" \
    --N50 \
    --loglength \
    --plots dot kde \
    --tsv_stats

echo "nanoplot.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]