#!/usr/bin/env bash
set -euo pipefail

# --- SOURCE TREE (your Overleaf project lives here) ---
SRC_ROOT="overleaf_revtex_short_review_v1 (2)"
SRC_MAIN="$SRC_ROOT/main.tex"
SRC_SECTIONS_DIR="$SRC_ROOT/sections"
SRC_BIB="$SRC_ROOT/bib.bib"
SRC_FIGS_DIR="$SRC_ROOT/figures"   # copied if it exists

# --- OUTPUT (submission package) ---
OUT_ROOT="JNER_Submission/manuscript"
OUT_SECTIONS="$OUT_ROOT/sections"
OUT_FIGS="$OUT_ROOT/figures"

# --- Sanity checks ---
[ -d "$SRC_ROOT" ] || { echo "ERROR: '$SRC_ROOT' not found in repo root"; exit 1; }
[ -f "$SRC_MAIN" ] || { echo "ERROR: '$SRC_MAIN' not found"; exit 1; }
[ -f "$SRC_BIB" ]  || { echo "ERROR: '$SRC_BIB' not found"; exit 1; }

# --- Create folders ---
mkdir -p "$OUT_SECTIONS" "$OUT_FIGS" JNER_Submission/{cover_letter,scripts,supp}

# --- Cover letter (LaTeX) ---
cat > JNER_Submission/cover_letter/cover_letter_JNER.tex <<'CL'
\documentclass[11pt]{letter}
\usepackage{geometry}
\geometry{a4paper, margin=1in}
\begin{document}
\begin{letter}{Editorial Office \\ Journal of NeuroEngineering and Rehabilitation}
\opening{Dear Editors,}
On behalf of my coauthors, I am pleased to submit our manuscript entitled
\textbf{“Biohybrid Cochlear Implants: Neural Interfaces, Regenerative Pathways, and Translational Benchmarks”}
for consideration as a \emph{Topical Review} in the \emph{Journal of NeuroEngineering and Rehabilitation}.
This review synthesizes current knowledge at the intersection of auditory neuroscience, regenerative medicine, and neural interface engineering. Specifically, we highlight: (i) the electrode–neuron gap; (ii) the microanatomy of the Canaliculi Perforantes of Schuknecht (CPS); (iii) biomaterial interfaces (conductive polymers, hydrogels, zwitterionic coatings); (iv) neurotrophin and cell-based strategies; and (v) enabling acoustofluidics (SAW) and sensing concepts.
We confirm the work is original, not under consideration elsewhere, and approved by all authors. We have no conflicts of interest to declare.
We believe the review fits squarely within JNER’s aims and scope, bridging neuroscience, rehabilitation, and engineering. Thank you for your consideration.
\closing{Sincerely,}
\vspace{1em}
Akihiro J. Matsuoka, MD, PhD \\
University of California San Diego \\
(On behalf of all coauthors)
\end{letter}
\end{document}
CL

# --- Clean main (journal-ready, article class + natbib) ---
cat > "$OUT_ROOT/main_clean.tex" <<'MAIN'
\documentclass[12pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{siunitx}
\usepackage[numbers,sort&compress]{natbib}
\usepackage[labelfont=bf,font=small]{caption}
\usepackage{authblk}
\usepackage{microtype}
\usepackage{hyperref}
\graphicspath{{figures/}}
\title{Biohybrid Cochlear Implants: Neural Interfaces, Regenerative Pathways, and Translational Benchmarks}
\author[1]{Akihiro J. Matsuoka}
\author[2]{[Coauthor 2]}
\author[3]{[Coauthor 3]}
\affil[1]{University of California San Diego}
\affil[2]{[Affiliation]}
\affil[3]{[Affiliation]}
\date{}
\hypersetup{colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black}
\begin{document}\maketitle
\begin{abstract}
[150–250 words: problem; accepted practice; what’s new in this synthesis; audience; 3–4 take-homes.]
\end{abstract}
\section*{Keywords}
cochlear implant; spiral ganglion neuron; biohybrid interface; conductive polymers; neurotrophin delivery; inner ear regeneration
% Body — expects files under manuscript/sections/
\input{sections/01_intro}
\input{sections/02_epidemiology_economic_burden}
\input{sections/03_cps_anatomy_routes}     % \label{sec:cps}
\input{sections/06_interfaces_materials}   % \label{sec:materials_stack}  (renamed from your 06_)
\input{sections/05_regen_evidence}
\input{sections/07_SAW}                    % \label{sec:saw}
\input{sections/08_translation_benchmarks}
\input{sections/09_roadmap_open_questions}
\section*{Acknowledgments}
[Funding, collaborators.]
\section*{Conflicts of Interest}
The authors declare no conflicts of interest.
\bibliographystyle{unsrtnat}
\bibliography{bib}
\end{document}
MAIN

# --- README ---
cat > JNER_Submission/README.md <<'R'
# JNER Submission Package
Build locally:
```bash
cd JNER_Submission/manuscript
latexmk -pdf -interaction=nonstopmode main_clean.tex

rsync -a "$SRC_SECTIONS_DIR"/ "$OUT_SECTIONS"/
cp "$SRC_BIB" "$OUT_ROOT/bib.bib"
if [ -d "$SRC_FIGS_DIR" ]; then
rsync -a "$SRC_FIGS_DIR"/ "$OUT_FIGS"/
fi

echo "Created JNER_Submission/. Build with: cd JNER_Submission/manuscript && latexmk -pdf main_clean.tex"
