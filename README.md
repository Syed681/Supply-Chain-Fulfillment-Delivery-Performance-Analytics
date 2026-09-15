# Supply Chain Fulfillment & Delivery Performance Analytics

## About the Project

I built this project to analyze supply chain order fulfillment, shipping performance, sales, and product trends using Python, SQL, and Power BI.

Since my background is in supply chain operations, I wanted to work on a project where I could apply analytics to a business area I already understand.

The main goal was to understand where delivery performance was weaker, how shipping modes and regions compared, and which products and customer segments contributed to sales.

The project follows this flow:

**Raw Data → Python → SQL → Power BI → Business Insights**


## Business Questions

The analysis focuses on questions such as:

- What is the overall sales and order performance?
- What percentage of order items breached the calculated shipping SLA?
- Which shipping modes have higher SLA breach rates?
- Which regions have higher fulfillment issues?
- How do actual shipping days compare with scheduled shipping days?
- Which products generate the highest sales?
- Which products have the highest order quantities?
- Which customer segments contribute the most sales?
- Which products have higher sales associated with SLA-breached items?


## Dataset

**Dataset:** DataCo Smart Supply Chain Dataset

The dataset contains supply chain order and product information covering customers, orders, products, categories, shipping modes, markets, regions, sales, quantities, and delivery-related fields.

The dataset contains:

- 180,519 order-item records
- 65,752 unique orders
- 20,652 unique customers
- 118 products
- 51 categories
- 164 order-country values

The dataset is analyzed at the **order-item / line-item level**.

The original raw dataset is not included in this repository because of its file size.


## Tools Used

### Python
- Python
- Pandas
- Data cleaning
- Data validation
- Feature engineering
- Basic exploratory analysis

### SQL / MySQL
- MySQL
- Filtering and aggregation
- GROUP BY
- CTEs
- Window functions
- LAG
- Monthly analysis
- Business KPI analysis

### Power BI
- Data modeling
- Date table
- Relationships
- DAX measures
- KPI cards
- Slicers
- Interactive charts
- Cross-filtering
- Conditional formatting


# Project Workflow

## 1. Data Exploration

I first loaded the raw dataset using Pandas and checked the basic structure of the data.

The exploration included:

- Number of rows and columns
- Missing values
- Duplicate records
- Unique IDs
- Data types
- Columns with only one unique value
- Duplicate/redundant columns


## 2. Data Cleaning

I cleaned the dataset using Pandas before loading it into MySQL.

The main cleaning steps included:

- Removing masked or unnecessary columns
- Removing duplicate/redundant fields
- Standardizing column names
- Converting date columns to datetime
- Checking missing values
- Checking duplicate records
- Creating new fulfillment-related fields

The cleaned dataset contains 180,519 records and 43 columns.


## 3. Feature Engineering

I created two fields to support the fulfillment analysis.

### Shipping Variance

Shipping variance compares the actual shipping duration with the scheduled shipping duration.

```text
Shipping Variance =
Actual Shipping Days - Scheduled Shipping Days
```

A positive value means the actual shipping duration was higher than the scheduled duration.


### SLA Breach Flag

I created a simple binary flag:

```text
SLA Breach Flag =
1 → Shipping Variance > 0
0 → Shipping Variance <= 0
```

This became the main calculated indicator used to analyze fulfillment performance.


# 4. SQL Analysis

After cleaning the data, I loaded it into MySQL and used SQL to perform the main business analysis.

The analysis includes:

- Overall KPIs
- Delivery status analysis
- Shipping mode performance
- Category performance
- Market performance
- Region performance
- Customer segment performance
- Monthly sales trends
- Month-over-month sales growth
- Top products
- Product sales contribution
- Region × shipping mode analysis
- SLA breach contribution
- Sales associated with SLA-breached items

The SQL files are available in:

`03_sql/`


# 5. Power BI Dashboard

I created a three-page Power BI report to present the analysis in an interactive way.


## Page 1 — Executive Overview

This page provides a high-level view of the business and fulfillment performance.

It includes:

- Total Sales
- Total Orders
- Total Quantity
- Average Order Value
- SLA Breach %
- Average Shipping Variance
- Monthly Sales Trend
- Sales by Category
- SLA Breach by Shipping Mode

Slicers are included for interactive analysis.


## Page 2 — Fulfillment Performance

This page focuses more specifically on delivery and fulfillment performance.

It includes:

- SLA Breach % by Region
- Actual vs Scheduled Shipping Days
- SLA Breach Item Volume by Region
- Region × Shipping Mode SLA performance

The purpose of this page is to help identify areas that may need further operational investigation.


## Page 3 — Product & Sales Performance

This page focuses on product and commercial performance.

It includes:

- Top 10 Products by Sales
- Top 10 Products by Quantity
- Sales by Customer Segment
- Top Products by SLA-Breached Sales

The page helps compare high-value products, high-volume products, and sales associated with fulfillment issues.


# Key Results

| KPI | Result |
|---|---:|
| Total Orders | 65,752 |
| Total Order Items | 180,519 |
| Total Customers | 20,652 |
| Total Products | 118 |
| Total Sales | ~$36.78M |
| Total Quantity | 384,079 |
| Average Order Value | ~$559.45 |
| Average Shipping Variance | 0.57 days |
| SLA Breach Rate | 57.28% |


# Key Findings

## 1. SLA Breaches

57.28% of the order items had a positive shipping variance and were classified as SLA breaches based on the rule used in this project.

This shows that delivery performance is an important area to investigate in the dataset.


## 2. Shipping Mode Performance

The observed SLA breach rates were:

- First Class — 100.00%
- Second Class — 79.73%
- Same Day — 47.83%
- Standard Class — 39.77%

The difference between shipping modes was one of the main patterns identified in the analysis.


## 3. Breach Rate vs Breach Volume

Looking only at the breach percentage does not tell the complete story.

Standard Class had the largest order-item volume and contributed approximately 41.44% of all SLA-breached items.

This is why I considered both:

- SLA breach percentage
- Number of breached order items

when looking at fulfillment performance.


## 4. Product Sales Concentration

The top three products contributed approximately 42.06% of total sales.

This shows that sales were not evenly distributed across all products.

High-sales products can therefore be useful products to monitor when looking at fulfillment performance.


## 5. Sales Associated with SLA Breaches

Approximately $21.03M of sales were associated with order items that breached the calculated shipping SLA.

This does **not** mean that $21.03M was lost because of delivery delays.

It only means that these sales were associated with order items that had a positive shipping variance.


# Data Validation

I validated the data before using it for the final analysis.

Some of the main checks included:

- 180,519 total records
- 180,519 unique order-item IDs
- 65,752 unique orders
- 20,652 unique customers
- 118 unique products
- No duplicate order-item IDs
- Date fields converted correctly
- Shipping variance calculated correctly
- SLA breach results checked between Python, MySQL, and Power BI

The main Power BI KPIs were also compared with the SQL results to make sure the numbers were consistent.


# Data Limitations

This dataset is at the order-item / line-item level, so the same order can appear across multiple rows.

There are also some limitations in the dataset.

It does not provide enough information to directly analyze:

- Inventory on hand
- Warehouse capacity
- Reorder points
- Detailed freight costs
- Returns or refunds
- Actual lost sales caused by delivery delays

Because of these limitations, I have focused on identifying patterns and areas for further investigation rather than making causal claims.


# What I Would Investigate Next

If this were connected to actual company data, I would investigate:

1. Why First Class and Second Class show higher breach rates.
2. Whether certain regions consistently perform worse for specific shipping modes.
3. Which high-volume areas should be prioritized based on breach volume.
4. Whether high-sales products also experience recurring fulfillment issues.
5. Whether these patterns continue in more recent operational data.
6. Whether additional factors such as carrier, warehouse, inventory availability, or transportation cost explain the observed differences.


# Project Structure

```text
Supply_Chain_Fulfillment_Analytics/
│
├── 01_raw_data/
│   └── README.md
│
├── 02_python_cleaning/
│   ├── 01_exploration.py
│   ├── 02_cleaning.py
│   └── README.md
│
├── 03_sql/
│   ├── 01_database.sql
│   └── 02_analysis.sql
│
├── 04_powerbi/
│   ├── Supply_Chain_Analytics.pbix
│   └── screenshots/
│       ├── executive_overview.png
│       ├── fulfillment_performance.png
│       └── product_sales_performance.png
│
├── 05_insights/
│   └── business_insights.md
│
├── README.md
```


# Skills Demonstrated

- Python
- Pandas
- Data Cleaning
- Data Validation
- Exploratory Data Analysis
- Feature Engineering
- SQL
- MySQL
- Aggregation
- CTEs
- Window Functions
- Time-Series Analysis
- DAX
- Power BI
- Data Modeling
- Dashboard Development
- Supply Chain Analytics
- Business Analysis
- Business Interpretation
