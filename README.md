# Superstore Global Retail Analytics & Supply Chain Optimization

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![R](https://img.shields.io/badge/R_Programming-276DC3?style=for-the-badge&logo=r&logoColor=white)

This repository showcases a comprehensive retail and supply chain data analysis of the Global Superstore dataset. The project demonstrates advanced data manipulation, financial analysis, and optimization techniques implemented in both **R** and **Python**.

## 🚀 Project Overview
The goal of this project is to analyze global retail operations to identify financial inefficiencies, evaluate market consistency, detect suspicious discount behaviors, and uncover supply chain bottlenecks. 

By leveraging both R and Python, this repository serves as a comparative demonstration of data science workflows using different ecosystems.

## 🛠️ Tech Stack & Tools
* **R Pipeline:** `readxl`, `dplyr` (Data cleaning, window functions, and multi-dataset joining)
* **Python Pipeline:** `pandas`, `numpy`, `matplotlib`, `seaborn` (Data manipulation, profiling, and visualization)

## 📊 Key Business Problems Solved
1. **Logistics & Profitability Efficiency:** Isolated transactions where shipping costs exceeded country averages to calculate the exact profit ratio per shipping unit.
2. **Market Consistency Analysis:** Identified the most stable regional markets by filtering out loss-making years and ranking them by sales volume.
3. **Discount Compliance & Risk Detection:** Created an outlier detection algorithm using sub-category median discounts (1.5x threshold) to flag high-risk, loss-making segments.
4. **Order Optimization Strategy:** Developed cumulative profit tracking loops demonstrating how prioritizing high-value orders reduces processing volume by over 90% while hitting financial targets.
5. **Supply Chain Bottleneck Analysis:** Analyzed shipping priorities against shipping modes to flag operational anomalies where lower-urgency orders unexpectedly shipped faster than critical ones.

## 📁 Repository Structure

```text
├── superstore.xlsx            # Underlying retail dataset
├── analysis_r.Rmd             # R Markdown analytical script
├── analysis_r.html            # Exported R analysis report
├── analytics_python.ipynb     # Jupyter Notebook with pandas & seaborn visualizations
├── analytics_python.html      # Exported analysis report
└── README.md                  # Project documentation
```

## 👨‍💻 Author
**Tay Chee Hsian** 
