CREATE OR REPLACE VIEW dataco.vw_customer_value AS
SELECT
    c.customer_id,
    c.customer_fname || ' ' || c.customer_lname         AS customer_name,
    c.customer_segment,
    c.customer_city,
    c.customer_country,

    COUNT(DISTINCT o.order_id)     AS total_orders,
    COUNT(oi.order_item_id)                              AS total_line_items,
    ROUND(SUM(oi.sales), 2)                             AS total_revenue,
    ROUND(
        SUM(oi.sales)
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
    , 2)                                                 AS avg_order_value,

    ROUND(SUM(oi.benefit_per_order), 2)                 AS total_profit,
    ROUND(AVG(oi.order_item_profit_ratio) * 100, 1)     AS avg_margin_pct,

    ROUND(
        SUM(o.late_delivery_risk)::NUMERIC
        / NULLIF(COUNT(DISTINCT o.order_id), 0) * 100
    , 1)                                                 AS late_delivery_rate_pct,

    SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END) AS total_returns,

    ROUND(
        AVG(
            CASE
                WHEN oi.customer_satisfaction_score BETWEEN 1 AND 5
                THEN oi.customer_satisfaction_score
                ELSE NULL
            END
        )
    , 2)      AS avg_satisfaction_score,

    MIN(o.order_date_dateorders::DATE)    AS first_order_date,
    MAX(o.order_date_dateorders::DATE)     AS last_order_date

FROM dataco.customers c
    INNER JOIN dataco.orders o
        ON c.customer_id = o.order_customer_id
    INNER JOIN dataco.order_items oi
        ON o.order_id = oi.order_id

WHERE o.order_status = 'COMPLETE'

GROUP BY
    c.customer_id,
    c.customer_fname,
    c.customer_lname,
    c.customer_segment,
    c.customer_city,
    c.customer_country;


SELECT
    customer_name,
    customer_segment,
    total_orders,
    total_revenue,
    avg_satisfaction_score
FROM dataco.vw_customer_value
ORDER BY total_revenue DESC
LIMIT 10;