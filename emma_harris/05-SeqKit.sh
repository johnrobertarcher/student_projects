#!/bin/bash
#SBATCH --job-name=emma_ONT__seqkit_stats
#SBATCH --output=seqkit_%j.log
#SBATCH --error=seqkit_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --partition=localQ
set -euo pipefail

# exit if a command fails
set -e

# load environment
module load seqkit/2.5.2

# SeqKit stats
seqkit stats \
    emma_ONT_hifi-asm_assembly_primary.fasta \
    emma_ONT_hifi-asm_assembly_hap1.fasta \
    emma_ONT_hifi-asm_assembly_hap2.fasta

echo "SeqKit done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]