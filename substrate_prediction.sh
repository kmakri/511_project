#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J substrates
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/subs_pred_261022.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/subs_pred_261022.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/dbcan.sif"
RESULTS_PATH="${BASE}/results/dbcan/cazymes"
DATABASE_PATH="${BASE}/databases/dbcan"

export APPTAINER_BINDPATH="${BASE}"

apptainer exec "${CONTAINER_PATH}" run_dbcan substrate_prediction \
    --input_raw_data "${RESULTS_PATH}/uniInput.faa" \
    --mode protein \
    --output_dir "${RESULTS_PATH}" \
    --db_dir "${DATABASE_PATH}" \

echo "Substrate prediction completed"
