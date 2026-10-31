#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J kraken2_contamination
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=12 
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/kraken_261019.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/kraken_261019.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu"
CONTAINER_PATH="${BASE}/students/_BIO511_containers/kraken2.sif"
DB_PATH="${BASE}/BIO511-2026/databases/kraken2_db"
DATA_PATH="${BASE}/students/katerina/project/results/qc_nano_fastplong/DSM114966_ONT_filtered.fastq.gz"
RESULTS_PATH="${BASE}/students/katerina/project/results/contamination"

PREFIX="$(basename "${DATA_PATH}" .fastq.gz)" 

# Bind paths for container
export APPTAINER_BINDPATH="${DB_PATH},$(dirname "${DATA_PATH}"),${RESULTS_PATH}"

# Create results directory
mkdir -p ${RESULTS_PATH}

# Run Kraken2 classification
srun singularity exec ${CONTAINER_PATH} kraken2 \
        --db ${DB_PATH} \
        --threads 10 \
        --output "${RESULTS_PATH}/${PREFIX}"_output.txt \
        --report "${RESULTS_PATH}/${PREFIX}"_report.txt \
        --classified-out "${RESULTS_PATH}/${PREFIX}"_classified.fastq \
        --unclassified-out "${RESULTS_PATH}/${PREFIX}"_unclassified.fastq \
        ${DATA_PATH}
echo "Completed classification for ${PREFIX}"