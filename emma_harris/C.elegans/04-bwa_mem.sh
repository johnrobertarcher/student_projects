#!/bin/bash
### NOTE: processes both Parent and Cross as array
#SBATCH --job-name=bwa-map
#SBATCH --output=bwa_map_%A_%a.out
#SBATCH --error=bwa_map_%A_%a.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH --partition=localQ
#SBATCH --array=0-1

# exit if a command fails
set -eo pipefail

# load modules (check names with: module avail bwa samtools)
module load bwa/0.7.17
module load samtools/1.9 

# reference
REF="/Data2/john/student_projects/emma_harris/C.elegans/reference_genome/caenorhabditis_elegans.PRJNA13758.WBPS19.genomic.fa"

# datasets (array task 0 = Cross; array task 1 = Parent)
NAMES=("Cross" "Parent")
BASES=(
    "/Data2/john/student_projects/emma_harris/C.elegans/Cross/40-1376067336"
    "/Data2/john/student_projects/emma_harris/C.elegans/Parent/40-1377796707"
)

DATASET="${NAMES[$SLURM_ARRAY_TASK_ID]}"
BASE="${BASES[$SLURM_ARRAY_TASK_ID]}"

# input
FASTQ_DIR="${BASE}/00_fastq/trimmed/paired"

# output
BAM_DIR="${BASE}/mapped"

# setup
mkdir -p "$BAM_DIR"

# check reference and index exist
if [ ! -f "$REF" ] || [ ! -f "${REF}.bwt" ]; then
    echo "reference or BWA index not found: $REF" >&2
    exit 1
fi

# check input files exist
shopt -s nullglob
R1_FILES=("$FASTQ_DIR"/*_R1_paired.fastq.gz)
if [ ${#R1_FILES[@]} -eq 0 ]; then
    echo "no *_R1_paired.fastq.gz files found in $FASTQ_DIR" >&2
    exit 1
fi

# map reads, sort, and mark duplicates
for R1 in "${R1_FILES[@]}"; do
    R2="${R1/_R1_paired/_R2_paired}"
    if [ ! -f "$R2" ]; then
        echo "missing R2 file for $R1" >&2
        exit 1
    fi

    SAMPLE=$(basename "$R1")
    SAMPLE="${SAMPLE%%_R1_paired*}"
    LABEL="${DATASET}_${SAMPLE}"
    echo "mapping $LABEL"

    bwa mem \
        -t "$SLURM_CPUS_PER_TASK" \
        -R "@RG\tID:${LABEL}\tSM:${LABEL}\tPL:ILLUMINA" \
        "$REF" "$R1" "$R2" \
    | samtools fixmate -m - - \
    | samtools sort -@ 4 - \
    | samtools markdup -@ 4 - "${BAM_DIR}/${LABEL}.markdup.bam"

    samtools index "${BAM_DIR}/${LABEL}.markdup.bam"
    samtools flagstat "${BAM_DIR}/${LABEL}.markdup.bam" > "${BAM_DIR}/${LABEL}.flagstat.txt"
done

echo "bwa_mem.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]