CREATE OR REPLACE VIEW dataco.vw_supplier_reliability AS
SELECT
    p.supplier_name,
    p.department_name,

    COUNT(oi.order_item_id)      AS total_line_items,
    COUNT(DISTINCT o.order_id)     AS total_orders,
    COUNT(DISTINCT p.product_card_id)     AS products_supplied,

    SUM(o.late_delivery_risk)       AS late_deliveries,

    ROUND(
        SUM(o.late_delivery_risk)::NUMERIC
        / NULLIF(COUNT(oi.order_item_id), 0) * 100
    , 1)         AS late_rate_pct,

    ROUND(
        AVG(o.days_for_shipping_real - o.days_for_shipment_scheduled)::NUMERIC
    , 2)  AS avg_days_variance,

    ROUND(AVG(ABS(o.freight_cost_usd)), 2)         AS avg_freight_cost,
    ROUND(
        SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(oi.order_item_id), 0) * 100
    , 1)                  AS return_rate_pct,

    ROUND(
        AVG(
            CASE
                WHEN oi.customer_satisfaction_score BETWEEN 1 AND 5
                THEN oi.customer_satisfaction_score
                ELSE NULL
            END
        )
    , 2)                AS avg_satisfaction_score,

    ROUND(SUM(oi.sales), 2)                AS total_revenue,
    ROUND(SUM(oi.benefit_per_order), 2)     AS total_profit,

    ROUND(
        SUM(oi.benefit_per_order)
        / NULLIF(SUM(oi.sales), 0) * 100
    , 1)          AS profit_margin_pct,

    ROUND(AVG(oi.lead_time_days)::NUMERIC, 1)      AS avg_lead_time_days,
    COUNT(oi.lead_time_days)      AS lead_time_data_points

FROM dataco.order_items oi
    INNER JOIN dataco.products p
        ON oi.product_card_id = p.product_card_id
    INNER JOIN dataco.orders o
        ON oi.order_id = o.order_id

GROUP BY
    p.supplier_name,
    p.department_name

HAVING COUNT(oi.order_item_id) >= 100;


SELECT
    supplier_name,
    total_orders,
    late_rate_pct,
    return_rate_pct,
    avg_satisfaction_score,
    profit_margin_pct
FROM dataco.vw_supplier_reliability
ORDER BY late_rate_pct DESC;