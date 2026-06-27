# 🛒 dbt E-Commerce Analytics

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

A production-style dbt project demonstrating full dbt best practices — seeds, models, macros, tests, and docs — built on a simulated Indian e-commerce dataset.

---

## 🏗️ Architecture

```
seeds (CSV)  →  staging (views)  →  intermediate (views)  →  marts (tables)
customers.csv      stg_customers       int_orders_enriched     mart_customer_lifetime_value
products.csv       stg_products        int_customer_orders     mart_product_performance
orders.csv         stg_orders                                  mart_monthly_revenue
order_items.csv    stg_order_items                             mart_order_summary
```

## 🔄 dbt Lineage

```
[seeds] ──▶ [staging] ──▶ [intermediate] ──▶ [marts]
  4 CSVs       4 views         2 views          4 tables
  92 rows      cleaned      enriched joins    analytics ready
```

---

## ✅ dbt Features Used

| Feature | Details |
|---------|---------|
| **Seeds** | 4 CSV files: customers, products, orders, order_items |
| **Models** | 10 models across staging, intermediate, and marts layers |
| **Macros** | 3 reusable macros: `inr_to_usd`, `classify_customer`, `order_status_label` |
| **Tests** | 28 tests: unique, not_null, accepted_values across all models |
| **Docs** | Full column descriptions, dbt docs generate & serve |
| **Sources** | Seeds referenced as sources via `ref()` |

---

## 📁 Project Structure

```
dbt-ecommerce-analytics/
├── seeds/
│   ├── customers.csv          # 15 customers across India
│   ├── products.csv           # 15 products across categories
│   ├── orders.csv             # 25 orders with status & discounts
│   └── order_items.csv        # 37 line items
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   ├── stg_orders.sql
│   │   ├── stg_order_items.sql
│   │   └── schema.yml         # Tests & descriptions
│   ├── intermediate/
│   │   ├── int_orders_enriched.sql
│   │   └── int_customer_orders.sql
│   └── marts/
│       ├── mart_customer_lifetime_value.sql
│       ├── mart_product_performance.sql
│       ├── mart_monthly_revenue.sql
│       ├── mart_order_summary.sql
│       └── schema.yml         # Tests & descriptions
├── macros/
│   ├── cents_to_dollars.sql   # inr_to_usd conversion macro
│   ├── classify_customer.sql  # Customer tier classification
│   └── order_status_label.sql # Human readable status labels
├── tests/                     # Custom singular tests
├── scripts/
│   └── init_db.sql            # PostgreSQL schema setup
├── docker-compose.yml
├── dbt_project.yml
└── profiles.yml
```

---

## 🔧 Macros

### `inr_to_usd(amount_inr, exchange_rate=83.5)`
Converts Indian Rupees to USD with a configurable exchange rate.
```sql
{{ inr_to_usd('price_inr') }}  -- returns price in USD
```

### `classify_customer(lifetime_value)`
Classifies customers into tiers based on lifetime value.
```sql
{{ classify_customer('lifetime_value_inr') }}
-- Returns: Platinum (≥5L), Gold (≥2L), Silver (≥50K), Bronze
```

### `order_status_label(status_col)`
Converts raw status codes to human readable labels.
```sql
{{ order_status_label('status') }}
-- Returns: Completed, Returned, Cancelled
```

---

## 🧪 Tests (28 total)

| Test Type | Count | Examples |
|-----------|-------|---------|
| `unique` | 8 | customer_id, order_id, product_id |
| `not_null` | 14 | All primary keys and critical fields |
| `accepted_values` | 6 | segment, status, customer_tier, customer_status |

---

## 📊 Data Models

### Marts

**`mart_customer_lifetime_value`** — 15 rows
| Column | Description |
|--------|-------------|
| customer_tier | Platinum / Gold / Silver / Bronze |
| customer_status | Active / At Risk / Churned |
| lifetime_value_inr | Total completed order value |
| lifetime_value_usd | Converted to USD via macro |

**`mart_product_performance`** — 15 rows
| Column | Description |
|--------|-------------|
| total_revenue_inr | Total revenue from completed orders |
| total_profit_inr | Revenue minus cost |
| revenue_rank | Ranked by revenue descending |

**`mart_monthly_revenue`** — 6 rows
| Column | Description |
|--------|-------------|
| revenue_inr | Monthly net revenue |
| mom_growth_pct | Month-over-month growth % |
| avg_order_value_inr | Average order value that month |

**`mart_order_summary`** — 25 rows
| Column | Description |
|--------|-------------|
| discounted_total_inr | Order total after discount |
| discount_amount_inr | Amount saved by customer |

---

## 🚀 Getting Started

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Python 3.9+
- dbt-core 1.8.0

### Setup

1. **Clone the repo**
```bash
git clone https://github.com/arnavv-agarwal/dbt-ecommerce-analytics.git
cd dbt-ecommerce-analytics
```

2. **Install dbt**
```bash
pip install dbt-core==1.8.0 dbt-postgres==1.8.0 psycopg2-binary
```

3. **Start PostgreSQL**
```bash
docker compose up -d
```

4. **Test connection**
```bash
dbt debug --profiles-dir .
```

5. **Run everything**
```bash
dbt build --profiles-dir .
```

6. **View docs**
```bash
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir . --port 8081
```

Open **http://localhost:8081** to explore the lineage graph!

---

## 📈 Build Results

```
✅ 4  seeds loaded   (92 rows total)
✅ 10 models built   (6 views + 4 tables)
✅ 28 tests passed   (0 failures)
⏱️  Total time: 4.27 seconds
```

---

## 📌 What I Learned

- Structuring a **layered dbt project** (staging → intermediate → marts)
- Writing **reusable macros** for currency conversion and classification
- Implementing **generic dbt tests** (unique, not_null, accepted_values)
- Using **seeds** to load static reference data into the warehouse
- Generating **dbt documentation** with lineage graphs
- Using **SQL window functions** for ranking and MoM growth calculations
- Connecting dbt to **PostgreSQL running in Docker**

---

## 👤 Author

**Arnav Agarwal**
- GitHub: [@arnavv-agarwal](https://github.com/arnavv-agarwal)
- LinkedIn: [arnavvagarwal](https://www.linkedin.com/in/arnavvagarwal/)

---

*Built as a data engineering portfolio project showcasing dbt best practices*

---
