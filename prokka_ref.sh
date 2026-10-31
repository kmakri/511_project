#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J prokka
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/prokka_ref_261021.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/prokka_ref_261021.out

set -euo pipefail

# Input path
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/prokka.sif"
RESULTS_PATH="${BASE}/results/annotation"
ASSEMBLY="${BASE}/data/ncbi_dataset/data/GCF_009831375.1/GCF_009831375.1_ASM983137v1_genomic.fna"
# Output path
mkdir -p "${RESULTS_PATH}"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLY},${RESULTS_PATH}"

# Set a prefix variable for naming outputs
PREFIX="DSM114966"
THREADS=${SLURM_CPUS_PER_TASK}

# Run Prokka (baseline)
singularity exec ${CONTAINER_PATH} prokka \
  --cpus ${THREADS} \
  --outdir ${RESULTS_PATH}/baseline_ref \
  --prefix ${PREFIX} \
  --locustag DSM \
  --strain ATCC29149 \
  --genus Mediterraneibacter \
  --species gnavus \
  ${ASSEMBLY}

echo "Baseline Prokka annotation completed"