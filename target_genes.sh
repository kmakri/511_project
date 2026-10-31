#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J target_genes
#SBATCH -p vera
#SBATCH -N 1
#SBATCH --cpus-per-task=4
#SBATCH -t 01:00:00
#SBATCH -e /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/target_261023.err
#SBATCH -o /cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/logs/target_261023.out

set -euo pipefail

BASE="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project"
OVERVIEW="${BASE}/results/dbcan/cazymes/overview.tsv"
CGC="${BASE}/results/dbcan/cazymes/cgc_standard_out.tsv"
PROKKA_TSV="${BASE}/results/annotation/baseline/DSM114966.tsv"
RESULTS_PATH="${BASE}/results/gene_search"

mkdir -p "$RESULTS_PATH"

# Check that input files exist
for file in "$OVERVIEW" "$CGC" "$PROKKA_TSV"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Input file not found: $file" >&2
        exit 1
    fi
done

# counts proteins per cazy family (with at least 2 tools), subfamilies merged (so gh13_5 become gh13)
awk -F'\t' -v OFS='\t' '
NR==1 {
  for(i=1;i<=NF;i++){
    if($i~/Gene ID/)g=i
    if($i~/#ofTools/)t=i
    if($i~/Recommend/)r=i
  }
  if(!g || !t || !r){
    print "ERROR: Required columns not found in overview.tsv" > "/dev/stderr"
    exit 1
  }
  next
}
{
  if($(t)+0 < 2) next

  n=split($(r),a,/[+|]/)
  delete seen

  for(i=1;i<=n;i++){
    f=a[i]
    sub(/^[[:space:]]+|[[:space:]]+$/, "", f)
    sub(/\(.*/, "", f)
    sub(/_.*/, "", f)

    if(f~/^(GH|GT|PL|CE|AA|CBM)[0-9]+$/ && !seen[f]++){
      c[f]++
    }
  }
}
END {
  print "Family", "Gene_count"
  for(f in c) print f, c[f]
}' "$OVERVIEW" |
awk 'BEGIN{FS=OFS="\t"} NR==1{header=$0; next} {print}' |
sort -t "$(printf '\t')" -k2,2nr |
awk 'BEGIN{FS=OFS="\t"} NR==1{print "Family","Gene_count"} {print}' \
> "${RESULTS_PATH}/family_counts.tsv"

# finds mucin related genes and creates a table of them
# Only include genes supported by at least 2 tools.
# Keep the parent family and original subfamily.
awk -F'\t' -v OFS='\t' '
NR==1 {
  for(i=1;i<=NF;i++){
    if($i~/Gene ID/)g=i
    if($i~/#ofTools/)t=i
    if($i~/Recommend/)r=i
  }
  if(!g || !t || !r){
    print "ERROR: Required columns not found in overview.tsv" > "/dev/stderr"
    exit 1
  }
  next
}
{
  if($(t)+0 < 2) next

  gene=$(g)
  n=split($(r),a,/[+|]/)
  delete seen

  for(i=1;i<=n;i++){
    subfamily=a[i]
    sub(/^[[:space:]]+|[[:space:]]+$/, "", subfamily)
    sub(/\(.*/, "", subfamily)

    f=subfamily
    sub(/_.*/, "", f)

    if(f ~ /^GH(33|29|95|20|84|2|35|98|36|27|110|109|129|101|89|3)$/){
      key=gene SUBSEP f
      if(!seen[key]++){
        print gene, $(t), f
      }
    }
  }
}' "$OVERVIEW" | sort -t "$(printf '\t')" -k3,3 > "${RESULTS_PATH}/mucin_genes_raw.tsv"

# adds prokka gene/product and cgc membership
# CGC file columns:
# 1 = CGC#, 2 = Gene Type, 3 = Contig ID, 4 = Protein ID
printf "gene_id\tn_tools\tfamily\tprokka_gene\tprokka_product\tcgc\n" \
  > "${RESULTS_PATH}/mucin_gene_table.tsv"

while IFS=$'\t' read -r id tools fam; do
  gene=$(awk -F'\t' -v id="$id" 'NR>1 && $1==id {print $4; exit}' "$PROKKA_TSV")
  prod=$(awk -F'\t' -v id="$id" 'NR>1 && $1==id {print $7; exit}' "$PROKKA_TSV")

  # Match gene IDs only against CGC column 4 (Protein ID);
  # return the corresponding CGC ID from column 1.
  cgc=$(awk -F'\t' -v id="$id" '
    NR>1 && $4==id {
      if (!seen[$1]++) {
        result = result (result=="" ? "" : ";") $1
      }
    }
    END {print result}
  ' "$CGC")

  printf "%s\t%s\t%s\t%s\t%s\t%s\n" \
    "$id" "$tools" "$fam" "${gene:-}" "${prod:-}" "${cgc:-no}"
done < "$RESULTS_PATH/mucin_genes_raw.tsv" \
  >> "$RESULTS_PATH/mucin_gene_table.tsv"

# nan genes, sialic acid, sulfatases in prokka
# searches annotations by keyword, genes annotated as hypothetical proteins may be missed
{
  head -n 1 "$PROKKA_TSV"
  awk -F'\t' 'NR>1 && tolower($0) ~ /nan[ aekhtrb]|sialid|neuraminid|sialic|acetylneuraminate|acetylmannosamine|sulfatase|symporter/' "$PROKKA_TSV"
} > "$RESULTS_PATH/nan_sulfatase_hits.tsv"

echo "Family counts (top 10):"
head -n 11 "$RESULTS_PATH/family_counts.tsv"
echo
echo "Mucin rows:"
tail -n +2 "$RESULTS_PATH/mucin_gene_table.tsv" | wc -l
echo "nan/sulfatase hits:"
tail -n +2 "$RESULTS_PATH/nan_sulfatase_hits.tsv" | wc -l
echo
echo "Output files:"
echo "  ${RESULTS_PATH}/family_counts.tsv"
echo "  ${RESULTS_PATH}/mucin_genes_raw.tsv"
echo "  ${RESULTS_PATH}/mucin_gene_table.tsv"
echo "  ${RESULTS_PATH}/nan_sulfatase_hits.tsv"
