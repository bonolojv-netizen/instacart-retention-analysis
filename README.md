# Instacart Customer Retention & Cohort Analysis

A cohort/retention analysis of real Instacart order data, built with PostgreSQL, Python, and Power BI.
Second portfolio project (first: retail RFM segmentation with SQL + Power BI) — this one demonstrates
cohort/retention analysis instead of segmentation, using the same core tool stack.

📄 **[Full written report (PDF)](./Business%20Report/Instacart_Retention_Report.pdf)**

---

## Project Overview

**Dataset:** [Instacart Market Basket Analysis](https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis/code) (public Kaggle dataset — ~3M orders, ~200K users)
**Sample:** 25,000 users (sampled at the user level to preserve complete order histories), ~410K orders, ~4.1M order line items
**Tools:** PostgreSQL (cohort tables) · Python/pandas (loading & cleaning) · Power BI (dashboard)

### Questions answered
1. What % of customers keep ordering as their order sequence progresses?
2. Does the department/category of a customer's first order predict return behavior?
3. How does basket size change over a customer's order sequence?
4. What's the days-between-orders pattern for low-engagement vs. highly-retained customers?

> **Data caveat:** Kaggle's published version of this dataset only includes customers with **4–100 historical orders** — true one-time customers aren't present. Questions 1 and 4 were reframed around this dataset's real floor (retention tracked from order #4 onward; "low-engagement" vs. "highly-retained" defined by order-count thresholds rather than a literal one-time/repeat split). Full explanation in the [written report](/Business%20Report/Instacart_Retention_Report.pdf).

---

## Key Findings

| Metric | Result |
|---|---|
| Retention at order #50 | **5.5%** (down from 95.9% at order #4) |
| Repeat rate, produce/dairy-first customers | **~54%** vs. 44–48% for shelf-stable-first customers |
| Average basket size | **~10 items** — stable across entire order history |
| Days between orders | **19.3 days** (low-engagement) vs. **7.8 days** (highly-retained) |

---

## Dashboard

**Summary page** — headline KPIs and dataset context:

![Summary page](/images/Summary%20page.png)

**Retention curve** — % of customers reaching each order-sequence checkpoint:

![Retention curve](/images/Retention%20curve.png)

**First-order category vs. retention** — average total orders by dominant first-order department:

![Category vs retention](/images/First-order%20category%20vs.%20retention.png)

**Basket size by order sequence** — average items per order across a customer's history:

![Basket size trend](/images/Basket%20size%20by%20order%20sequence.png)

**Order cadence by engagement group** — average days between orders, low-engagement vs. highly-retained:

![Cadence comparison](/images/Order%20cadence%20by%20engagement%20group.png)

*(To regenerate: open `dashboard.pbix` in Power BI Desktop, connect to your local `instacart` Postgres database, and refresh.)*

---

## Repo Structure

```
├── README.md
├── Instacart_Retention_Report.pdf     # Full written report
├── notebooks/
│   └── 01_load_and_clean.ipynb        # Data loading, user-level sampling, validation
├── sql/
│   └── cohort_views.sql               # All 4 cohort views (retention, category, basket, cadence)
├── dashboard/
│   └── dashboard.pbix                 # Power BI dashboard (5 pages)
└── images/                            # Dashboard screenshots (for this README)
```

---

## Methodology Summary

1. **Loaded** the 6 raw Instacart CSVs, filtered to orders with product-level detail (`eval_set` in `prior`/`train`)
2. **Sampled** 25,000 users at the user level (not row-level) to keep each customer's full order sequence intact — essential for valid cohort math
3. **Validated** data quality: 0 duplicate order IDs, null pattern in `days_since_prior_order` matched exactly to first orders, 100% of sampled users had a clean sequential order history, 0 orphaned order-product rows
4. **Built 4 SQL views** in PostgreSQL answering each research question (see `sql/cohort_views.sql`)
5. **Connected Power BI** to the views and built a 5-page dashboard (Summary + 4 detail pages)

---

## Business Recommendations

1. **Trigger re-engagement outreach on cadence, not just recency** — customers who pass ~14 days without ordering while still early in their lifecycle (under 10 orders) are a high-risk signal, based on the 19-day vs. 8-day cadence gap between low-engagement and highly-retained customers.
2. **Steer new customers toward perishable categories in their first order** — produce/dairy-first customers show ~54% repeat rates vs. ~44-48% for shelf-stable-first customers. Worth testing as a merchandising/onboarding nudge (correlational finding — validate with a controlled test before full rollout).
3. **Focus retention investment on the order 4–10 window** — this is where the steepest drop-off occurs (95.9% → 52.5%); the curve flattens meaningfully beyond that.

Full detail and caveats in the [written report](/Business%20Report/Instacart_Retention_Report.pdf).
