#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J plot_gh
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=1
#SBATCH -t 00:05:00
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/plot_gh_%j.out
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/plot_gh_%j.err

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
RESULTS_PATH="${BASE}/results/gene_search"

python3 "${BASE}/scripts/cgc_table.py" "${RESULTS_PATH}/family_counts.tsv" "${RESULTS_PATH}/fig1_gh_families.svg"
