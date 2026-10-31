#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J qc_filter
#SBATCH -p vera
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/qc_261019.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/qc_261019.out

set -euo pipefail

# Input path
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/ont-qc.sif"
RESULTS_PATH="${BASE}/results/raw_nanoplot"
READS="${BASE}/data/DSM114966_ONT.fastq.gz"  

# Output path
mkdir -p "${RESULTS_PATH}"/{nanoplot_raw}

THREADS="${SLURM_CPUS_PER_TASK:-8}"

# Output files name
PREFIX="$(basename "${READS}" .fastq.gz)" 

# Bind path for container
READS_TARGET_DIR="$(dirname "$(readlink -f "${READS}")")"
export APPTAINER_BINDPATH="${BASE}/data,${READS_TARGET_DIR},${RESULTS_PATH}"

# raw read nanoplot
singularity exec "${CONTAINER_PATH}" NanoPlot \
  --fastq "${READS}" \
  --threads "${THREADS}" \
  --N50 \
  --outdir "${RESULTS_PATH}/nanoplot_raw" \
  --prefix ${PREFIX}_raw_

echo "Raw QC completed"

# to decide the parameters, check the raw nanoplot and look at:
# read-length distribution: most reads seem to have a length of about 1000bp
# mean read quality, above q10: 5407 (71.7%) 17.9Mb
# n50: 6,518.0
# total yield