#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J MultiQC_all
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/multiqc_2_261020.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/multiqc_2_261020.out

# electric boogaloo
# kraken, fastplong, nanoplots, flye basic and polished
set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students"
CONTAINER_PATH="${BASE}/_BIO511_containers/multiqc.sif"
RESULTS_PATH="${BASE}/katerina/project/results"
OUTPUT_PATH="${RESULTS_PATH}/multiqc_all"

mkdir -p "${OUTPUT_PATH}"

export APPTAINER_BINDPATH="${RESULTS_PATH}"

singularity exec "${CONTAINER_PATH}" multiqc --version

singularity exec "${CONTAINER_PATH}" multiqc \
  "${RESULTS_PATH}/raw_nanoplot/nanoplot_raw" \
  "${RESULTS_PATH}/qc_nano_fastplong" \
  "${RESULTS_PATH}/assembly/quast" \
  "${RESULTS_PATH}/contamination/DSM114966_ONT_filtered_report.txt" \
  --outdir "${OUTPUT_PATH}" \
  --filename DSM114966_multiqc_all \
  --dirs --dirs-depth 1 \
  --ignore "*.fastq" \
  --force

echo "MultiQC completed"