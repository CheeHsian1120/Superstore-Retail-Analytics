# Superstore Global Retail Analytics, Supply Chain Optimization & Macroeconomic Data Story

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![R](https://img.shields.io/badge/R_Programming-276DC3?style=for-the-badge&logo=r&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)

This repository showcases an advanced, end-to-end retail intelligence and supply chain engineering ecosystem. It combines a comparative cross-ecosystem analytical pipeline (**R & Python**) with an interactive **R Shiny Dashboard** that integrates external macroeconomic datasets to deliver an executive-level corporate data story.

---

## 🚀 Project Overview
The core objective of this project is to diagnose operational inefficiencies, analyze market consistency, audit discount behaviors, and optimize supply chain pipelines for global retail operations. 

Going beyond traditional internal metrics, this project features a **Macroeconomic Cross-Validation Framework**. By blending internal transactional records with external macroeconomic indicators (2011–2014), the analysis dynamically disproves standard operational "excuses" (e.g., shipping crises, economic downturns) to expose critical, self-inflicted revenue vulnerabilities and margin erosion.

---

## 🛠️ Tech Stack & Architecture
* **R Infrastructure (`r_pipeline/`):** `readxl`, `dplyr`, `shiny`, `plotly`, `ggplot2`, `lubridate`, `scales`, `shinyscreenshot` (Data transformation, time-series merging, responsive visualization, and UI engineering).
* **Python Infrastructure (`python_pipeline/`):** `pandas`, `numpy`, `matplotlib`, `seaborn` (Algorithmic profiling, unsupervised outlier detection, and loop optimization models).

---

## 📊 Key Business Problems Solved

### 1. The Macroeconomic Data Story & "The Discount Trap"
* **The Dilemma:** Management historically blamed severe, non-seasonal technology sales volatility on macroeconomic anxiety or external logistics shocks.
* **The Data Story:** Merged internal metrics with Federal Reserve Economic Data (FRED) series:
  * **Advance Retail Sales [RSEAS]:** Proved the national electronics industry grew stably, framing the Superstore's bi-annual whiplash as a purely internal operational vulnerability.
  * **Consumer Sentiment Index [UMCSENT]:** Revealed a near-zero correlation with internal sales, proving that artificial internal promotional pulses completely overrode general household confidence.
  * **Freight Transportation Index [TSIFRGHT]:** Disproved any external shipping crisis. The steady growth of the national logistics network proved that internal shipping bursts were upstream logistical strains induced by unforecasted internal promotional surges (**The Bullwhip Effect**).
* **The Verdict:** Dual-axis bar and line plots expose that whenever average discount margins spike to force top-line volume, net profit plummets below the zero baseline into negative territory. The business was trapped in a destructive cycle of **Panic-Discounting**.

### 2. Interactive BI Dashboard Engineering (R Shiny)
* **Reactive Architecture:** Leveraged R Shiny's reactive pipelines (`reactive()`, `renderPlotly()`) to ensure fluid, zero-latency dashboard updates whenever users modify the timeline filters.
* **Advanced Visualizations:** Cleanly overlaid distinct data frequencies, tracking volatile transactional revenue right alongside smoothly trending macroeconomic indicators.
* **Enterprise Features:** Programmed an asynchronous screenshot utility using `shinyscreenshot` to allow corporate executives to export instantly generated dashboard states as images with a single click.

### 3. Discount Compliance & Risk Detection (Python Algorithm)
* Engineered an unsupervised outlier detection algorithm leveraging sub-category median discounts (applying a strict 1.5x threshold) to flag high-risk, margin-eroding transaction segments and unauthorized markdowns.

### 4. Order Optimization Strategy (Python Performance Loop)
* Developed cumulative profit tracking loops demonstrating how algorithmic prioritization of high-value orders achieves identical financial targets while reducing total processing volume by over 90%.

### 5. Supply Chain Bottleneck Analysis (Cross-Tabulation Auditing)
* Analyzed explicit shipping priorities against actual transit modes to flag operational anomalies where lower-urgency orders unexpectedly consumed premium shipping lanes ahead of critical items.

### 6. Market Consistency Analysis (R Analytics)
* Evaluated long-term regional market consistency by isolating and filtering out loss-making micro-segments, ranking geo-markets strictly by sustainable baseline sales volume.

### 7. Logistics & Profitability Efficiency (R Pipeline)
* Isolated transactions where localized freight costs exceeded baseline country averages to compute the exact profit ratio per shipping unit, exposing hidden distribution leakages.

---

## 📁 Repository Structure

```text
├── data/
│   ├── superstore.xlsx                  # Underlying retail transactional dataset
|   ├── RSEAS.xlsx                       # Macroeconomic metric dataset
|   ├── TSIFRGHT.xlsx
|   ├── UMCSENT.xlsx
|   └── clean_data.xlsx
├── r_pipeline/
│   ├── analysis_r.Rmd                   # R Markdown analytical script
│   └── analysis_r.html                  # Exported EDA report
├── python_pipeline/
│   ├── analytics_python.ipynb           # Notebook with outlier algorithms & tracking loops
│   └── analytics_python.html            # Exported Python report
├── docs/
│   ├── Superstore_Data_Story_Report.pdf # Comprehensive 11-page macroeconomic data story report
|   └── app.R                            # Full-scale interactive R Shiny Dashboard code
└── README.md                            # Project documentation
```

## 👨‍💻 Author
**Tay Chee Hsian** 
