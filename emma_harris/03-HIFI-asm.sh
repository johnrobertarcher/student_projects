#!/bin/bash
#SBATCH --job-name=emma_ONT_hifi-asm_assembly
#SBATCH --output=hifiasm_%j.log
#SBATCH --error=hifiasm_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32            # number of CPU threads
#SBATCH --mem=200G                    # memory requirement
#SBATCH --time=24:00:00               # walltime limit (HH:MM:SS)
#SBATCH --partition=localQ            # localQ is default partition on Scamper
set -euo pipefail

# exit if a command fails
set -e

# load environments
module load hifiasm/0.25.0             

# inputs
READS="/Data2/john/student_projects/emma_harris/combined.fastq.gz"

# setup
OUTPUT_PREFIX="/home/john/student_projects/emma_harris"

# hifi-asm (for ONT data)
# NOTE: The "-x" flag dictates the algorithm preset
# NOTE: overrides the conflicting internal presets using explicit ratio values
hifiasm --ont -x 0.75 -y 0.55 -o ${OUTPUT_PREFIX} -t ${SLURM_CPUS_PER_TASK} ${READS}

echo "hifi-asm assembly done"



### check job running (using Scamper):
# squeue -u john

### cancel job:
# scancel [JOB ID]