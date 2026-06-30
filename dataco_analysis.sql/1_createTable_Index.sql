-- ── ORDERS TABLE ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dataco.orders (
    order_id                        INTEGER,
    order_customer_id               INTEGER,
    order_date_dateorders           TEXT,
    order_status                    TEXT,
    order_region                    TEXT,
    order_city                      TEXT,
    order_country                   TEXT,
    order_state                     TEXT,
    order_zipcode                   TEXT,
    market                          TEXT,
    type                            TEXT,
    delivery_status                 TEXT,
    late_delivery_risk              SMALLINT,
    shipping_mode                   TEXT,
    shipping_date_dateorders        TEXT,
    days_for_shipping_real          INTEGER,
    days_for_shipment_scheduled     INTEGER,
    warehouse_id                    TEXT,
    carrier                         TEXT,
    freight_cost_usd                NUMERIC(10,2),
    return_flag                     SMALLINT
);

-- ── ORDER_ITEMS TABLE ──────
CREATE TABLE IF NOT EXISTS dataco.order_items (
    order_item_id                   INTEGER,
    order_id                        INTEGER,
    product_card_id                 INTEGER,
    order_item_quantity             INTEGER,
    order_item_product_price        NUMERIC(10,2),
    order_item_discount             NUMERIC(10,2),
    order_item_discount_rate        NUMERIC(6,4),
    sales                           NUMERIC(12,2),
    order_item_total                NUMERIC(12,2),
    order_item_profit_ratio         NUMERIC(8,4),
    benefit_per_order               NUMERIC(12,2),
    order_profit_per_order          NUMERIC(12,2),
    sales_per_customer              NUMERIC(12,2),
    stock_level_at_order            INTEGER,
    lead_time_days                  INTEGER,
    qty_anomaly_flag                TEXT,
    customer_satisfaction_score     NUMERIC(4,2)
);

-- ── CUSTOMERS TABLE ────
CREATE TABLE IF NOT EXISTS dataco.customers (
    customer_id                     INTEGER,
    customer_fname                  TEXT,
    customer_lname                  TEXT,
    customer_email                  TEXT,
    customer_city                   TEXT,
    customer_country                TEXT,
    customer_state                  TEXT,
    customer_street                 TEXT,
    customer_zipcode                TEXT,
    customer_segment                TEXT,
    latitude                        NUMERIC(10,7),
    longitude                       NUMERIC(10,7)
);

-- ── PRODUCTS TABLE ────────────────────────======================
CREATE TABLE IF NOT EXISTS dataco.products (
    product_card_id                 INTEGER,
    product_name                    TEXT,
    product_category_id             INTEGER,
    category_id                     INTEGER,
    category_name                   TEXT,
    department_id                   INTEGER,
    department_name                 TEXT,
    product_price                   NUMERIC(10,2),
    product_status                  TEXT,
    product_image                   TEXT,
    supplier_name                   TEXT
);


-- Check 1: Row counts
SELECT 'orders'      AS table_name, COUNT(*) AS row_count FROM dataco.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM dataco.order_items
UNION ALL
SELECT 'customers',   COUNT(*) FROM dataco.customers
UNION ALL
SELECT 'products',    COUNT(*) FROM dataco.products;

-- Check 5: supplier_name values are clean (8 canonical names)
SELECT supplier_name, COUNT(*) AS count
FROM dataco.products
GROUP BY supplier_name
ORDER BY count DESC;

-- Primary key indexes
CREATE INDEX IF NOT EXISTS idx_orders_order_id
    ON dataco.orders(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON dataco.order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON dataco.order_items(product_card_id);

CREATE INDEX IF NOT EXISTS idx_customers_customer_id
    ON dataco.customers(customer_id);

CREATE INDEX IF NOT EXISTS idx_products_product_id
    ON dataco.products(product_card_id);

-- Foreign key indexes (columns used in JOIN conditions)
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON dataco.orders(order_customer_id);