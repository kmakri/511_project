def calculate_coding_density(gff_file, fasta_file):
    # calculate actual genome size from fasta
    total_genome_size = 0

    with open(fasta_file, "r") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith(">"):
                total_genome_size += len(line)

    if total_genome_size == 0:
        return "No genome sequence found in FASTA file."

    # Calculate total CDS length from GFF
    cds_length = 0

    with open(gff_file, "r") as f:
        for line in f:
            if line.startswith("##FASTA"):
                break

            if line.startswith("#") or not line.strip():
                continue

            parts = line.rstrip("\n").split("\t")

            if len(parts) != 9:
                continue

            if parts[2] == "CDS":
                start = int(parts[3])
                end = int(parts[4])
                cds_length += end - start + 1

    density = (cds_length / total_genome_size) * 100

    return (
        f"Genome Size: {total_genome_size:,} bp\n"
        f"Total CDS Length: {cds_length:,} bp\n"
        f"Coding Density: {density:.2f}%"
    )

# gff_file = "/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline/DSM114966.gff"
# # contains complete genome sequences used in the gff

# fasta_file = "/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline/DSM114966.fna"

gff_file = "/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline_ref/DSM114966.gff"
fasta_file = "/cephyr/users/makri/Vera/n2bin_gu/students/katerina/project/results/annotation/baseline_ref/DSM114966.fna"


print(calculate_coding_density(gff_file, fasta_file))

# my strain:
# Genome Size: 3,051,763 bp
# Total CDS Length: 2,640,411 bp
# Coding Density: 86.52%

# ref genome:
# Genome Size: 3,549,191 bp
# Total CDS Length: 3,187,302 bp
# Coding Density: 89.80%