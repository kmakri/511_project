#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J MultiQC
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=2
#SBATCH -t 00:15:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/multiqc_261020.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/multiqc_261020.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students"
CONTAINER_PATH="${BASE}/_BIO511_containers/multiqc.sif"
RESULTS_PATH="${BASE}/katerina/project/results/contamination"
OUTPUT_PATH="${RESULTS_PATH}/multiqc"

mkdir -p "${OUTPUT_PATH}"

export APPTAINER_BINDPATH="${RESULTS_PATH}"

singularity exec "${CONTAINER_PATH}" multiqc --version

singularity exec "${CONTAINER_PATH}" multiqc \
  "${RESULTS_PATH}" \
  --outdir "${OUTPUT_PATH}" \
  --filename DSM114966_multiqc \
  --dirs --dirs-depth 1 \
  --force

echo "MultiQC completed"