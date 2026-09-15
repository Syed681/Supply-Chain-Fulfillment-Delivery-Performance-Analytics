# Supply Chain Fulfillment & Delivery Performance Analytics
## SQL Results & Business Insights

---

## 1. Business Problem

E-commerce companies process a large number of orders across different products, regions, customers, and shipping methods.

One important part of supply-chain performance is making sure shipments are completed within the scheduled shipping time.

The main question for this project was:

> **Are shipments being completed within their scheduled shipping timelines?**

If shipments are taking longer than scheduled, we want to understand where this is happening and whether the problem is more common with certain shipping modes, regions, products, or customer segments.

The goal of this project is to use data to identify these patterns and provide areas for further investigation.

---

## 2. Why I Chose This Project

I chose this project because it connects data analytics with supply-chain operations.

The project uses areas that are familiar from supply-chain work, such as:

- Order processing
- Shipment tracking
- Scheduled vs actual shipping time
- SLA/TAT monitoring
- Shipping modes
- Regional performance
- Product performance
- KPI reporting

It also gives me an opportunity to demonstrate the use of:

- **Python** for data exploration and cleaning
- **SQL** for data analysis
- **Power BI** for reporting and visualization

Instead of creating a general sales dashboard, I wanted to investigate an operational supply-chain problem using data.

---

## 3. What I Wanted to Find

Before starting the SQL analysis, I defined the main questions I wanted to answer:

1. What is the overall SLA performance?
2. How many shipments are exceeding their scheduled shipping time?
3. Which shipping modes have the highest breach rates?
4. Which shipping modes contribute the largest number of breached shipments?
5. Are some regions performing better or worse than others?
6. Do customer segments show meaningful differences?
7. Which products generate the most sales and quantity?
8. Are high-value products also exposed to SLA breaches?
9. How do sales and fulfillment performance change over time?
10. What areas should operations investigate further?

---

## 4. How SLA Performance Was Measured

The dataset contains two important fields:

- `days_for_shipping_real`
- `days_for_shipment_scheduled`

I created a new metric:

```text
Shipping Variance
=
Actual Shipping Days
-
Scheduled Shipping Days
```

For example:

| Variance | Meaning |
|---:|---|
| -1 | Shipped 1 day earlier |
| 0 | Shipped on schedule |
| +1 | 1 day later |
| +2 | 2 days later |

I then created an SLA breach flag:

```text
SLA Breach = 1
when Shipping Variance > 0
```

Otherwise:

```text
SLA Breach = 0
```

This calculated SLA measure is separate from the dataset's existing `late_delivery_risk` field.

---

## 5. Dataset Grain

The cleaned dataset contains:

- **180,519** order-item rows
- **65,752** unique orders
- **20,652** unique customers
- **118** unique products
- **51** categories
- **164** order countries

### Important point about the data

One row represents **one order item / line item**.

An order can contain multiple items, so `order_id` can appear more than once.

`order_item_id` is unique.

Because of this, order-level metrics such as Average Order Value use:

```sql
SUM(sales) / COUNT(DISTINCT order_id)
```

rather than simply averaging individual rows.

---

# 6. Overall Results

| KPI | Result |
|---|---:|
| Total Orders | 65,752 |
| Total Order Items | 180,519 |
| Total Customers | 20,652 |
| Total Sales | $36.78M |
| Total Quantity | 384,079 |
| Average Order Value | $559.45 |
| Average Sales per Unit | $95.77 |
| Average Shipping Variance | 0.57 days |
| SLA Breach Rate | 57.28% |

### What this tells us

The calculated SLA breach rate was **57.28%**.

That means more than half of the order-item shipments took longer than their scheduled shipping time.

The average shipping variance was **0.57 days**, meaning actual shipping time was higher than scheduled time on average.

This gave us a clear reason to investigate fulfillment performance further.

---

# 7. Delivery Status Results

| Delivery Status | Order Items | Avg Shipping Variance | SLA Breach |
|---|---:|---:|---:|
| Late delivery | 98,977 | 1.62 days | 100.00% |
| Shipping canceled | 7,754 | 0.57 days | 57.04% |
| Advance shipping | 41,592 | -1.50 days | 0.00% |
| Shipping on time | 32,196 | 0.00 days | 0.00% |

### What this tells us

The `Late delivery` group contained **98,977 order items** and had an average shipping variance of **1.62 days**.

Advance shipments had a negative variance, meaning they were generally shipped earlier than scheduled.

`Shipping canceled` is a separate delivery outcome, so it should not automatically be treated as a late delivery.

---

# 8. Shipping Mode Performance

| Shipping Mode | Order Items | Actual Days | Scheduled Days | Variance | SLA Breach |
|---|---:|---:|---:|---:|---:|
| First Class | 27,814 | 2.00 | 1.00 | 1.00 | 100.00% |
| Second Class | 35,216 | 3.99 | 2.00 | 1.99 | 79.73% |
| Same Day | 9,737 | 0.48 | 0.00 | 0.48 | 47.83% |
| Standard Class | 107,752 | 4.00 | 4.00 | 0.00 | 39.77% |

### What this tells us

There was a large difference in SLA performance between shipping modes.

First Class had a **100% SLA breach rate**.

Second Class had a breach rate of approximately **80%**.

Standard Class had the lowest breach rate at approximately **40%**, although it had by far the largest number of order items.

This made shipping mode one of the main areas we wanted to investigate further.

> These results show an association. They do not prove that shipping mode itself causes the delays.

---

# 9. Shipping Mode: Breach Rate vs Number of Breaches

Looking only at the breach percentage does not tell the complete story.

We therefore compared both:

- SLA breach rate
- Number of breached order items

| Shipping Mode | Total Items | Breached Items | Breach Rate | Share of Total Breaches |
|---|---:|---:|---:|---:|
| Standard Class | 107,752 | 42,851 | 39.77% | 41.44% |
| Second Class | 35,216 | 28,078 | 79.73% | 27.15% |
| First Class | 27,814 | 27,814 | 100.00% | 26.90% |
| Same Day | 9,737 | 4,657 | 47.83% | 4.50% |

### What this tells us

This was one of the most useful findings from the analysis.

First Class had the **highest breach rate**, but Standard Class had the **largest number of breached shipments**.

Standard Class accounted for **41.44% of all SLA breaches** because it handled a much larger volume.

So:

> **The highest breach rate is not always the same as the biggest operational impact.**

This is why both percentage and volume should be considered when looking for improvement areas.

---

# 10. Shipping Mode and Sales

| Shipping Mode | Orders | Sales | Aggregated Profit | SLA Breach |
|---|---:|---:|---:|---:|
| Standard Class | 39,324 | $22.02M | $2.37M | 39.77% |
| Second Class | 12,778 | $7.15M | $0.75M | 79.73% |
| First Class | 10,079 | $5.67M | $0.64M | 100.00% |
| Same Day | 3,571 | $1.94M | $0.20M | 47.83% |

### What this tells us

Standard Class handled the largest number of orders and generated the highest sales.

At the same time, First Class and Second Class had much higher SLA breach rates.

This shows why it is useful to look at operational performance together with business volume.

### Important note about profit

The dataset field `order_profit_per_order` was not unique within many orders.

Because of this, the values above are described as **aggregated profit** rather than confirmed order-level profit.

---

# 11. Category Performance

Some of the highest-sales categories were:

| Category | Orders | Quantity | Sales | SLA Breach |
|---|---:|---:|---:|---:|
| Fishing | 15,164 | 17,325 | $6.93M | 57.32% |
| Cleats | 20,386 | 73,734 | $4.43M | 57.33% |
| Camping & Hiking | 12,299 | 13,729 | $4.12M | 56.90% |
| Cardio Equipment | 11,355 | 37,587 | $3.69M | 56.94% |
| Women's Apparel | 17,869 | 62,956 | $3.15M | 57.13% |
| Water Sports | 13,758 | 15,540 | $3.11M | 57.21% |
| Men's Footwear | 18,783 | 22,246 | $2.89M | 56.93% |
| Indoor/Outdoor Games | 16,623 | 57,803 | $2.89M | 57.22% |

### What this tells us

The major sales categories had SLA breach rates close to the overall rate of approximately 57%.

This suggests that SLA breaches were spread across many categories rather than being concentrated in one particular category.

---

# 12. Market Performance

| Market | Orders | Sales | SLA Breach |
|---|---:|---:|---:|
| Europe | 18,561 | $10.87M | 57.69% |
| Pacific Asia | 17,577 | $8.27M | 57.32% |
| USCA | 8,579 | $5.07M | 57.15% |
| LATAM | 17,181 | $10.28M | 57.02% |
| Africa | 3,854 | $2.29M | 56.81% |

### What this tells us

The market-level SLA breach rates were very similar, ranging from approximately **56.8% to 57.7%**.

This suggests that market alone does not explain much of the difference in fulfillment performance.

We therefore looked at individual regions and shipping modes in more detail.

---

# 13. Region Performance

Some of the higher regional SLA breach rates were:

| Region | SLA Breach |
|---|---:|
| Central Africa | 60.70% |
| Western Europe | 58.52% |
| South Asia | 58.50% |
| South of USA | 58.10% |
| East of USA | 57.98% |
| Southeast Asia | 57.98% |

Some of the lower rates were:

| Region | SLA Breach |
|---|---:|
| Canada | 51.93% |
| West Africa | 55.01% |
| Caribbean | 55.88% |
| Oceania | 56.11% |

### What this tells us

There was some difference between regions, but most regions were still within a relatively similar range.

Therefore, geography by itself did not appear to be the main explanation for the overall SLA problem.

---

# 14. Customer Segment Performance

| Customer Segment | SLA Breach |
|---|---:|
| Home Office | 57.52% |
| Consumer | 57.29% |
| Corporate | 57.11% |

### What this tells us

The three customer segments had almost identical SLA breach rates.

The difference between the highest and lowest segment was small.

Therefore, customer segment does not appear to be a strong factor in explaining SLA performance in this dataset.

---

# 15. Region × Shipping Mode

We then combined region and shipping mode to see whether the shipping-mode pattern remained similar across different regions.

The main pattern was:

- **First Class:** 100% breach rate across all regions
- **Second Class:** generally high breach rates across regions
- **Standard Class:** generally around 30–45%
- **Same Day:** more variation between regions

### What this tells us

The shipping-mode pattern remained fairly consistent across regions.

This suggests that shipping mode was a stronger factor to investigate than region alone.

However, this is still an association and does not prove that shipping mode is the root cause of the delays.

---

# 16. Top Products by Sales

The highest-sales products included:

| Product | Sales | SLA Breach |
|---|---:|---:|
| Field & Stream Sportsman 16 Gun Fire Safe | $6.93M | 57.32% |
| Perfect Fitness Perfect Rip Deck | $4.42M | 57.32% |
| Diamondback Women's Serene Classic Comfort Bi | $4.12M | 56.90% |
| Nike Men's Free 5.0+ Running Shoe | $3.67M | 56.91% |
| Nike Men's Dri-FIT Victory Golf Polo | $3.15M | 57.13% |
| Pelican Sunstream 100 Kayak | $3.10M | 57.20% |
| Nike Men's CJ Elite 2 TD Football Cleat | $2.89M | 56.93% |
| O'Brien Men's Neoprene Life Vest | $2.89M | 57.22% |
| Under Armour Girls' Toddler Spine Surge Runni | $1.27M | 57.70% |
| Dell Laptop | $0.66M | 52.71% |

### What this tells us

Most of the highest-sales products had breach rates close to the overall dataset rate.

So high sales alone did not identify a product with a dramatically different SLA pattern.

However, high-sales products with breached shipments are still important because of the amount of business associated with them.

---

# 17. Product Sales Concentration

The top products accounted for a significant share of total sales.

- Top 3 products: **42.06% of total sales**
- Top 5 products: **60.59% of total sales**

### What this tells us

Sales were concentrated among a relatively small number of products.

This means fulfillment problems affecting these products could have a meaningful business impact.

---

# 18. Sales Associated with SLA-Breached Shipments

We also looked only at order items where the calculated SLA breach flag was `1`.

The products with the highest sales associated with breached shipments included:

| Product | Sales Associated with Breaches | Breached Quantity |
|---|---:|---:|
| Field & Stream Sportsman 16 Gun Fire Safe | $3.97M | 9,930 |
| Perfect Fitness Perfect Rip Deck | $2.53M | 42,110 |
| Diamondback Women's Serene Classic Comfort Bi | $2.34M | 7,812 |
| Nike Men's Free 5.0+ Running Shoe | $2.08M | 20,838 |
| Nike Men's Dri-FIT Victory Golf Polo | $1.80M | 35,972 |
| Pelican Sunstream 100 Kayak | $1.77M | 8,866 |
| O'Brien Men's Neoprene Life Vest | $1.66M | 33,136 |
| Nike Men's CJ Elite 2 TD Football Cleat | $1.65M | 12,664 |
| Under Armour Girls' Toddler Spine Surge Runni | $0.73M | 18,324 |
| Dell Laptop | $0.35M | 233 |

### What this tells us

SLA breaches were associated with substantial sales across several high-value products.

This means it would be useful to prioritize high-value and high-volume breached shipments when investigating fulfillment performance.

This analysis shows **business exposure**, not that the products themselves caused the delays.

---

# 19. Monthly Sales Trend

Sales were generally around $0.9M–$1.1M during much of the historical period.

However, the final months showed a noticeable decline:

| Month | Sales |
|---|---:|
| 2017-09 | $1.144M |
| 2017-10 | $1.074M |
| 2017-11 | $0.627M |
| 2017-12 | $0.504M |
| 2018-01 | $0.332M |

The month-over-month changes included:

- October 2017: **-6.10%**
- November 2017: **-41.63%**
- December 2017: **-19.62%**
- January 2018: **-34.18%**

### What this tells us

There was a sharp decline in sales toward the end of the dataset.

However, the data pattern also changes during these later months, and the dataset ends in January 2018.

Therefore, I would **not conclude that customer demand suddenly collapsed** without additional data validation.

This is an observation that would require further investigation.

---

# 20. Profit Field Validation

During the SQL analysis, I checked whether `order_profit_per_order` contained one value per order.

The result showed that approximately:

**45,902 orders contained multiple profit values.**

This means the field is not always one unique value for an entire order.

For that reason, the project does not simply treat `order_profit_per_order` as a true order-level profit measure.

Where it is summed, it is referred to as:

> **Aggregated profit**

This validation was important because using a column based only on its name could lead to incorrect calculations.

---

# 21. Main Findings

### Finding 1 — SLA performance needs attention

The overall calculated SLA breach rate was **57.28%**.

More than half of the order-item shipments exceeded their scheduled shipping time.

---

### Finding 2 — Shipping mode showed large differences

First Class had a **100% SLA breach rate**, while Second Class had approximately **80%**.

Shipping mode therefore became one of the main areas for further investigation.

---

### Finding 3 — High breach rate and high volume are different

First Class had the highest breach rate.

But Standard Class contributed the largest number of breached shipments, representing **41.44% of total SLA breaches**.

This showed why both breach percentage and breach volume should be considered.

---

### Finding 4 — Region was less clear

Regional breach rates varied, but the differences were relatively moderate.

Geography alone did not explain the overall fulfillment problem.

---

### Finding 5 — Customer segment showed little difference

Consumer, Corporate and Home Office customers had very similar breach rates.

Customer segment was therefore not a strong differentiator in this analysis.

---

### Finding 6 — High-value products are exposed to breaches

Several major-revenue products had substantial sales associated with SLA-breached shipments.

This gives the business another way to prioritize investigation: not just by the number of late shipments, but also by the value associated with those shipments.

---

### Finding 7 — Sales are concentrated

The top three products contributed approximately **42.06% of total sales**, and the top five contributed approximately **60.59%**.

This makes the fulfillment performance of major products particularly important.

---

# 22. Recommended Areas for Further Investigation

The analysis does not prove the root cause of delays, so the following are areas to investigate rather than confirmed causes.

### 1. Investigate First Class performance

First Class had a 100% SLA breach rate.

The business could investigate:

- Scheduled shipping-time definitions
- Order processing time
- Carrier handoff timing
- Cut-off times
- Actual fulfillment processes
- Possible data-quality issues

---

### 2. Investigate Standard Class by volume

Standard Class had a lower breach rate but the largest number of breached shipments.

Because of its high volume, even a smaller improvement in its breach rate could potentially affect a large number of shipments.

---

### 3. Investigate shipping mode and region together

Instead of looking only at region, operations can examine:

- Shipping mode
- Region
- Shipment volume
- Shipping variance

This can help identify specific combinations that deserve attention.

---

### 4. Prioritize high-value breached shipments

Products with large sales associated with SLA breaches can be reviewed to understand whether particular operational processes are affecting commercially important shipments.

---

### 5. Track both percentage and volume

A useful fulfillment dashboard should show both:

- SLA breach percentage
- Number of breached shipments

It can also include:

- Sales associated with breached shipments
- Shipping variance
- Shipping mode
- Region

This provides a more complete view of the problem.

---

# 23. Limitations

This analysis has several limitations.

### No inventory-on-hand data

The dataset does not contain reliable inventory-on-hand information.

Therefore, the analysis does not claim that stockouts caused shipping delays.

### No warehouse capacity data

There is no warehouse capacity or utilization information.

Therefore, warehouse congestion cannot be directly tested.

### No validated freight-cost field

The dataset does not provide a validated shipping-cost/freight-rate field.

Therefore, detailed freight-cost optimization is outside the scope of this project.

### No causal analysis

The analysis identifies patterns and associations.

It does not prove that shipping mode, region, product, or customer segment causes delays.

### Profit field limitation

`order_profit_per_order` is not unique within many orders.

Therefore, aggregated values from this field are treated cautiously.

### Late-period sales decline

The sharp sales decline near the end of the dataset requires further validation before being treated as a real change in demand.

---

# 24. Final Conclusion

The project started with a simple supply-chain question:

> **Are shipments being completed within their scheduled shipping timelines?**

The analysis showed a calculated SLA breach rate of **57.28%**, which gave us a clear reason to investigate fulfillment performance further.

When we broke the results down by shipping mode, First Class had a **100% breach rate** and Second Class had approximately **80%**.

However, looking only at breach rate would have been misleading.

Standard Class had a lower breach rate of approximately **40%**, but because it handled much more volume, it contributed **41.44% of all SLA breaches**.

The analysis also showed that market and customer segment differences were relatively small, while several high-value products had substantial sales associated with SLA-breached shipments.

Overall, the analysis suggests that fulfillment performance should be reviewed using multiple dimensions rather than a single KPI.

The most useful combination for further investigation is:

**Shipping Mode + Region + Breach Volume + Shipping Variance + Sales Exposure**

---

# 25. Next Step — Power BI

The SQL analysis provides the foundation for the Power BI dashboard.

The dashboard will focus on the main questions discovered during the analysis.

### Page 1 — Executive Overview

- Total Sales
- Total Orders
- Total Quantity
- Average Order Value
- SLA Breach %
- Monthly Sales Trend
- Sales by Category
- SLA Breach by Shipping Mode

### Page 2 — Fulfillment Performance

- SLA Breach by Shipping Mode
- SLA Breach by Region
- Shipping Variance
- Breached Shipment Volume
- Region × Shipping Mode
- Contribution to Total Breaches

### Page 3 — Product & Commercial Performance

- Top Products by Sales
- Top Products by Quantity
- Sales Contribution
- Sales Associated with SLA Breaches
- High-value products with fulfillment exposure

The Power BI dashboard should present the important findings from the SQL analysis rather than simply reproduce every SQL query.
