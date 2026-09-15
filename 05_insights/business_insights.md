# Business Insights

## Project Overview

This project analyzes supply chain fulfillment, delivery performance, sales, products, and customer segments using the DataCo Smart Supply Chain dataset.

The analysis was performed using Python for data cleaning and feature engineering, MySQL for business analysis, and Power BI for interactive reporting.

The main focus was to understand shipping performance and identify patterns that could help prioritize operational investigation.

---

## 1. Overall Business Performance

The dataset contains:

- **65,752 unique orders**
- **180,519 order items**
- **20,652 customers**
- **118 products**
- **$36.78M total sales**
- **384,079 units**
- **$559.45 average order value**

The analysis was performed at the order-item / line-item level.

---

## 2. Shipping SLA Performance

A shipping variance field was created using:

```text
Shipping Variance =
Actual Shipping Days - Scheduled Shipping Days
```

An order item was classified as an SLA breach when:

```text
Shipping Variance > 0
```

Based on this definition:

- **103,400 order items** were classified as SLA breaches.
- **57.28%** of order items had a positive shipping variance.
- Average shipping variance was approximately **0.57 days**.

This indicates that shipping performance is an important area for further investigation within the dataset.

---

## 3. Shipping Mode Performance

Shipping performance varied significantly by shipping mode.

| Shipping Mode | Order Items | SLA Breach % |
|---|---:|---:|
| First Class | 27,814 | 100.00% |
| Second Class | 35,216 | 79.73% |
| Same Day | 9,737 | 47.83% |
| Standard Class | 107,752 | 39.77% |

First Class and Second Class showed the highest breach percentages.

However, breach percentage alone should not be used to prioritize operational action because shipping modes have different order volumes.

---

## 4. Breach Rate vs Breach Volume

Standard Class had the largest order-item volume and contributed approximately **41.44% of all SLA-breached order items**.

This is an important distinction.

A shipping mode can have:

- A high breach percentage but lower total volume
- A lower breach percentage but much higher breach volume

Therefore, both **breach rate and breach volume** should be considered when prioritizing operational investigation.

---

## 5. Product Sales Concentration

Sales were concentrated among a relatively small number of products.

The top three products contributed approximately **42.06% of total sales**.

The top five products contributed approximately **60.59% of total sales**.

This suggests that a relatively small group of products contributes a large share of overall sales.

From an operational perspective, these high-sales products may be useful candidates for closer monitoring of fulfillment performance.

---

## 6. Sales Associated with SLA Breaches

Approximately **$21.03M of sales** were associated with order items classified as SLA breaches.

This should not be interpreted as lost revenue or financial loss caused by delivery delays.

It simply means that the order items associated with approximately $21.03M in sales had a positive shipping variance.

Additional business data would be required to determine whether delivery performance actually affected revenue, customer retention, cancellations, or profitability.

---

## 7. Regional Fulfillment Patterns

The Power BI analysis compares SLA breach performance across regions and shipping modes.

The purpose of this analysis is to identify combinations where fulfillment performance appears weaker.

A region with a high breach percentage may require further investigation, but the dataset does not provide enough information to determine the exact operational cause.

Possible factors that would need to be investigated using additional company data include:

- Carrier performance
- Warehouse processing time
- Inventory availability
- Transportation routes
- Order volume
- Shipping mode selection
- Geographic distance

---

## 8. Customer Segment Performance

Customer segments were compared based on sales contribution.

This helps identify which customer groups contribute more to overall sales and provides another dimension for analyzing fulfillment performance.

However, customer segment differences should not automatically be interpreted as operational problems.

Further analysis would be required to understand whether certain segments experience different service levels, shipping patterns, or customer outcomes.

---

## 9. Key Business Takeaways

### Takeaway 1 — Delivery performance needs attention

More than half of the order items were classified as SLA breaches using the shipping variance rule.

This makes fulfillment performance one of the most important areas identified in the analysis.

### Takeaway 2 — Shipping modes behave differently

First Class and Second Class had substantially higher SLA breach percentages than Standard Class and Same Day.

This pattern should be investigated further using carrier, route, and operational data.

### Takeaway 3 — Volume matters alongside percentage

Standard Class had the largest order-item volume and therefore contributed the largest share of total SLA-breached items.

Prioritization should consider both the percentage of breaches and the number of affected order items.

### Takeaway 4 — Sales are concentrated

A small number of products contribute a large share of total sales.

High-value products may therefore deserve additional attention when evaluating fulfillment performance.

### Takeaway 5 — More data is required for root-cause analysis

The dataset can identify patterns and relationships, but it does not contain enough information to establish the operational cause of delivery issues.

---

## 10. Recommended Areas for Further Investigation

If this analysis were performed using real company operational data, I would investigate:

1. Why First Class and Second Class have higher breach rates.
2. Whether certain regions consistently perform worse for specific shipping modes.
3. Which regions contribute the highest number of breached order items.
4. Whether high-sales products experience recurring fulfillment issues.
5. Whether delivery performance varies by carrier.
6. Whether warehouse processing time contributes to delays.
7. Whether inventory availability affects fulfillment performance.
8. Whether delivery issues are associated with customer cancellations or other negative outcomes.
9. Whether these patterns remain consistent in more recent operational data.

---

## 11. Data Limitations

This analysis has several limitations.

The dataset does not provide sufficient information to directly analyze:

- Inventory on hand
- Warehouse capacity
- Reorder points
- Detailed freight costs
- Carrier-level performance
- Returns and refunds
- Customer retention
- Actual lost sales caused by delivery delays

Because of these limitations, the findings should be treated as **observed patterns and areas for further investigation**, rather than confirmed root causes.

---

## Conclusion

The analysis shows that fulfillment performance varies across shipping modes, regions, and products.

The overall SLA breach rate of **57.28%** highlights delivery performance as an important area for further investigation.

At the same time, sales concentration and breach volume provide useful context for deciding where operational attention could be prioritized.

The project demonstrates how supply chain data can be cleaned with Python, analyzed using SQL, and converted into business-focused insights through Power BI.
```
