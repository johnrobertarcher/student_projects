#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH --output=trimmomatic_%j.out
#SBATCH --error=trimmomatic_%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=08:00:00
#SBATCH --partition=localQ

# exit if a command fails
set -eo pipefail

### NOTE: the below can be used to check which adapters were used:
# john@Scamper:~/student_projects/emma_harris/C.elegans/scripts/scripts$ cd /Data2/john/student_projects/emma_harris/C.elegans/Cross/40-1376067336/00_fastq
# for adapter in AGATCGGAAGAGC CTGTCTCTTATACACATCT TGGAATTCTCGGGTGCCAAGG; do
#     echo -n "$adapter: "
#     zcat BC_R1_001.fastq.gz | awk 'NR%4==2' | head -n 100000 | grep -c "$adapter"
# done
# =AGATCGGAAGAGC: 1685
# =CTGTCTCTTATACACATCT: 0
# =TGGAATTCTCGGGTGCCAAGG: 0

# load modules
module load trimmomatic/0.39

# input
FASTQ_DIR="/Data2/john/student_projects/emma_harris/C.elegans/Parent/40-1377796707/00_fastq"

# adapter file
ADAPTERS="/Data2/john/student_projects/emma_harris/C.elegans/adapters/TruSeq3-PE-2.fa"

# output
TRIM_DIR="${FASTQ_DIR}/trimmed"
PAIRED_DIR="${TRIM_DIR}/paired"
UNPAIRED_DIR="${TRIM_DIR}/unpaired"
LOG_DIR="${TRIM_DIR}/logs"

# setup
mkdir -p "$PAIRED_DIR" "$UNPAIRED_DIR" "$LOG_DIR"

# check input files exist
shopt -s nullglob
R1_FILES=("$FASTQ_DIR"/*_R1*.fastq.gz)
if [ ${#R1_FILES[@]} -eq 0 ]; then
    echo "No *_R1*.fastq.gz files found in $FASTQ_DIR" >&2
    exit 1
fi

# trimmomatic (one sample at a time)
for R1 in "${R1_FILES[@]}"; do
    R2="${R1/_R1/_R2}"
    if [ ! -f "$R2" ]; then
        echo "Missing R2 file for $R1" >&2
        exit 1
    fi

    SAMPLE=$(basename "$R1")
    SAMPLE="${SAMPLE%%_R1*}"
    echo "Trimming $SAMPLE"

    trimmomatic PE \
        -threads "$SLURM_CPUS_PER_TASK" \
        -phred33 \
        -summary "${LOG_DIR}/${SAMPLE}_summary.txt" \
        "$R1" "$R2" \
        "${PAIRED_DIR}/${SAMPLE}_R1_paired.fastq.gz" \
        "${UNPAIRED_DIR}/${SAMPLE}_R1_unpaired.fastq.gz" \
        "${PAIRED_DIR}/${SAMPLE}_R2_paired.fastq.gz" \
        "${UNPAIRED_DIR}/${SAMPLE}_R2_unpaired.fastq.gz" \
        ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
        LEADING:3 \
        TRAILING:3 \
        SLIDINGWINDOW:4:15 \
        MINLEN:36
done

echo "trimmomatic done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]