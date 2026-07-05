# 🛒 Olist E-Commerce Sales Analytics
### End-to-End Data Analytics Project using SQL, Python, Machine Learning & Power BI

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Python](https://img.shields.io/badge/Python-3.10-blue?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=flat&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/)

An end-to-end data analytics project on the **Olist Brazilian E-Commerce dataset** (99K+ orders, 96K+ customers) — covering SQL analysis, Python EDA & Machine Learning, and an interactive 6-page Power BI dashboard, built to solve real business problems: late deliveries, customer churn, revenue leakage, and customer segmentation.

---

## 📌 Project Overview

This project presents an end-to-end analysis of the **Olist Brazilian E-Commerce Dataset** using **PostgreSQL, Python, Machine Learning, and Power BI**.

The goal is to transform raw e-commerce data into actionable business insights by analyzing sales performance, customer behavior, seller performance, delivery efficiency, and payment trends — while also using predictive machine learning to flag late deliveries, segment customers, and understand what drives review scores.

This portfolio project demonstrates the complete analytics workflow — from data cleaning and SQL analysis to machine learning and interactive business dashboards.

---

## 🎯 Business Objectives

A real analytics team at Olist would be asked to answer questions like these:

1. Which customers drive the most revenue, and how do we retain them?
2. What predicts a late delivery, and can we flag at-risk orders early?
3. What drives customer review scores — and how much does delivery delay matter?
4. Which product categories generate the highest revenue?
5. Which sellers perform best, and where is revenue leaking?
6. Which payment methods do customers prefer?

---

## 🗂️ Repository Structure

```text
olist-ecommerce-sales-analysis/
│
├── Data/
│   ├── raw/                              # Raw CSVs (not tracked — see Dataset section)
│   └── clean/                            # Cleaned / processed data (e.g. olist_order_reviews_clean.csv)
│
├── notebook/
│   ├── 01_data_cleaning.ipynb            # Cleaning, deduplication, feature engineering
│   ├── 02_rfm_clustering.ipynb           # RFM + K-Means customer segmentation
│   ├── 03_machine_learning.ipynb         # Late delivery classification
│   └── 04_review_score_regression.ipynb  # Review score regression
│
├── SQL/
│   └── olist_ecommerce_analysis.sql      # Schema, 20+ queries, views, function, trigger
│
├── power_bi/
│   ├── Olist_Ecommerce_Sales_Dashboard.pbix
│   ├── executive summary.png
│   ├── product performance.png
│   ├── delivery and logistics.png
│   ├── customer segmentation.png
│   ├── seller performance.png
│   └── payment and financial.png
│
├── models/                               # Saved .pkl models (late_delivery_model_smote.pkl, review_score_model.pkl)
├── order_review_correction.py            # Standalone script: dedupes review records
├── requirements.txt
├── .gitignore
├── LICENSE
└── README.md
```

> **Note:** `Data/raw/`, `Data/clean/`, and `models/` are created when you run the
> notebooks/scripts locally — they're not pre-populated in the repo since the raw
> CSVs and trained model files are too large to track in Git.

---

## 📊 Dataset Information

**Dataset:** Olist Brazilian E-Commerce Public Dataset
**Source:** [Kaggle — Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains real transactional data collected from a Brazilian e-commerce marketplace between **2016 and 2018**.

> CSVs are not included in this repo due to size. Download them from the link above and place them in `Data/raw/`.

### Dataset Includes
- Customers
- Orders
- Order Items
- Payments
- Reviews
- Products
- Sellers
- Geolocation
- Product Category Translation

### Dataset Size
- **99K+ Orders**
- **96K+ Customers**
- **9 Relational Tables**

---

## 🔄 Project Workflow

```text
Raw Dataset
      │
      ▼
Data Cleaning & Feature Engineering
      │
      ▼
SQL Business Analysis (PostgreSQL)
      │
      ▼
Python EDA & Machine Learning
      │
      ▼
Power BI Dashboard
      │
      ▼
Business Insights & Recommendations
```

---

## 🚀 Project Highlights

✅ PostgreSQL Database Design (9-table relational schema)
✅ Advanced SQL Analysis (Window Functions, CTEs, Views, Triggers)
✅ Python Data Cleaning & EDA
✅ Statistical Testing (Chi-square)
✅ Machine Learning Models (Classification + Regression)
✅ Customer Segmentation (RFM + K-Means)
✅ Interactive 6-Page Power BI Dashboard
✅ Business KPI Analysis & Executive-Level Insights

---

## 🗄️ SQL Analysis (PostgreSQL)

The Olist dataset was imported into PostgreSQL and modeled using a normalized 9-table relational schema with full referential integrity. SQL was used to extract business insights, monitor KPIs, and answer real-world business questions with 20+ production-style queries.

### SQL Concepts Used
- `INNER JOIN`, `LEFT JOIN`
- `GROUP BY` & `HAVING`
- Aggregate Functions
- Common Table Expressions (CTEs)
- Window Functions (`LAG`, `RANK`, `NTILE`, `ROW_NUMBER`, running totals)
- `CASE WHEN`
- Views
- Indexes (with `EXPLAIN ANALYZE`)
- Stored Functions / Procedures
- Triggers

### Business Analysis Performed
- Monthly revenue growth (MoM, using `LAG`)
- Seller ranking by state (`RANK`) and running revenue totals
- Monthly cohort retention and top-3 categories per state (CTEs)
- Customer purchase behavior & RFM scoring
- Revenue leakage from cancelled-but-paid orders
- Delivery delay root-cause analysis by seller ↔ customer state pairs
- Product category & seller performance
- Payment method analysis

### Database Objects
- Stored function `fn_seller_report()`
- View `vw_daily_kpi`
- Trigger for order audit logging
- 4 performance indexes, validated with `EXPLAIN ANALYZE`

📄 Full SQL: [`SQL/olist_ecommerce_analysis.sql`](SQL/olist_ecommerce_analysis.sql)

---

## 🐍 Python Analysis

Python was used for data cleaning, exploratory data analysis (EDA), feature engineering, visualization, and machine learning model development.

### Data Cleaning
- Removed **814 duplicate `review_id` records** (kept the latest by timestamp) — see `order_review_correction.py` and `notebook/01_data_cleaning.ipynb`
- Handled missing values
- Corrected data types
- Built a master analytical dataset from the 9 raw tables

### Feature Engineering
- `delivery_delay_days`, `is_late_delivery`
- `order_hour`, `is_weekend` (time-based features)
- Customer age group
- RFM metrics (Recency, Frequency, Monetary)
- Payment features (installments, method)
- Log-transformed skewed monetary/frequency distributions before clustering

### Statistical Testing
- Chi-square test confirming that delivery delay **significantly affects** review scores

---

## 📈 Exploratory Data Analysis (EDA)

**Customer Analysis** — distribution, purchase frequency, revenue contribution, RFM distribution
**Sales Analysis** — monthly revenue trend, category-wise revenue, seller revenue, order status breakdown
**Delivery Analysis** — delivery time distribution, late delivery analysis, state-wise delivery performance
**Payment Analysis** — payment type distribution, installment analysis, revenue leakage analysis

---

## 🤖 Machine Learning

Three machine learning solutions were developed as part of this project.

### 1️⃣ Late Delivery Prediction (Classification)

**Objective:** Predict which orders will arrive late, to enable proactive logistics flagging.

**Challenge:** Severe class imbalance — only **6.3%** of orders are late. A naive
model that always predicts "on-time" already scores 93.7% accuracy while catching
zero late deliveries, so accuracy alone is a misleading metric here. The model was
evaluated on Precision, Recall, F1, and ROC-AUC instead.

**Workflow:** Preprocessing → baseline models → hyperparameter tuning (GridSearchCV)
→ class balancing (SMOTE) → decision-threshold tuning

**Results:**

| Model | Precision | Recall | F1 Score | ROC-AUC |
|---|---|---|---|---|
| Logistic Regression (baseline) | 0.00 | 0.000 | 0.000 | 0.655 |
| Random Forest (baseline) | 1.00 | 0.003 | 0.005 | 0.671 |
| Random Forest (GridSearch-tuned) | 0.83 | 0.087 | 0.158 | 0.730 |
| Random Forest + SMOTE | 0.138 | 0.247 | 0.177 | 0.654 |
| **Tuned RF + threshold = 0.35 (final)** | **0.644** | **0.164** | **0.261** | **0.730** |

**Key finding:** Both baseline models default to predicting "on-time" for every
order, since the standard 0.5 decision threshold is unsuitable for a 6.3% minority
class. Adjusting the decision threshold to 0.35 on the GridSearch-tuned Random
Forest produced the best precision–recall trade-off (F1 = 0.261), while SMOTE-based
rebalancing traded precision for higher recall (catching more true late orders at
the cost of more false alarms). `price`, `freight_value`, `product_weight_g`, and
`order_hour` were the strongest predictors of a late delivery.

**Business takeaway:** At F1 ≈ 0.26, this model is not yet reliable enough for fully
automated action, but at threshold 0.35 it flags late orders with **64% precision**
— usable today as a secondary risk signal to help logistics teams prioritize manual
review of high-risk orders, rather than as a standalone automated decision-maker.

### 2️⃣ Customer Segmentation (RFM + K-Means)

RFM-based segmentation into 4 customer groups using the elbow method (K = 4):

- **Champions**
- **At Risk**
- **Recent Customers**
- **Lost Customers**

**Key finding:** Champions (33.6% of customers) generate **61.5% of total revenue** — a clear Pareto concentration.

**Key finding:** The At Risk segment (3% of customers) has the **highest average spend** of any segment — a high-priority win-back target.

These segments were integrated into the Power BI dashboard for business analysis.

### 3️⃣ Review Score Prediction (Regression)

A regression model was developed to predict customer review scores.

- **Random Forest Regressor: R² = 0.172** (vs. 0.075 for Linear Regression)
- `delivery_delay_days` is by far the strongest predictor — confirming the SQL chi-square finding
- **Limitation:** R² of 0.172 means most of the variance in review scores is driven
  by factors not captured in this dataset (product quality, packaging condition,
  subjective customer expectations). This is expected — review scores are
  inherently subjective and can't be fully predicted from structured transactional
  data alone.

📄 Notebooks: [`notebook/`](notebook/)

---

## 🛠 Python Libraries Used

- Pandas
- NumPy
- Matplotlib / Seaborn
- Scikit-learn
- Imbalanced-learn (SMOTE)
- SHAP

---

## 📌 Key Python Deliverables

✅ Data Cleaning
✅ Feature Engineering
✅ Exploratory Data Analysis
✅ Statistical Testing
✅ Customer Segmentation
✅ Machine Learning Models
✅ Model Evaluation
✅ Business Recommendations

---

## 📊 Power BI Dashboard

An interactive **6-page Power BI dashboard** was developed to transform raw business data into actionable insights, featuring dynamic KPIs, DAX measures, slicers, and business insight panels.

### 1️⃣ Executive Summary
**KPIs:** Total Revenue · Total Orders · Total Customers · Average Order Value (AOV) · Average Review Score
**Visuals:** Revenue Trend · Order Status Distribution · Executive KPI Cards

### 2️⃣ Product Performance
**Visuals:** Revenue by Product Category · Category Revenue Treemap · Average Review Score by Category
**Focus:** Top-performing categories, customer rating analysis, revenue contribution

### 3️⃣ Delivery & Logistics
**KPIs:** Late Delivery Rate (**7.87%**) · On-Time Delivery Rate (**92.13%**) · Average Delivery Days (**12.50 days**) · Average Estimated Delivery Days
**Visuals:** Delivery Performance by State · Monthly Delivery Trend
**Focus:** Delivery performance, logistics efficiency, regional analysis

### 4️⃣ Customer Segmentation (RFM)
**KPIs:** Total Customers (**96K**) · Champions Customers (**31K**) · Champions Monetary Share (**61.47%**) · Customer Retention Rate (**70.89%**) · Customer Lifetime Value (**148.64**) · New Customer Revenue (**14.59M**) · Returning Customer Revenue (**867.41K**)
**Visuals:** Monetary Distribution by Segment · Customer Distribution by Segment · Customer RFM Distribution (Scatter) · Revenue by Segment
**Segments:** Champions · At Risk · Recent Customers · Lost Customers

### 5️⃣ Seller Performance
**KPIs:** Total Sellers (**3K**) · Seller Revenue (**13.59M**) · Top Seller Revenue Share (**13.15%**) · Average Seller Performance (**35.40**)
**Visuals:** Seller Revenue vs. Review Score (Scatter) · Top Sellers by Revenue · Seller Performance Table (Seller Revenue, Seller Review Score, Seller Performance Index)
**Focus:** Seller ranking, revenue distribution, seller quality analysis

### 6️⃣ Payment & Financial Insights
**KPIs:** Total Revenue (**16.01M**) · Average Installments per Order (**2.85**) · Revenue Leakage Rate (**1.68%**) · Revenue Leakage (**269.74K**)
**Visuals:** Average Installments by Payment Type · Revenue by Payment Type · Monthly Revenue Trend · Payment Method Distribution
**Focus:** Customer payment preference, financial performance, revenue leakage analysis

---

## 📈 DAX Measures

**Revenue:** Total Revenue · Category Revenue · Previous Month Revenue · Previous Year Revenue · Running Total Revenue · MoM Revenue Growth % · YoY Revenue Growth %

**Customer:** Total Customers · Customer Retention Rate % · Customer Lifetime Value (CLV) · New Customer Revenue · Returning Customer Revenue · Repeat Customer Rate % · Champions Monetary %

**Delivery:** Late Delivery Rate % · On-Time Delivery Rate % · Average Delivery Days · Average Estimated Delivery Days

**Seller:** Total Sellers · Seller Revenue · Revenue by Segment · Seller Performance Index · Average Seller Performance · Top Seller Revenue Share % · Top 10 Seller Revenue

**Financial:** Average Installments per Order · Revenue Leakage · Revenue Leakage % · Average Order Value

**Product:** Category Review Rank

---

## 📌 Dashboard Features

- Interactive Slicers
- Dynamic KPI Cards
- Time Intelligence Analysis (MoM / YoY DAX measures)
- Custom DAX Measures
- Business Insight Panels on every page
- Consistent Visual Theme Across Pages

---

## 📷 Dashboard Preview

### 1️⃣ Executive Summary
![Executive Summary](power_bi/executive%20summary.png)

### 2️⃣ Product Performance
![Product Performance](power_bi/product%20performance.png)

### 3️⃣ Delivery & Logistics
![Delivery & Logistics](power_bi/delivery%20and%20logistics.png)

### 4️⃣ Customer Segmentation
![Customer Segmentation](power_bi/customer%20segmentation.png)

### 5️⃣ Seller Performance
![Seller Performance](power_bi/seller%20performance.png)

### 6️⃣ Payment & Financial Insights
![Payment & Financial Insights](power_bi/payment%20and%20financial.png)

---

## 💡 Key Business Insights

- 📈 Revenue grew consistently from 2016–2018, with clear seasonal peaks
- 🏆 **Champions generate 61.47% of total revenue** (31K of 96K customers) — retention budget should concentrate here
- 👥 **Customer Retention Rate stands at 70.89%**, with New Customer Revenue (14.59M) far outweighing Returning Customer Revenue (867.41K)
- 🚚 **92.13% on-time delivery rate** (7.87% late), with an average delivery time of 12.50 days; late deliveries are a key driver of low review scores
- 🛍️ **Health & Beauty** is the highest revenue-generating product category (1.26M), followed by Watches & Gifts and Bed, Bath & Table
- 🏬 **Revenue is highly concentrated among top sellers** — the top sellers alone account for 13.15% of total seller revenue (3K sellers, 13.59M total)
- 💳 Credit card is the dominant payment method, and most customers pay in 2–3 installments
- 💰 Revenue leakage from cancelled/unavailable orders is minimal — just 1.68% (269.74K) of total revenue (16.01M)
- ⭐ Delivery delay is the strongest predictor of review score, confirmed by both SQL chi-square testing and the regression model
- 🎯 The late-delivery model works best as a risk-prioritization signal (64% precision at threshold 0.35), not a fully automated flag
- 📊 Customer segmentation highlights clear opportunities for targeted retention and win-back marketing

---

## 💼 Skills Demonstrated

**SQL:** Advanced Joins · CTEs · Window Functions · Views · Stored Procedures/Functions · Triggers · Business KPI Analysis

**Python:** Data Cleaning · Exploratory Data Analysis · Feature Engineering · Machine Learning · Handling Class Imbalance (SMOTE, threshold tuning) · Statistical Testing · Data Visualization

**Power BI:** Interactive Dashboards · DAX Measures · KPI Reporting · Business Storytelling

**Business Analytics:** Revenue Analysis · Customer Analytics · Seller Analytics · Delivery Analytics · Financial Analytics

---

## 🛠 Tech Stack

| Category | Technologies |
|---|---|
| **Database** | PostgreSQL 14+ |
| **Programming** | Python 3.10, SQL |
| **Libraries** | Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, Imbalanced-learn (SMOTE), SHAP |
| **Visualization** | Power BI Desktop |
| **IDE** | VS Code, Jupyter Notebook |

---

## 🚀 How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/Radha0401/olist-ecommerce-sales-analysis.git
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Download the Dataset
Download the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle and place the CSV files inside the `Data/raw/` folder.

### 4. Execute the Project
- Run the SQL scripts in PostgreSQL (`SQL/olist_ecommerce_analysis.sql`)
- Run the notebooks in sequence: `01 → 02 → 03 → 04`
- Open the dashboard: `power_bi/Olist_Ecommerce_Sales_Dashboard.pbix` in Power BI Desktop

---

## 🎯 Future Improvements

- Deploy the late-delivery model as a live API (FastAPI + Docker)
- Improve recall further with cost-sensitive learning or ensemble stacking
- Real-time dashboard integration
- Time-series revenue forecasting (Prophet/ARIMA)
- Customer churn prediction
- Recommendation engine using order co-occurrence
- Automated reporting pipeline

---

## 📬 Contact

**Radha Yadav**
Data Analytics | NIT Agartala

📧 Email: yradhaec04@gmail.com
💼 LinkedIn: [linkedin.com/in/radha-yadav05](https://linkedin.com/in/radha-yadav05)
💻 GitHub: [github.com/Radha0401](https://github.com/Radha0401)

---