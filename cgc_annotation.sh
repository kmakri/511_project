#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J cgc_annotation
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cgc_anno_261022.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cgc_anno_261022.out

set -euo pipefail

# Project paths
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/dbcan.sif"
RESULTS_PATH="${BASE}/results/dbcan/cazymes"
DATABASE_PATH="${BASE}/databases/dbcan"

mkdir -p "${RESULTS_PATH}"

export APPTAINER_BINDPATH="${BASE}"

# trying out prodigal first since that's what prokka uses 
apptainer exec "${CONTAINER_PATH}" run_dbcan gff_process \
    --output_dir "${RESULTS_PATH}" \
    --db_dir "${DATABASE_PATH}" \
    --input_gff "${BASE}/results/annotation/baseline/DSM114966.gff" \
    --gff_type prodigal 

echo "CGC annotation completed"