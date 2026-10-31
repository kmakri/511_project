import csv
import sys

infile, outfile = sys.argv[1], sys.argv[2]
core = {"GH33", "GH29", "GH95", "GH20", "GH84"} # cut the sugars off mucin O-glycans

rows = []
with open(infile) as fh:
    for r in csv.reader(fh, delimiter="\t"):
        if len(r) >= 2 and r[0].startswith("GH"):
            rows.append((r[0], int(r[1])))
rows.sort(key=lambda x: -x[1])
if not rows:
    sys.exit("No GH families found in " + infile)

bar_w, gap = 18, 6
left, top, plot_h, bottom = 50, 20, 260, 70
width = left + len(rows) * (bar_w + gap) + 20
height = top + plot_h + bottom
ymax = max(c for _, c in rows)

svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
       f'font-family="sans-serif" font-size="10">',
       f'<rect width="{width}" height="{height}" fill="white"/>']

step = 1 if ymax <= 10 else 2 if ymax <= 20 else 5
for v in range(0, ymax + 1, step):
    y = top + plot_h - plot_h * v / ymax
    svg.append(f'<line x1="{left}" y1="{y}" x2="{width-10}" y2="{y}" stroke="#e5e5e5"/>')
    svg.append(f'<text x="{left-6}" y="{y+3}" text-anchor="end">{v}</text>')

# bars and rotated labels
for i, (name, c) in enumerate(rows):
    x = left + i * (bar_w + gap) + gap
    h = plot_h * c / ymax
    y = top + plot_h - h
    col = "#c0392b" if name in core else "#999999"
    svg.append(f'<rect x="{x}" y="{y}" width="{bar_w}" height="{h}" fill="{col}"/>')
    lx, ly = x + bar_w / 2, top + plot_h + 8
    svg.append(f'<text x="{lx}" y="{ly}" transform="rotate(90 {lx} {ly})">{name}</text>')

svg.append("</svg>")
with open(outfile, "w") as fh:
    fh.write("\n".join(svg))
print(f"Wrote {outfile} ({len(rows)} GH families)")