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

# Paths
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/ont-qc.sif"
RESULTS_PATH="${BASE}/results/qc_nano_fastplong"
READS="${BASE}/data/DSM114966_ONT.fastq.gz"

# Output directories
OUT_DIR="${RESULTS_PATH}"
NANOPLOT_DIR="${RESULTS_PATH}/nanoplot_filtered"
mkdir -p "${OUT_DIR}" "${NANOPLOT_DIR}"

# Output filenames
PREFIX="$(basename "${READS}" .fastq.gz)"
FILTERED="${OUT_DIR}/${PREFIX}_filtered.fastq.gz"

# Container bindings
export APPTAINER_BINDPATH="${BASE}/data,${RESULTS_PATH}"

# Parameters
THREADS="${SLURM_CPUS_PER_TASK:-8}"
MIN_Q=10
MIN_LEN=800

echo "Starting Fastplong QC and filtering..."

srun singularity exec "${CONTAINER_PATH}" fastplong \
  --in "${READS}" \
  --out "${FILTERED}" \
  --html "${OUT_DIR}/fastplong.html" \
  --json "${OUT_DIR}/fastplong.json" \
  --length_required "${MIN_LEN}" \
  -q "${MIN_Q}" \
  --thread "${THREADS}"

echo "Fastplong QC and filtering completed."

# Check that the output exists and is non-empty
if [[ ! -s "${FILTERED}" ]]; then
    echo "ERROR: Filtered reads file is missing or empty: ${FILTERED}" >&2
    exit 1
fi

echo "Starting NanoPlot on filtered reads..."

srun singularity exec "${CONTAINER_PATH}" NanoPlot \
  --fastq "${FILTERED}" \
  --threads "${THREADS}" \
  --N50 \
  --outdir "${NANOPLOT_DIR}" \
  --prefix "${PREFIX}_filtered_"

echo "QC and filtering completed successfully."