#!/bin/bash
#SBATCH --job-name=emma_primary_assembly_FASTA_BUSCO
#SBATCH --output=busco_%j.log
#SBATCH --error=busco_%j.err
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
module load busco/5.7.1

# BUSCO using primary assembly
busco \
    -i emma_ONT_hifi-asm_assembly_primary.fasta \
    -o emma_primary_BUSCO \
    -m genome \
    -l nematoda_odb10 \
    -c 16 \
    --offline

echo "BUSCO done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]