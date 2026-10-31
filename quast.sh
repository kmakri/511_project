#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J quast
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=12
#SBATCH -t 02:30:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/quast_261020.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/quast_261020.out

set -euo pipefail

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
BASE="/cephyr/users/makri/Vera/n2bin_gu/students"
RESULTS_PATH="${BASE}/katerina/project/results"
OUTPUT_DIR="${RESULTS_PATH}/assembly/quast"
CONTAINER_PATH="${BASE}/_BIO511_containers/quast.sif"

# Set the path to the assemblies (This should point to the directory containing the Flye assembly outputs)
ASSEMBLIES_DIR="${RESULTS_PATH}/assembly"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLIES_DIR}:/assembly,${OUTPUT_DIR}:/output"

# Create output directory
mkdir -p ${OUTPUT_DIR}

# Run QUAST on both assemblies
singularity exec ${CONTAINER_PATH} quast.py \
    -o ${OUTPUT_DIR} \
    --threads 4 \
    --plots-format png \
    --labels "Basic,Polished" \
    /assembly/flye_basic/assembly.fasta \
    /assembly/flye_polished/assembly.fasta

echo "QUAST analysis completed"
