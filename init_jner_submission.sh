#!/usr/bin/env bash
set -euo pipefail

# Create directories
mkdir -p JNER_Submission/{manuscript/sections,cover_letter,supp,scripts,manuscript/figures}

# ---------------------------
# Cover letter (LaTeX)
# ---------------------------
cat > JNER_Submission/cover_letter/cover_letter_JNER.tex <<'EOF'
\documentclass[11pt]{letter}
\usepackage{geometry}
\geometry{a4paper, margin=1in}
\begin{document}
\begin{letter}{Editorial Office \\ Journal of NeuroEngineering and Rehabilitation}
\opening{Dear Editors,}
On behalf of my coauthors, I am pleased to submit our manuscript entitled
\textbf{“Biohybrid Cochlear Implants: Neural Interfaces, Regenerative Pathways, and Translational Benchmarks”}
for consideration as a \emph{Topical Review} in the \emph{Journal of NeuroEngineering and Rehabilitation}.
This review synthesizes current knowledge at the intersection of auditory neuroscience, regenerative medicine, and neural interface engineering. Specifically, we highlight:
\begin{itemize}
    \item the persistent electrode–neuron gap and consequences for channel selectivity;
    \item the microanatomy of the Canaliculi Perforantes of Schuknecht (CPS) as natural conduits;
    \item biomaterial interfaces (conductive polymers, hydrogels, zwitterionic coatings) for low-impedance, pro-regenerative coupling;
    \item neurotrophin and cell-based strategies for neurite guidance and survival;
    \item enabling acoustofluidics (SAW) and sensing concepts.
\end{itemize}
To our knowledge, this is the first comprehensive review integrating these anatomical, biological, and engineering perspectives toward a \emph{living} cochlear implant. The work targets neural engineers, auditory scientists, and rehabilitation clinicians.
We confirm the work is original, not under consideration elsewhere, and approved by all authors. We have no conflicts of interest to declare.
We believe the review fits squarely within JNER’s aims and scope, bridging neuroscience, rehabilitation, and engineering. Thank you for your consideration.
\closing{Sincerely,}
\vspace{1em}
Akihiro J. Matsuoka, MD, PhD \\
University of California San Diego \\
(On behalf of all coauthors)
\end{letter}
\end{document}
EOF

# ---------------------------
# Clean main (journal-ready)
# ---------------------------
cat > JNER_Submission/manuscript/main_clean.tex <<'EOF'
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
[150–250 words: problem; accepted practice; what’s new in this synthesis; audience; 3–4 take‑homes.]
\end{abstract}
\section*{Keywords}
cochlear implant; spiral ganglion neuron; biohybrid interface; conductive polymers; neurotrophin delivery; inner ear regeneration
% Body — adjust paths/titles to match your repo if needed
\input{sections/01_intro}            % scope & motivation
\input{sections/02_gap}              % electrode–neuron gap
\input{sections/03_cps}              % CPS microanatomy (\label{sec:cps})
\input{sections/04_biomaterials}     % materials/delivery stack (\label{sec:materials_stack})
\input{sections/05_surface_mods}     % surface mods (\label{sec:surface_mods})
\input{sections/06_saw}              % SAW acoustofluidics (\label{sec:saw})
\input{sections/07_outlook}          % outlook/benchmarks
\section*{Acknowledgments}
[Funding, collaborators.]
\section*{Conflicts of Interest}
The authors declare no conflicts of interest.
\bibliographystyle{unsrtnat}
\bibliography{bib}
\end{document}
EOF

# ---------------------------
# README
# ---------------------------
cat > JNER_Submission/README.md <<'EOF'
# JNER Submission Package
This folder contains a clean, journal-ready build for **Journal of NeuroEngineering and Rehabilitation**.
## Build locally
```bash
cd JNER_Submission/manuscript
latexmk -pdf -interaction=nonstopmode main_clean.tex
