#!/bin/bash
#SBATCH --job-name=pelodera_pilon
#SBATCH --output=pelodera_pilon%j.out
#SBATCH --error=pelodera_pilon%j.err
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
BAM="/home/john/student_projects/emma_harris/illumina_reads_mapped_to_pelodera_primary_assembly.sorted.bam"

# output
OUTPUT_PREFIX="pelodera_pilon"

# load modules
module load pilon/1.24

# polish assembly using illumina reads
pilon \
    --genome "$ASSEMBLY" \
    --frags "$BAM" \
    --output "$OUTPUT_PREFIX" \
    --threads "$SLURM_CPUS_PER_TASK"

echo "pilon.sh done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]