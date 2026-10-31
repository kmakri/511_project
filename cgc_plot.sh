#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J cgc_plot
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cgc_plot_261022.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/cgc_plot_261022.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/dbcan.sif"
RESULTS_PATH="${BASE}/results/dbcan/cazymes"

export APPTAINER_BINDPATH="${BASE}"

apptainer exec "${CONTAINER_PATH}" run_dbcan cgc_circle_plot --output_dir "${RESULTS_PATH}"

echo "CGC plot completed"