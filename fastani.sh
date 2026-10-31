#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J fastani
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/fastani_261021.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/fastani_261021.out

set -euo pipefail

# Project paths
BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
CONTAINER_PATH="${BASE}/containers/fastani.sif"
RESULTS_PATH="${BASE}/results/fastani"

# Input genomes
# for query: the polished assembly version is preferred bc fastani compares dna sequences, not annotations
QUERY="${BASE}/results/assembly/flye_polished/assembly.fasta"
REFERENCE="${BASE}/data/ncbi_dataset/data/GCF_009831375.1/GCF_009831375.1_ASM983137v1_genomic.fna"

# Create output directory
mkdir -p "${RESULTS_PATH}"

cd "${RESULTS_PATH}"

singularity exec --bind "${BASE}:${BASE}" \
    "${CONTAINER_PATH}" fastANI \
    -q "${QUERY}" \
    -r "${REFERENCE}" \
    -t "${SLURM_CPUS_PER_TASK}" \
    -o "${RESULTS_PATH}/fastani_results.txt" \
    --visualize

echo "FastANI completed"

# ANI = 99.77% average nucleotide identity between the two genomes
# 983: the number of fragments that mapped (matched) between query and reference
# 989: the total number of fragments from query
# fastANI only reports identity over the shared, mappable parts of the genome. 
# It doesn’t tell you about gene content differences, structural rearrangements, 
# or what’s in the unmapped fragments
# for a more fair comparison, i'm gonna compare the prokka assemblies of my strain and the ref