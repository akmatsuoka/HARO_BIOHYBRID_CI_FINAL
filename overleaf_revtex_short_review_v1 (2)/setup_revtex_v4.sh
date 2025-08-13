#!/usr/bin/env bash
set -euo pipefail

# Ensure you are in your repo root:
#   git clone git@github.com:akmatsuoka/HARO_BIOHYBRID_CI_FINAL.git
#   cd HARO_BIOHYBRID_CI_FINAL
# then run: bash setup_revtex_v4.sh

# 0) Make folders
mkdir -p sections figures Figure

# 1) preamble.tex
cat > preamble.tex <<'EOF'
\usepackage{graphicx}
\usepackage{amsmath,amssymb}
\usepackage{siunitx}
\usepackage{microtype}
\usepackage{xspace}
\usepackage[usenames,dvipsnames]{xcolor}
\usepackage[colorlinks=true,allcolors=blue]{hyperref}

% Abbreviations
\newcommand{\OSL}{osseous spiral lamina\xspace}
\newcommand{\CPS}{canaliculi perforantes of Schuknecht\xspace}
\newcommand{\ST}{scala tympani\xspace}
\newcommand{\SGN}{spiral ganglion neuron\xspace}
\newcommand{\SGNs}{spiral ganglion neurons\xspace}

% Figures path
\graphicspath{{figures/}}
EOF

# 2) main.tex
cat > main.tex <<'EOF'
\documentclass[preprint,aps,pra,floatfix]{revtex4-2}
\input{preamble}
\begin{document}
\title{Toward Living Cochlear Implants: Using Canaliculi Perforantes to Guide Regeneration}

% Authors (temporary: grouped affiliation until individual mapping is provided)
\author{Akihiro J. Matsuoka}\author{Andrew Carpino}\author{Jae Joon Kim}\author{Audrey Meador}\author{Beatriz Nicolau}\author{Gabriela Fortuno}\author{Hudson Liu}\author{Kiersten Russ}\author{Huimin Zhu}\author{Tifany Nguyen}\author{James Friend}
\affiliation{University of California San Diego; Georgetown University School of Medicine; University of California Los Angeles}

\date{\today}
\begin{abstract}
Cochlear implants (CIs) restore hearing by directly stimulating auditory neurons, yet a persistent electrode--neuron gap constrains spatial selectivity and the fidelity of complex listening. This Topical Review outlines a biohybrid approach that leverages the \CPS\ to guide neurites toward recording/stimulation sites while enabling localized therapy.
\end{abstract}
\maketitle

\input{sections/01_intro.tex}
\input{sections/02_epidemiology_economic_burden.tex}
\input{sections/03_cps_anatomy_routes.tex}
\input{sections/04_regen_evidence.tex}
\input{sections/05_interfaces_materials.tex}
\input{sections/06_translation_benchmarks.tex}
\input{sections/07_roadmap_open_questions.tex}

\bibliography{bib}
\end{document}
EOF

# 3) sections
cat > sections/01_intro.tex <<'EOF'
\section*{1. Introduction}
This review proposes a biohybrid CI strategy that cooperates with tissue to reduce the electrode--neuron gap via \CPS-accessible routes and localized therapy, then evaluates anatomy, regenerative evidence, and translational constraints in a seven-chapter structure.
EOF

cat > sections/02_epidemiology_economic_burden.tex <<'EOF'
\section*{2. Epidemiology and Economic Burden of Hearing Loss}
Hearing loss is a major public health concern, with an estimated 13--15\% of Americans affected to some degree. Approximately one in eight individuals (13\%, or about 30 million people) aged 12 years and older has measurable hearing loss in both ears, while 15\% of U.S. adults (37.5 million) report at least some trouble hearing \cite{nidcd2021, cdc2010, cdc2021, wilson2014}. These figures surpass the prevalence of several other common health conditions, such as diabetes or cancer, underscoring the substantial impact of hearing impairment on public health resources and quality of life.

Beyond the societal costs of hearing loss in reduced productivity and additional learning resources required to teach young people with hearing loss \cite{SocietyCosts2000}, both direct costs (medical consultations; hearing aids, \$1,000--\$4,000 per pair; cochlear implants, \$30,000--\$100,000 per patient; audiologic services; speech-language therapy; device maintenance) and indirect costs (lost productivity—adults with hearing loss have 1.98--fold higher odds of unemployment; annual income losses of up to \$30,000 per person, amounting to \$176 billion annually) impose a substantial burden at the individual and population levels \cite{SocietyCosts2000, Kim2020, Colburn2019, WHO2025}. McDaid et al. (2021) found the global annual economic cost of hearing loss exceeded \$981 billion in 2020, with 47\% of these costs associated with quality-of-life losses and 57\% incurred outside high-income countries \cite{McDaid2021}. The World Health Organization estimates that scaling ear and hearing care interventions to 90\% coverage over the next ten years requires an additional investment of \$238.8 billion, yielding over \$2 trillion in productivity gains by 2030 \cite{Tordrup2022}.  From the individual patient perspective, lifetime healthcare costs for someone born with severe to profound hearing loss are estimated at \$489,274, but providing a cochlear implant before 18 months of age reduces this to \$390,931 (95 \% CI \$311,976--\$471,475), yielding net lifetime savings of \$98,343 \cite{Cejas2024}.

In 2023, the global cochlear implant market was valued at \$2.42 billion in 2023 and is expected to grow to \$6.63 billion by 2034. This surge of value reflects an annual growth rate of 9.02\% expected from 2024 to 2034 \cite{globenewswire2025cochlear}. This increase in hearing loss is driven by factors such as genetics, noise exposure, and aging, where 25\% of adults older than 60 years are affected by disabling hearing loss and over 1 billion young adults are at risk of permanent hearing loss \cite{WHO2025}. Cochlear implants pose many benefits to hearing restoration, but there is still a high barrier, as a cochlear implant procedure can cost \$50,000 to \$100,000. Key companies within the cochlear implant field include Cochlear Limited (Australia), Advanced Bionics (Sonova Holding AG, Switzerland), Zhejiang Nurotron Biotechnology Co., Ltd. (Hangzhou, China), and MED-EL Medical Electronics (Innsbruck, Austria).  There are high barriers to entry into the market due to FDA regulations regarding novel medical devices and high research and development costs. Opportunities for new cochlear implants arise with innovative technology.
EOF

# 4) CPS section: copy your file and strip wrappers safely with awk
#    Put your CPS TeX at: ~/Downloads/anatomical_considerations.tex
CPS_SRC="$HOME/Downloads/anatomical_considerations.tex"
CPS_DST="sections/03_cps_anatomy_routes.tex"

if [[ -f "$CPS_SRC" ]]; then
  # Remove \documentclass ... \begin{document} and trailing \end{document}
  # Then prepend our standardized section title if the file has no \section at top
  awk '
    BEGIN{skip=0}
    /\\documentclass/ {skip=1}
    /\\begin{document}/ {skip=0; next}
    /\\end{document}/ {exit}
    skip==0 {print}
  ' "$CPS_SRC" > "$CPS_DST.tmp"

  # If no \section line near the top, add our title
  if ! grep -q '^\\section' "$CPS_DST.tmp"; then
    printf "\\section*{3. Canaliculi perforantes of Schuknecht (CPS): Anatomy, Patency, and Routes}\n\n" > "$CPS_DST"
    cat "$CPS_DST.tmp" >> "$CPS_DST"
  else
    mv "$CPS_DST.tmp" "$CPS_DST"
  fi
  rm -f "$CPS_DST.tmp"
else
  # Fallback placeholder if CPS file not found
  cat > "$CPS_DST" <<'EOF'
\section*{3. Canaliculi perforantes of Schuknecht (CPS): Anatomy, Patency, and Routes}
% Paste your CPS chapter content here if automatic import failed.
EOF
fi

# 5) Remaining section placeholders
cat > sections/04_regen_evidence.tex <<'EOF'
\section*{4. Regenerative evidence for bridging the gap}
% To be drafted.
EOF
cat > sections/05_interfaces_materials.tex <<'EOF'
\section*{5. Interfaces and materials for biohybrid CIs}
% To be drafted.
EOF
cat > sections/06_translation_benchmarks.tex <<'EOF'
\section*{6. Translational benchmarks and constraints}
% To be drafted.
EOF
cat > sections/07_roadmap_open_questions.tex <<'EOF'
\section*{7. Roadmap and open questions}
% To be drafted.
EOF

# 6) Minimal bib so it compiles (replace with your real bib later)
cat > bib.bib <<'EOF'
@misc{placeholder, title={Placeholder}, author={A. Author}, year={2024}}
EOF

echo "✅ Files written. Next run: git add -A && git commit -m 'Integrate REVTeX v4...' && git push -u origin integrate-revtex-v4"
