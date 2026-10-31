#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J hypothetical_proteins
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=2
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/hypothetical_ref2_261021.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/hypothetical__ref2_261021.out

set -euo pipefail

INPUT_FILE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline/DSM114966.faa"
OUTPUT_DIR="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline_ref/hypothetical"

mkdir -p "$OUTPUT_DIR"

GENE_NAME_PATTERN="hypothetical protein"

base_name=$(basename "$INPUT_FILE" .faa)

# Count all proteins
total_proteins=$(grep -c "^>" "$INPUT_FILE" || true)

# Extract hypothetical protein sequences
grep -A 1 -i -E "$GENE_NAME_PATTERN" "$INPUT_FILE" \
  > "$OUTPUT_DIR/${base_name}_filtered.ffn" || true

# Count hypothetical proteins
hypothetical_count=$(grep -c "^>" "$OUTPUT_DIR/${base_name}_filtered.ffn" || true)

# Calculate percentage
if (( total_proteins > 0 )); then
    percentage=$(awk -v h="$hypothetical_count" -v t="$total_proteins" \
        'BEGIN { printf "%.2f", (h/t)*100 }')
else
    percentage="0.00"
fi

# Save results
echo -e "File\tHypothetical_Count\tTotal_Proteins\tHypothetical_Percentage" \
    > "$OUTPUT_DIR/gene_counts.tsv"

echo -e "${base_name}\t${hypothetical_count}\t${total_proteins}\t${percentage}" \
    >> "$OUTPUT_DIR/gene_counts.tsv"

echo "Total proteins: $total_proteins"
echo "Hypothetical proteins: $hypothetical_count"
echo "Percentage: ${percentage}%"

# ref faa:
# Total proteins: 3487
# Hypothetical proteins: 565
# Percentage: 16.20%

# ref faa (prokka)
# Total proteins: 3475
# Hypothetical proteins: 1723
# Percentage: 49.58%

# my strain faa
# Total proteins: 3916
# Hypothetical proteins: 2212
# Percentage: 56.49%