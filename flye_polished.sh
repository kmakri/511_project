#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J flye_polished
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=12
#SBATCH -t 02:30:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/flyepolished_261020.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/flyepolished_261020.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students"
RESULTS_PATH="${BASE}/katerina/project/results/assembly/flye_polished"
DATA_PATH="${BASE}/katerina/project/results/qc_nano_fastplong"
SINGULARITY_PATH="${BASE}/_BIO511_containers/flye.sif"

# Create output directory before binding it
mkdir -p "${RESULTS_PATH}"

# Bind paths for Singularity
export SINGULARITY_BINDPATH="${DATA_PATH}:/data,${RESULTS_PATH}:/results"

singularity exec "${SINGULARITY_PATH}" flye \
     --nano-raw /data/DSM114966_ONT_filtered.fastq.gz \
     --out-dir /results \
     --threads 12 \
     --iterations 5

echo "Basic ONT assembly completed"