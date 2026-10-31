#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J fastani
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cazyme_261022.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cazyme_261022.out

set -euo pipefail

# Project paths
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/dbcan.sif"
RESULTS_PATH="${BASE}/results/dbcan/cazymes"
DATABASE_PATH="${BASE}/databases/dbcan"

mkdir -p "${RESULTS_PATH}"

# Bind paths for container 
# A container sees only its own filesystem, plus a few folders that are mounted automatically 
# (your home directory and the current directory). Anything else on the cluster is invisible to it
# unless you bind it. A bind makes a host folder appear inside the container.
export APPTAINER_BINDPATH="${BASE}"

# using the prokka .faa file as the input, since it has the proteins that have already been
# predicted by prokka, so the dbcan results will have the same locus tags
# so we can line up the cazyme hits and the prokka names easily 
apptainer exec "${CONTAINER_PATH}" run_dbcan CAZyme_annotation \
    --input_raw_data "${BASE}/results/annotation/baseline/DSM114966.faa" \
    --output_dir "${RESULTS_PATH}" \
    --db_dir "${DATABASE_PATH}" \
    --mode protein

echo "CAZyme search with dbcan completed"