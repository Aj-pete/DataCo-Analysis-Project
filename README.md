# DataCo Global — Supply Chain Business Intelligence Project

> **A full-stack BI engagement spanning data cleaning, advanced analytics, relational database design, and interactive dashboard delivery.**
> Excel · PostgreSQL · Power BI · DAX · Power Query · VBA

**Analyst:** Ajayi Peter
**LinkedIn:** [linkedin.com/in/peter-ajayi-92318b2b6](https://www.linkedin.com/in/peter-ajayi-92318b2b6)

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Business Questions](#business-questions)
3. [Dataset](#dataset)
4. [Key Findings](#key-findings)
5. [Tools and Architecture](#tools-and-architecture)
6. [Project Structure](#project-structure)
7. [Excel Workbook — Four Layers](#excel-workbook--four-layers)
8. [PostgreSQL — SQL Analysis Layer](#postgresql--sql-analysis-layer)
9. [Power BI — Client Dashboard](#power-bi--client-dashboard)
10. [Data Cleaning Summary](#data-cleaning-summary)
11. [How to Run This Project](#how-to-run-this-project)
12. [Business Recommendations](#business-recommendations)
13. [Skills Demonstrated](#skills-demonstrated)
12. [Skills Demonstrated](#skills-demonstrated)

---

## Project Overview

### Note; All excel files( raw data, supply_chain_WORKING.xlsm and csv upload for postgres) are in this download link(https://drive.google.com/drive/folders/1fmv29CR_zV-cNUCGfY1v4CxH8SfJMahe?usp=sharing). Feel free to download for better check.


This project simulates a real client engagement for **DataCo Global**, a multinational e-commerce and supply chain company operating across five regions — Pacific Asia, Europe, LATAM, USCA, and Africa. The brief was to analyse three years of supply chain transaction data, identify the root causes of operational underperformance, and deliver actionable business intelligence across three platforms.

The project was approached as a Business Analyst first, data analyst second — every metric, visual, and recommendation connects directly to a business consequence, not just a technical observation.

**Engagement deliverables:**
- A fully documented Excel workbook with a Power Query cleaning pipeline, advanced formula analysis, Power Pivot data model, and DAX-powered dashboard
- A PostgreSQL database with 8 named VIEWs encoding all business logic
- A 6-page interactive Power BI dashboard connected to the SQL layer

---

## Business Questions

Eight specific business questions drove every analytical decision:

| # | Question | Why It Matters |
|---|---|---|
| Q1 | Why are 54.8% of orders delivered late — and which variables drive it? | Late delivery is the biggest customer experience failure in the dataset and the primary churn risk |
| Q2 | Which markets and segments are profitable — and which are eroding margin? | Average profit margin is only 10.9% with some orders losing 275% of revenue |
| Q3 | Which carriers and suppliers are most reliable? | 6 carriers at near-identical cost — performance must differentiate them |
| Q4 | Which customer segments generate the most value? | Consumer (52%), Corporate (30%), Home Office (18%) require different service strategies |
| Q5 | Is freight spend justified by delivery outcomes? | $2,046,002 in freight — cost per on-time delivery varies dramatically by shipping mode |
| Q6 | Does stock level at order time drive late delivery? | Tests whether inventory positioning or scheduling is the root cause of fulfilment failures |
| Q7 | What is driving the 8.1% return rate? | Returns represent double cost — original fulfilment plus reverse logistics |
| Q8 | What variables most strongly predict a low satisfaction score? | Average score is 2.91/5 — below the midpoint on a 5-point scale |

---

## Dataset

**Source:** DataCo Global Supply Chain Dataset (enriched with additional operational columns)

**Scope:** January 2015 — January 2018

| Table | Rows | Description |
|---|---|---|
| Orders | 65,767 | Order-level transactions with delivery, carrier, freight, and market data |
| Order Items | 180,539 | Line-item detail with revenue, profit, discount, and satisfaction |
| Customers | 20,662 | Customer master with segment and geographic dimensions |
| Products | 118 | Product catalogue with category, department, supplier, and price |

**Additional columns included beyond the base dataset:**
`supplier_name`, `warehouse_id`, `freight_cost_usd`, `return_flag`, `stock_level_at_order`, `lead_time_days`, `carrier`, `customer_satisfaction_score`

---

## Key Findings

### Finding 1 — The First Class Inversion (Critical)
First Class shipping has a **95.3% late delivery rate**. Standard Class — the cheapest option — has a **38.1% late rate**. A customer paying a premium for speed receives the worst service more than 9 times out of 10.

**Business implication:** This is a pricing credibility crisis. Customers associating First Class with reliable fast delivery are being systematically misled. This directly drives churn and satisfaction collapse.

### Finding 2 — Carrier is Not the Problem
All 6 carriers (TNT, FedEx, Aramex, DHL, UPS, USPS) deliver within **1 percentage point of each other** at 54–55% late rate, at near-identical average freight cost ($30.52–$31.73). The problem is not carrier performance — it is the shipping mode classification and scheduling process upstream of the carrier.

**Business implication:** Renegotiating carrier contracts will not fix late delivery. The fix requires reviewing how orders are assigned to shipping modes and what the scheduling SLAs for each mode actually are.

### Finding 3 — Late Delivery Destroys Satisfaction
On-time orders score **4.00/5** on customer satisfaction. Late orders score **2.01/5**. That is a **1.99-point gap** on a 5-point scale — driven entirely by whether the order arrived on time.

**Business implication:** Satisfaction improvement does not require a separate customer experience initiative. Fix late delivery and satisfaction follows automatically.

### Finding 4 — Inventory Does Not Drive Late Delivery
Average stock level at order time is **249.3 units for on-time orders** and **250.2 units for late orders** — a difference of less than 1 unit. Inventory positioning is not causing fulfilment failures.

**Business implication:** The root cause of late delivery is in scheduling and mode assignment, not supply availability. Inventory investment will not solve this problem.

### Finding 5 — Thin and Fragile Margins
Overall profit margin is **10.9%** across completed orders. Some individual orders have profit ratios as low as **-275%** — the business loses $2.75 for every $1.00 of revenue on those transactions. High discount rates (above 20%) are systematically correlated with negative margin outcomes.

**Business implication:** The client needs a discount policy review. Discounts above 20% are destroying margin without evidence of proportional revenue uplift.

---

## Tools and Architecture

```
┌─────────────────────────────────────────────────────┐
│                   RAW SOURCE DATA                    │
│         4 Excel sheets · 246,986 records            │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│              EXCEL — THINK LAYER                     │
│                                                      │
│  Layer 1: Power Query cleaning pipeline              │
│  Layer 2: Advanced formula analysis (XLOOKUP,        │
│           SUMIFS, COUNTIFS, dynamic arrays)          │
│  Layer 3: Query documentation, named ranges, VBA     │
│  Layer 4: Power Pivot data model + DAX measures      │
│           + internal dashboard                       │
└──────────────────────┬──────────────────────────────┘
                       │  Export clean CSVs
                       ▼
┌─────────────────────────────────────────────────────┐
│           POSTGRESQL — SCALE LAYER                   │
│                                                      │
│  4 tables · 8 named VIEWs · 3 analytical queries    │
│  Window functions · CTEs · Multi-table JOINs        │
│  Business logic encoded in reusable VIEWs           │
└──────────────────────┬──────────────────────────────┘
                       │  Connect to VIEWs only
                       ▼
┌─────────────────────────────────────────────────────┐
│           POWER BI — PRESENT LAYER                   │
│                                                      │
│  12 DAX measures · 6 dashboard pages                │
│  Cross-filtering · Drill-through · Tooltips         │
│  Client-ready interactive deliverable               │
└─────────────────────────────────────────────────────┘
```

**Handoff logic:**
- **Excel → SQL:** Clean data exported as 4 CSV files, imported into PostgreSQL with explicit typed schema
- **SQL → Power BI:** Power BI connects to PostgreSQL VIEWs only — never raw tables. The database handles all aggregation; Power BI handles presentation
- **Excel DAX → Power BI DAX:** All 6 measures from Excel Power Pivot are rewritten and extended in Power BI with 6 additional measures

---

## Project Structure

```
DataCo-Global-Supply-Chain/
│
├── README.md                          ← This file
│
├── Excel/
│   └──supply_chain_WORKING.xlsm      ← Main workbook (macro-enabled)
│       ├── Changelog                  ← 19 documented cleaning decisions
│       ├── Data_Dictionary            ← All 62 columns defined
│       ├── Query_Documentation        ← Power Query pipeline documented
│       ├── orders_CLEAN               ← Power Query output (65,752 rows)
│       ├── order_items_CLEAN          ← Power Query output (180,539 rows)
│       ├── customers_CLEAN            ← Power Query output (20,662 rows)
│       ├── products_CLEAN             ← Power Query output (118 rows)
│       ├── Delivery_Analysis          ← Late rate, carrier, market analysis
│       ├── Profitability_Analysis     ← Revenue, margin, segment analysis
│       ├── Satisfaction_Analysis      ← Score distribution, driver analysis
│       └── Dashboard                  ← Power Pivot + DAX dashboard
│
├── SQL/
│   └── dataco_analysis.sql            ← All SQL — setup, VIEWs, queries
│
├── PowerBI/
│   └── dataco_dashboard.pbix          ← Power BI report file
│
└── Data/
    ├── orders_clean.csv
    ├── order_items_clean.csv
    ├── customers_clean.csv
    └── products_clean.csv
```

---

## Excel Workbook — Four Layers

### Layer 1 — Data Cleaning (Power Query)

Four Power Query pipelines clean the raw data automatically on every refresh. No manual cleaning is required after initial setup.

**19 data quality issues resolved across 246,986 records:**

| Issue | Scale | Resolution |
|---|---|---|
| 5 mixed date formats in order_date | 65,767 rows | Locale-aware parsing (en-US + en-GB fallback) |
| 27 order status variants | 65,767 rows | Text.Upper() normalisation → 9 canonical values |
| 19 market name variants (incl. Spanish EE.UU.) | 65,767 rows | Text.Upper() + Trim() → 5 canonical regions |
| 12 return flag variants (yes/no/TRUE/1/0) | 65,767 rows | Standardised to integer 0/1 |
| 1,280 negative freight cost values | 1,280 rows | ABS() transform applied |
| 14,444 dollar-sign sales values stored as text | 14,444 rows | $ removed, converted to NUMERIC |
| 5,416 discount rates above 100% (e.g. 1.75) | 5,416 rows | Divided by 10 (decimal entry error) |
| 5,416 invalid satisfaction scores (0/6/7/99) | 5,416 rows | Replaced with null, null propagation guard |
| 11 customer country variants (incl. EE.UU.) | 20,662 rows | → United States / Puerto Rico |
| 23 supplier name variants | 118 rows | → 8 canonical supplier names |
| 6 product status variants mixing int and text | 118 rows | → Active / Inactive |

**Decisions to leave data unchanged (5 documented):**
- `order_zipcode`: 88% null — expected for international orders
- `customer_email`: Intentionally privacy-masked — compliance requirement
- `order_item_discount`: 12,525 nulls — no discount applied, not missing
- `lead_time_days`: 12,756 nulls — source system gap, cannot impute
- `order_state`: Sparse for non-US orders — expected

### Layer 2 — Advanced Formula Analysis

Three analysis tabs built entirely from Excel formulas — no pivot tables.

**Functions used:** `XLOOKUP`, `INDEX/MATCH`, `SUMIF`, `SUMIFS`, `COUNTIF`, `COUNTIFS`, `AVERAGEIF`, `AVERAGEIFS`, `IFERROR`, `SUMPRODUCT`, `FILTER`, `SORT`, `UNIQUE`, `SEQUENCE`, `DATEDIF`, `IFS`, nested `IF`

**Delivery_Analysis tab:** Late rate by shipping mode, carrier, and market. Days variance distribution (SUMPRODUCT across calculated columns). Order-to-ship cycle time (DATEDIF). Cost per on-time delivery derived metric.

**Profitability_Analysis tab:** Revenue and profit by segment and market (SUMIFS, COMPLETE orders only). Top 10 loss-making orders (dynamic FILTER + SORT + CHOOSE). Discount rate vs margin correlation table.

**Satisfaction_Analysis tab:** Score by late delivery status, carrier, shipping mode, and return flag. Score distribution (COUNTIFS banding). Named range `kpi_avg_satisfaction` powering cross-tab references.

### Layer 3 — Automation and Documentation

- **Query_Documentation tab:** Full pipeline documentation — purpose, transformation steps, known limitations, and refresh instructions for all 4 queries
- **Named Ranges:** 6 `kpi_` prefixed named ranges for headline metrics, referenced across tabs and the dashboard
- **VBA Macro:** `RefreshDashboard` — loops through all workbook connections and pivot tables, refreshes both in sequence, confirms completion count via MsgBox. Includes `Application.ScreenUpdating`, `On Error Resume Next`, and dynamic pivot table discovery (no hardcoded sheet names)

### Layer 4 — Power Pivot and DAX

**Data model:** 4 tables loaded into the internal data model. 3 one-to-many relationships defined (order_items → orders, orders → customers, order_items → products). Duplicate order_ids removed via Power Query deduplication step before relationship creation.

**DAX measures (6):**

| Measure | Type | Formula Pattern |
|---|---|---|
| Late Delivery Rate | Rate | DIVIDE(CALCULATE(COUNTROWS, filter), COUNTROWS, 0) |
| Profit Margin % | Ratio | DIVIDE(SUM(profit), SUM(revenue), 0) |
| First Class Late Rate | Conditional | CALCULATE([Late Delivery Rate], mode = "First Class") |
| Total Freight Cost | Row iterator | SUMX(orders, ABS(freight_cost_usd)) |
| Avg Satisfaction Score | Safe division | DIVIDE(CALCULATE(SUM, score ≥ 1, score ≤ 5), CALCULATE(COUNT, valid range), 0) |
| Total Revenue | Conditional agg | CALCULATE(SUM(sales), status = "COMPLETE") |

---

## PostgreSQL — SQL Analysis Layer

**Database:** `dataco_supply_chain` | **Schema:** `dataco`

**8 named VIEWs — business logic encoded and reusable:**

| VIEW | Business Purpose | Key Techniques |
|---|---|---|
| `vw_delivery_performance` | Late rate by mode, carrier, market | NULLIF safe division, CAST::NUMERIC, CASE WHEN in SUM |
| `vw_profitability_by_segment` | Revenue and margin by segment/market/category | 4-table INNER JOIN, COUNT(DISTINCT), WHERE filter |
| `vw_freight_efficiency` | Freight spend vs delivery outcomes | Derived cost_per_ontime_delivery metric |
| `vw_customer_value` | Customer-level revenue, profit, satisfaction | 3-table JOIN, date casting ::DATE |
| `vw_product_returns` | Return rate by product, category, market | CASE WHEN inside AVG for conditional aggregation |
| `vw_satisfaction_drivers` | Satisfaction by delivery, discount, stock tier | CASE banding, alias in GROUP BY |
| `vw_monthly_trends` | Monthly KPI trends 2015–2018 | CTE + 5 window functions (LAG, running SUM, rolling AVG, RANK) |
| `vw_supplier_reliability` | Supplier delivery and satisfaction performance | HAVING for minimum sample filtering |

**3 analytical queries:**
- Top 10 loss-making orders (correlated subquery)
- Carrier vs overall benchmark comparison (multi-CTE + CROSS JOIN)
- Customer ranking within segment (RANK with PARTITION BY)

**PostgreSQL-specific patterns used throughout:**
- `::NUMERIC` cast for decimal division
- `::DATE` cast for text-stored dates
- `NULLIF(denominator, 0)` for safe division
- `TO_CHAR(date::DATE, 'YYYY-MM')` for date formatting
- `CREATE OR REPLACE VIEW` for non-destructive view updates
- `CREATE INDEX IF NOT EXISTS` on all JOIN columns

---

## Power BI — Client Dashboard

**Connection:** PostgreSQL native connector → 8 VIEWs only (no raw tables)

> **The Power BI report file (`dataco_dashboard.pbix`) is available in the `PowerBI/` folder of this repository. Download and open in Power BI Desktop (free at powerbi.microsoft.com) to interact with the full 6-page dashboard.**

**12 DAX measures including:**
- `Late Delivery Rate` — DIVIDE pattern
- `On Time Rate` — measure referencing measure
- `Avg Satisfaction Score` — SUMX weighted average
- `First Class Late Rate` — CALCULATE with hardcoded filter
- `OnTime Satisfaction` / `Late Satisfaction` — CALCULATE for split comparison
- `Selected Market Title` — ISFILTERED + SELECTEDVALUE dynamic text
- `Late Rate Colour` — returns hex colour code for conditional formatting
- `Score Count by Label` — SWITCH for dynamic score distribution chart

**6 dashboard pages:**

| Page | Business Question | Key Visuals |
|---|---|---|
| Executive Summary | Overall health at a glance | 6 KPI cards, late rate by market bar, revenue donut |
| Delivery Performance | What is driving 54.8% late delivery? | Shipping mode bar (red/amber/green), carrier comparison, analytical text callout |
| Profitability & Margin | Where is money made and lost? | Stacked bar, 4-quadrant scatter plot, negative margin table |
| Customer & Satisfaction | What drives satisfaction? | On-time vs late score cards (4.00 vs 2.01), score distribution, top 10 customers |
| Supplier & Inventory | Which suppliers are reliable? | Reliability scorecard, stock level finding text card |
| Trends Over Time | How has performance moved? | Revenue + late rate overlay, running total area, MoM change bar |

---

## Data Cleaning Summary

**19 issues found and resolved. 5 documented decisions to leave data unchanged.**

All cleaning decisions are recorded in the `Changelog` tab of the Excel workbook with: Change_ID, date, sheet affected, column affected, issue found, action taken, rows affected, and analyst note.

All columns are defined in the `Data_Dictionary` tab with: data type, business definition, valid values, null policy, cleaning reference, and analytical use.

> The Changelog and Data Dictionary were built before any formula or analysis work began. Every decision — including decisions not to act — is documented and defensible.

---

## How to Run This Project

### Excel Workbook
1. Open `supply_chain_WORKING.xlsm`
2. Enable macros when prompted
3. Go to the `Dashboard` tab — this is the entry point
4. To refresh with new data: click the `🔄 Refresh Data` button or go to **Data → Refresh All**

### PostgreSQL Database
1. Install PostgreSQL and open pgAdmin 4
2. Create database `dataco_supply_chain` and schema `dataco`
3. Run `dataco_analysis.sql` in full — it creates all tables, imports data, creates indexes, and builds all 8 VIEWs in sequence
4. Verify with: `SELECT COUNT(*) FROM dataco.orders;` — should return 65,752

### Power BI Dashboard
1. Open `dataco_dashboard.pbix` in Power BI Desktop
2. Go to **Home → Transform data → Data source settings**
3. Update the PostgreSQL server to `localhost` and enter your credentials
4. Click **Refresh** — all 6 pages populate from the SQL VIEWs

---

## Skills Demonstrated

**Excel:**
Power Query (M language) · Power Pivot data model · DAX measures · VBA macro development · XLOOKUP · dynamic array functions (FILTER, SORT, UNIQUE, SEQUENCE) · SUMPRODUCT · SUMIFS/COUNTIFS/AVERAGEIFS · DATEDIF · named ranges · structured table references · conditional formatting · data validation · Excel Table design · chart formatting

**SQL (PostgreSQL):**
Multi-table INNER JOIN · GROUP BY aggregation · HAVING filters · subqueries · Common Table Expressions (CTEs) · Window functions (LAG, SUM OVER, AVG with ROWS BETWEEN, RANK with PARTITION BY) · CASE WHEN · NULLIF safe division · CAST / :: type conversion · TO_CHAR date formatting · CREATE OR REPLACE VIEW · CREATE INDEX · schema design · COPY import

**Power BI:**
PostgreSQL native connector · DAX (CALCULATE, DIVIDE, SUMX, SWITCH, ISFILTERED, SELECTEDVALUE) · measures table pattern · cross-filtering · conditional formatting by measure · dynamic titles · weighted average pattern · scatter plot with reference lines · page navigation · tooltip configuration · colour theme customisation

**Business Analysis:**
Business question framing · root cause analysis · KPI definition · data documentation standards (Changelog, Data Dictionary, Query Documentation) · analytical decision documentation · insight narrative (what → why → so what) · client deliverable design

---

*DataCo Global Supply Chain BI Project*
*Tools: Microsoft Excel · PostgreSQL · Microsoft Power BI*
*Data: 246,986 records across 4 tables · January 2015 — January 2018*

---

## Business Recommendations

Every finding in this project was interrogated through three questions: what is happening, why is it happening, and what should the business actually do about it. The recommendations below follow directly from the data.

---

### REC 1 — Audit and Restructure the First Class Shipping Process (Critical Priority)

**Finding:** First Class shipping has a 95.3% late delivery rate versus 38.1% for Standard Class. Customers paying more for speed receive worse outcomes more than 9 times out of 10.

**Root cause:** The data rules out carrier performance as the cause — all 6 carriers deliver within 1 percentage point of each other across all shipping modes. The problem is upstream: how orders are assigned to First Class, what the internal scheduling SLA for First Class actually is, and whether warehouse fulfilment prioritises First Class orders correctly.

**Recommended actions:**
- Conduct an internal audit of First Class order scheduling — compare the promised SLA to actual warehouse processing time before handoff to the carrier
- Temporarily suspend First Class as a customer-facing option until scheduling is fixed — offering a service you cannot reliably deliver destroys trust faster than not offering it at all
- If First Class is tied to a specific warehouse or routing, test whether the issue is facility-specific
- Once fixed, monitor First Class late rate weekly with a threshold alert at 15% — anything above that triggers an automatic review

**Business impact of inaction:** Customers paying premium prices for First Class who receive late deliveries are the most likely to churn. They expected more and received less. Satisfaction scores for First Class orders confirm this at 2.10/5 — the lowest of any shipping mode.

---

### REC 2 — Implement a Discount Rate Policy with Margin Floor (High Priority)

**Finding:** Discount rates above 20% are systematically correlated with negative profit margins. Some orders with extreme discounts generate profit ratios as low as -275%. Total negative-margin line items represent a material profit leak.

**Root cause:** There is no evidence of a discount ceiling in the data — discounts appear to be applied without a margin check at point of sale. High-discount orders are not generating proportional volume uplift to compensate for the margin destruction.

**Recommended actions:**
- Introduce a system-level margin floor: no order should be approved with a discount rate that pushes the line-item profit ratio below 0%
- Set a soft warning at 15% discount rate and a hard block at 20% discount rate unless approved by a manager
- Review the top 10 loss-making orders identified in the SQL analysis — determine whether these were authorised exceptions or system failures
- Analyse whether high-discount customers have higher lifetime value (repeat purchase rate) that justifies the upfront margin sacrifice — if not, the discount policy has no strategic rationale

**Business impact of inaction:** At a 10.9% blended margin, the business has very little buffer. Continued negative-margin orders will compress profitability further and may make certain product categories or markets unviable.

---

### REC 3 — Reposition Shipping Mode Pricing and Customer Communication (High Priority)

**Finding:** The four shipping modes (Standard Class, Second Class, First Class, Same Day) do not deliver meaningfully different outcomes in terms of freight cost — average costs range from $30.52 to $31.73, less than $1.21 difference. But late delivery rates range from 38.1% to 95.3%. The pricing structure does not reflect the actual service reliability.

**Recommended actions:**
- Reclassify shipping modes based on actual performance data, not marketing labels — "First Class" is a misleading name for the worst-performing tier
- Communicate expected delivery windows to customers based on historical actual performance, not scheduled days — this sets accurate expectations and reduces dissatisfaction when orders are late
- Consider consolidating Second Class and First Class into a single "Express" tier with honest SLA communication once the scheduling issue is resolved

---

### REC 4 — Prioritise Customer Retention for Late-Delivery Customers (Medium Priority)

**Finding:** The satisfaction gap between on-time (4.00/5) and late delivery (2.01/5) is 1.99 points. Customers who received late orders are highly likely to be dissatisfied regardless of product quality, price, or discount.

**Recommended actions:**
- Implement an automatic service recovery workflow: any order flagged as late should trigger a proactive outreach — apology communication and a compensation offer (discount on next order, partial refund) sent before the customer contacts support
- Proactive recovery costs less than reactive customer service and significantly reduces churn probability
- Prioritise this intervention for Corporate and Consumer segment customers who place repeat orders — they represent the highest lifetime value at risk

---

### REC 5 — Investigate Return Rate Concentration by Department (Medium Priority)

**Finding:** Return rate is 8.1% overall but is not evenly distributed. Pet Shop and Technology departments show the highest return rates. Returns represent double cost — original fulfilment plus reverse logistics.

**Recommended actions:**
- Investigate whether high-return departments have product description accuracy issues (customers receiving something different from what they expected) or quality issues (products failing on arrival)
- For Technology specifically, check whether return rates correlate with specific suppliers — if one supplier's products drive a disproportionate share of Technology returns, the supplier contract should be reviewed
- Calculate the total cost of returns by department (fulfilment cost + reverse logistics + restocking) and compare to departmental profit — departments where return cost exceeds profit margin should be reviewed for catalogue rationalisation

---

### REC 6 — Do Not Invest in Inventory as a Late Delivery Fix (Immediate Clarification)

**Finding:** Stock level at order time is virtually identical between late orders (250.2 units) and on-time orders (249.3 units) — less than 1 unit difference.

**Recommended action:** This is a decision not to act — and it is as important as the other recommendations. If the business is considering increasing safety stock or warehouse investment to reduce late delivery, this analysis shows that investment will not solve the problem. The cause is scheduling and mode assignment, not stock availability. Redirecting that capital to fixing the First Class scheduling process (Recommendation 1) will deliver a measurable improvement. Increasing inventory will not.

---

### Summary — Priority Order

| Priority | Recommendation | Expected Impact |
|---|---|---|
| 1 — Critical | Audit and fix First Class shipping scheduling | Reduce 95.3% late rate — direct satisfaction and churn impact |
| 2 — High | Implement discount rate margin floor | Stop negative-margin order leakage |
| 3 — High | Reposition shipping mode pricing and communication | Reduce expectation misalignment and satisfaction complaints |
| 4 — Medium | Proactive service recovery for late deliveries | Reduce churn from the 54.8% of orders that arrive late |
| 5 — Medium | Investigate return rate concentration | Reduce double-cost of returns in high-rate departments |
| 6 — Immediate | Do not increase inventory to fix late delivery | Redirect capital to root cause (scheduling), not symptoms |

