# Brazilian E-Commerce Analytics — Olist Dataset

End-to-end data analytics project on the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce): data cleaning (Excel), a relational MySQL warehouse with SQL analysis, Python EDA, and a Power BI dashboard.

## Project Workflow

1. **Data Cleaning (Excel)** — validated 9 raw CSVs for duplicates, standardized inconsistent text (e.g. `são paulo` → `sao paulo`). See [`docs/data_cleaning_notes.md`](docs/data_cleaning_notes.md).
2. **Database Design & SQL Analysis (MySQL)** — built a 9-table relational schema (`Brazilian_E_Commerce_Database`) with primary/foreign keys, then ran 15+ queries covering revenue trends, RFM-style customer behavior, delivery performance, and seller rankings. See [`sql/`](sql/).
3. **Python EDA** — data dictionary, cleaning pipeline, and exploratory analysis using pandas / SQLAlchemy / SQLite. See [`notebooks/`](notebooks/).
4. **Power BI Dashboard** — interactive dashboard built on the cleaned dataset. See [`powerbi/`](powerbi/).

## Key Findings

- Late deliveries strongly hurt satisfaction: 5-star orders arrived ~13.4 days ahead of estimate on average, vs. only 4.1 days for 1-star orders.
- 8.11% of delivered orders arrived later than the estimated delivery date.
- São Paulo state alone accounts for ~37.4% of total revenue.
- Credit card is the dominant payment method at 77% of all payments (avg. R$163/payment); boleto accounts for 22% of value.
- November 2017 saw a +53% month-over-month revenue spike (Black Friday effect).
- Repeat purchase rate is low (~3.5%) across 96,096 unique customers and 99,441 orders — most customers order only once.
- Average freight cost is R$19.99 per order item; 96,478 of ~99,441 orders were successfully delivered (625 canceled, 609 unavailable).
- `bed_bath_table` leads on units sold (11,115 items) but `health_beauty` and `watches_gifts` lead on revenue — volume and margin are led by different categories.

Full query-by-query breakdown with results: [`sql/README.md`](sql/README.md).

## Business Insights & Recommendations

- **Delivery speed is the #1 satisfaction lever.** The gap between 5★ orders (delivered ~13 days early on average) and 1★ orders (delivered ~4 days early) is the strongest pattern in the whole dataset. Tightening delivery estimates or investing in faster carriers for at-risk regions should move review scores directly — this is a logistics decision with a measurable CX payoff, not just an ops metric.
- **Retention, not acquisition, is the biggest untapped lever.** Only ~3.5% of customers ever place a second order. A post-purchase email flow, a second-purchase discount, or a loyalty program targeted at the small cohort of repeat buyers (some ordered 7–17+ times) could lift lifetime value meaningfully without spending more on acquisition.
- **São Paulo justifies dedicated infrastructure.** At ~37% of revenue and 2.5x the next-largest state, a regional fulfillment hub or dedicated carrier contract for SP would cut delivery times where it matters most, while thinner states are better served by demand-generation or seller-recruitment campaigns.
- **Plan inventory and staffing around November.** The +53% Black Friday revenue spike is predictable and recurring — treating it as an annual peak-planning event (stock, warehouse staffing, customer support capacity) reduces the risk that a demand surge turns into more late deliveries and lower review scores.
- **Payment-method concentration is a risk worth watching.** 77% of payment volume rides on a single rail (credit card). Boleto users spend similarly per order but may face more purchase friction (it requires a bank visit/transfer in Brazil) — worth testing as a possible cause of the low repeat-purchase rate in that segment.
- **Thin seller supply caps category growth.** Ranking sellers within each category surfaces categories served by only 1–2 active sellers — these are natural targets for seller-recruitment efforts, since demand in a category can't convert to revenue without supply to fill it.

## Repository Structure

```
├── sql/
│   ├── schema_and_queries.sql   # schema, keys, and all 15 analysis queries
│   ├── results/                 # query output CSVs
│   └── README.md                # query-by-query writeup with business insights
├── notebooks/          # Python EDA notebook
├── powerbi/            # .pbix dashboard file
├── docs/               # Data cleaning notes & data dictionary
└── README.md
```

## Dataset

Raw CSVs are not included in this repo due to size. Download them directly from Kaggle: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Tools Used

MySQL · Python (pandas, SQLAlchemy, SQLite) · Power BI · Excel

## Author

**Madhusudan Rajpurohit**
[GitHub](https://github.com/Madhusudan-Rajpurohit) · rajpurohitmadhusudan5@gmail.com
