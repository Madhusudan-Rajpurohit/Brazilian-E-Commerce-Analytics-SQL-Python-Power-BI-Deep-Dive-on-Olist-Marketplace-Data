# SQL Analysis

Schema and all queries: [`schema_and_queries.sql`](schema_and_queries.sql). Query outputs (as run against the MySQL database): [`results/`](results/).

Database: `Brazilian_E_Commerce_Database` — 9 tables (`customers`, `orders`, `order_items`, `payments`, `reviews`, `products`, `sellers`, `geolocations`, `category_translation`), primary keys on every table and foreign keys enforcing the order → customer → order_items → product/seller relationships.

---

## Revenue & Growth

### 1. Monthly Revenue Trend
`results/1__Monthly_revenue_trend.csv`
Total revenue and order count by month, Sep 2016 – Aug 2018 (excludes canceled orders).
**Insight:** Revenue scales from a soft-launch trickle in 2016 to a steady multi-million-real run rate by 2018 — useful as the baseline chart for any growth narrative.

### 2. Month-over-Month Revenue Growth
`results/3__Monthly_revenue_growth.csv`
Same revenue series with `LAG()` to compute % growth month over month.
**Insight:** November 2017 shows a **+53% MoM spike** — Black Friday. **Business action:** treat Nov as a demand-planning and inventory/staffing peak every year; a promo calendar that leans into this month has outsized ROI.

### 3. Top 10 Categories by Revenue
`results/2__Top_10_categories_by_revenue.csv`
**Insight:** `health_beauty`, `watches_gifts`, and `bed_bath_table` are the top 3 revenue categories, but `bed_bath_table` sells 11,115 items for ~R$1.04M while `watches_gifts` earns nearly as much (R$1.2M) from far fewer, higher-ticket items. **Business action:** these are two different plays — bed_bath_table is a volume/logistics category, watches_gifts is a margin/AOV category. Marketing spend and inventory strategy should differ accordingly.

### 4. Best-Selling Category by Units
`results/12_Category_with_the_most_items_sold.csv`
`bed_bath_table` — 11,115 items, the highest unit volume of any category.
**Insight:** Highest volume ≠ highest revenue category (see #3) — a reminder to always pair units-sold with revenue-per-category before allocating warehouse space or ad budget.

### 5. Revenue by Customer State
`results/8__Revenue_by_state.csv`
**Insight:** São Paulo (SP) alone drives **~37% of total revenue** (R$5.9M of ~R$15.8M), more than 2.5x the next state (RJ). **Business action:** SP justifies a dedicated regional fulfillment hub to cut delivery time; underperforming states (long tail below RJ/MG/RS/PR) are candidates for targeted regional marketing or seller-recruitment drives to build supply where demand is thin.

### 6. Top 5 Most Expensive Products Sold
`results/9__Top_5_most_expensive_products_ever_sold.csv`
**Insight:** Top single-item price is ~R$6,735. These are outliers worth a manual look — high-value items carry higher fraud, damage, and return risk and may justify special handling/insurance in fulfillment.

---

## Customers

### 7. Unique Customers vs. Total Orders
`results/13_Unique_customers_vs__total_orders.csv`
96,096 unique customers → 99,441 orders.
**Insight:** Implied repeat-purchase rate is only **~3.5%** — the overwhelming majority of customers buy exactly once. **Business action:** this is the single biggest growth lever available. Post-purchase email flows, loyalty incentives, or a second-purchase discount could meaningfully lift LTV, since acquisition (not retention) is currently doing almost all the work.

### 8. Top 5 Customers by Lifetime Spend
`results/14__Top_5_customers_by_total_spend.csv`
**Insight:** The single highest-spending customer (R$13,664) did it in **one order**, not many — reinforcing that this marketplace is acquisition-driven, not loyalty-driven. A VIP/white-glove program for large single-order buyers could still be worth testing even without repeat behavior.

### 9. Customer Order Recency & Frequency
`results/15__First_and_most_recent_order_date_per_customer.csv`
First/most recent order date and order count per customer — the raw material for RFM segmentation.
**Insight:** A small set of customers do order 7–17+ times over a year — these are the seed list for a "most loyal customers" retention or referral campaign.

---

## Delivery & Satisfaction

### 10. Late Delivery Rate
`results/5__deleivary_late.csv`
**8.11%** of delivered orders arrived after the estimated delivery date.
**Insight:** Roughly 1 in 12 orders breaks its delivery promise. **Business action:** this is a concrete, trackable OKR — even a 2–3 point reduction in late-delivery rate, given the finding below, would likely move review scores measurably.

### 11. Delivery Delay vs. Review Score
`results/6__Delivery_delay_vs_review_score.csv`
Avg delivery delay (negative = early) by review score: 1★ = -4.06 days, 5★ = -13.39 days.
**Insight:** This is the strongest relationship in the dataset — **early delivery is the single clearest driver of a 5-star review.** **Business action:** logistics performance should be treated as a customer-satisfaction lever, not just an ops metric. Setting more conservative (achievable) estimated delivery dates, or investing in faster carriers for at-risk regions, is likely to raise review scores directly.

### 12. Average Freight Cost per Order
`results/11__Average_freight_cost_per_order.csv`
Average freight cost: **R$19.99** per order item.
**Insight:** Combined with the state-revenue breakdown (#5), freight cost as a % of order value is likely highest for distant/low-density states — worth a follow-up query before deciding on free-shipping thresholds by region.

### 13. Order Status Breakdown
`results/10__Order_count_by_status.csv`
96,478 delivered vs. 625 canceled vs. 609 unavailable vs. 314 invoiced (of ~99,441 total).
**Insight:** Cancellations and "unavailable" together are a small (~1.2%) but recoverable slice — worth checking whether these concentrate in specific categories/sellers (stock accuracy issue) or specific payment types (payment failure issue).

---

## Payments & Sellers

### 14. Payment Method Breakdown
`results/7__Payment_method_breakdown_by_order_value_tier.csv`
Credit card = 77% of payment volume (76,795 payments, R$12.5M); boleto = 22% of value.
**Insight:** Heavy reliance on a single payment rail is a concentration risk. **Business action:** boleto users show similar avg. payment value to credit card users, so there's no evidence they're a "lower-value" segment — friction in the boleto flow (it requires a bank visit/transfer in Brazil) is a plausible, testable reason repeat purchases are so low for that segment.

### 15. Top 3 Sellers per Category (Ranked)
`results/4__Top_seller_per_category__ranked.csv`
Window-function ranking (`RANK() OVER PARTITION BY category`) of sellers by revenue within each category.
**Insight:** This surfaces category leaders and, by extension, categories with only 1–2 active sellers — those are expansion opportunities (seller-recruitment target list) since thin seller supply in a category likely caps revenue growth there regardless of demand.
