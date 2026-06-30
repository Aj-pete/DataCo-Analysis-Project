CREATE OR REPLACE VIEW dataco.vw_profitability_by_segment AS
SELECT
    c.customer_segment,
    o.market,
    o.order_region,
    p.department_name,
    p.category_name,
    o.order_status,

    COUNT(DISTINCT o.order_id)    AS total_orders,
    COUNT(oi.order_item_id)       AS total_line_items,

    ROUND(SUM(oi.sales), 2)     AS total_revenue,

    ROUND(SUM(oi.benefit_per_order), 2)  AS total_profit,
    ROUND(
        SUM(oi.benefit_per_order)
        / NULLIF(SUM(oi.sales), 0) * 100
    , 1)    AS profit_margin_pct,

    ROUND(AVG(oi.order_item_profit_ratio) * 100, 1)    AS avg_item_margin_pct,
    ROUND(
        SUM(oi.sales)
        / NULLIF(COUNT(DISTINCT o.order_id), 0)
    , 2)      AS avg_order_value,

    ROUND(AVG(oi.order_item_discount_rate) * 100, 1)   AS avg_discount_rate_pct,
    SUM(CASE WHEN oi.benefit_per_order < 0 THEN 1 ELSE 0 END)   AS negative_margin_items,

    ROUND(
        SUM(CASE WHEN oi.benefit_per_order < 0 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(oi.order_item_id), 0) * 100
    , 1)            AS negative_margin_rate_pct

FROM dataco.order_items oi
    INNER JOIN dataco.orders o
        ON oi.order_id = o.order_id
    INNER JOIN dataco.customers c
        ON o.order_customer_id = c.customer_id
    INNER JOIN dataco.products p
        ON oi.product_card_id = p.product_card_id

WHERE o.order_status = 'COMPLETE'

GROUP BY
    c.customer_segment,
    o.market,
    o.order_region,
    p.department_name,
    p.category_name,
    o.order_status;

SELECT
    customer_segment,
    SUM(total_orders)       AS orders,
    SUM(total_revenue)      AS revenue,
    SUM(total_profit)       AS profit,
    ROUND(
        SUM(total_profit) / NULLIF(SUM(total_revenue), 0) * 100
    , 1)                    AS blended_margin_pct
FROM dataco.vw_profitability_by_segment
GROUP BY customer_segment
ORDER BY revenue DESC;