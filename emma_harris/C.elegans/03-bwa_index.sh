#!/bin/bash
#SBATCH --job-name=bwa-index
#SBATCH --output=bwa_index_%j.out
#SBATCH --error=bwa_index_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --partition=localQ

# exit if a command fails
set -eo pipefail

# load modules
module load bwa/0.7.17  
module load samtools/1.9 

# reference
REF_DIR="/Data2/john/student_projects/emma_harris/C.elegans/reference_genome"
REF="${REF_DIR}/caenorhabditis_elegans.PRJNA13758.WBPS19.genomic.fa"

# check reference exists
if [ ! -f "$REF" ]; then
    echo "reference not found: $REF" >&2
    exit 1
fi

# bwa index
bwa index "$REF"

# samtools faidx
samtools faidx "$REF"

# check index files were created
for EXT in amb ann bwt pac sa; do
    if [ ! -f "${REF}.${EXT}" ]; then
        echo "missing index file: ${REF}.${EXT}" >&2
        exit 1
    fi
done

echo "bwa_index.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]