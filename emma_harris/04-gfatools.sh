#!/bin/bash
#SBATCH --job-name=emma_ONT_hifi-asm_assembly_GFA_to_FASTA
#SBATCH --output=hifiasm_%j.log
#SBATCH --error=hifiasm_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1             # number of CPU threads
#SBATCH --mem=4G                      # memory requirement
#SBATCH --time=00:30:00               # walltime limit (HH:MM:SS)
#SBATCH --partition=localQ            # localQ is default partition on Scamper
set -euo pipefail

# exit if a command fails
set -e

# load environment
module load gfatools/0.4-r214           

# extract primary consensus assembly
gfatools gfa2fa emma_ONT_hifi-asm_assembly.bp.p_ctg.gfa > emma_ONT_hifi-asm_assembly_primary.fasta

# extract phased haplotype 1
gfatools gfa2fa emma_ONT_hifi-asm_assembly.bp.hap1.p_ctg.gfa > emma_ONT_hifi-asm_assembly_hap1.fasta

# extract phased haplotype 2
gfatools gfa2fa emma_ONT_hifi-asm_assembly.bp.hap2.p_ctg.gfa > emma_ONT_hifi-asm_assembly_hap2.fasta

echo "gfatools done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]