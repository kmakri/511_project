#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J fastani
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/fastani2_261021.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/fastani2_261021.out

set -euo pipefail

# Project paths
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/fastani.sif"
RESULTS_PATH="${BASE}/results/fastani"

# Input genomes
# for query: the polished assembly version is preferred bc fastani compares dna sequences, not annotations
QUERY="${BASE}/results/annotation/baseline/DSM114966.fna"
REFERENCE="${BASE}/results/annotation/baseline_ref/DSM114966.fna"

# Create output directory
mkdir -p "${RESULTS_PATH}"

cd "${RESULTS_PATH}"

singularity exec --bind "${BASE}:${BASE}" \
    "${CONTAINER_PATH}" fastANI \
    -q "${QUERY}" \
    -r "${REFERENCE}" \
    -t "${SLURM_CPUS_PER_TASK}" \
    -o "${RESULTS_PATH}/fastani_prokka_results.txt" \
    --visualize

echo "FastANI completed"

# ANI=99.77%   
# 983: the number of fragments that mapped (matched) between query and reference
# 989: the total number of fragments from query
# same result as previous fastani
# FastANI only reads the nucleotide sequence, never the headers or annotations, 
# so it sees exactly the same genomes as in the first run and gives the same answer
# baseline_ref was produced by running Prokka on GCF_009831375.1, 
# its .fna is the same sequence as the ncbi file i used the first time