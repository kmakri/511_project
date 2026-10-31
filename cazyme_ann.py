# Filter to #ofTools ≥ 2 and count proteins per family, dbcan recommends taking into account those with at least 2 tools
import csv
from collections import Counter

INPUT="/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/dbcan/cazymes/overview.tsv"
OUTPUT = "/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/dbcan/cazyme_summary.txt"

with open(INPUT, newline="") as f:
    reader = csv.DictReader(f, delimiter="\t")
    rows = list(reader)

# Filter candidates supported by at least 2 tools
good = [row for row in rows if int(row["#ofTools"]) >= 2]

# Count proteins per recommended family
family_counts = Counter(
    row["Recommend Results"].strip()
    for row in good
    if row["Recommend Results"].strip() not in ("", "-")
)

# Count proteins by major CAZyme class
class_counts = Counter()

for family, count in family_counts.items():
    if family.startswith("CBM"):
        class_name = "CBM"
    else:
        class_name = "".join(c for c in family if c.isalpha())

    class_counts[class_name] += count

# Write results to a new file
with open(OUTPUT, "w") as out:
    print(f"Total CAZyme candidates: {len(rows)}", file=out)
    print(f"Candidates with >=2 tools: {len(good)}", file=out)

    print("\nProteins per CAZyme family (>=2 tools):", file=out)
    for family, count in family_counts.most_common():
        print(f"{family}\t{count}", file=out)

    print("\nProteins per CAZyme class (>=2 tools):", file=out)
    for class_name, count in class_counts.most_common():
        print(f"{class_name}\t{count}", file=out)

print(f"Results saved to {OUTPUT}")
