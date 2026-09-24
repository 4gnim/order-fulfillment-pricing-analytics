# Order Fulfillment & Pricing Profitability Analytics

A SQL, Python, and Power BI analytics project focused on order fulfillment status, transaction pricing, and realized product profitability.

## Business Questions

1. How are orders distributed across shipped, canceled, and pending statuses?
2. How does order activity change over time?
3. Which product categories generate the most shipped revenue?
4. How does transaction price compare with list price?
5. Which high-revenue products require profitability review?

## Dataset

The dataset contains seven related tables:

- Customer
- Employee
- OrderDetails
- Orders
- Product
- Region
- Warehouse

Each table contains 400 rows in the provided dataset. Foreign-key validation performed during data preparation found no orphan records across the tested relationships.

## Tools

- MySQL
- Python (Pandas, NumPy, Matplotlib)
- Power BI
- Git / GitHub

## Data Preparation

The analysis joins orders, order details, customers, and products. Transaction-level metrics include:

- Revenue = Quantity × Transaction Price
- Estimated Cost = Quantity × Standard Cost
- Gross Profit = Quantity × (Transaction Price − Standard Cost)
- Price Realization = Transaction Price ÷ List Price
- Gross Margin = Gross Profit ÷ Revenue

The Power BI dashboard uses the processed order-level analytical dataset.

## Dashboard

### 1. Order Fulfillment Overview

Highlights total orders, shipped/canceled/pending orders, cancellation rate, yearly status distribution, order value by status, and monthly order trend.

### 2. Pricing & Product Profitability

Shows shipped revenue by category, price realization, gross margin, and a product-level review table for high-revenue items with weak realized profitability.

> Note: The source data contains transaction prices that can differ substantially from product list prices and standard costs. Profitability metrics are therefore presented as analytical results from the supplied dataset rather than accounting statements.

## Key Findings

- 400 orders are present in the dataset: 183 shipped, 111 canceled, and 106 pending.
- The cancellation rate is 27.75%.
- Shipped-order revenue is approximately 14.04M in the dataset's currency units.
- Shipped realized gross profit is negative in aggregate, indicating a substantial gap between transaction prices and product standard costs in the supplied data.
- Mother Board is the only shipped category with positive aggregate gross margin in the current analysis; other categories show negative margins.
- Several high-revenue products have very low price realization and negative realized gross margins, making them candidates for further pricing and data-quality review.

## Project Structure

```text
order-fulfillment-pricing-analytics/
├── README.md
├── docs/
│   └── index.html
├── sql/
│   └── analysis.sql
├── python/
│   └── exploratory_analysis.ipynb
├── data/
│   └── README.md
├── screenshots/
│   ├── dashboard-overview.png
│   └── dashboard-profitability.png
└── .gitignore
```

## Important Interpretation Note

The supplied dataset is synthetic or otherwise not accompanied by accounting definitions for its price and cost fields. Negative realized gross profit and extreme price-realization values should therefore be interpreted as patterns in the dataset that require investigation, not as verified financial performance of a real company.
