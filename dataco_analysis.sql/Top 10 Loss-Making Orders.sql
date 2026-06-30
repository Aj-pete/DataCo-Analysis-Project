SELECT
    order_id,
    total_revenue,
    total_profit,
    ROUND(total_profit / NULLIF(total_revenue, 0) * 100, 1) AS margin_pct,
    line_items,
    market,
    customer_segment,
    shipping_mode,
    carrier
FROM (
    SELECT
        o.order_id,
        ROUND(SUM(oi.sales), 2)                 AS total_revenue,
        ROUND(SUM(oi.benefit_per_order), 2)      AS total_profit,
        COUNT(oi.order_item_id)                  AS line_items,
        o.market,
        c.customer_segment,
        o.shipping_mode,
        o.carrier
    FROM dataco.orders o
        INNER JOIN dataco.order_items oi
            ON o.order_id = oi.order_id
        INNER JOIN dataco.customers c
            ON o.order_customer_id = c.customer_id
    WHERE o.order_status = 'COMPLETE'
    GROUP BY
        o.order_id, o.market,
        c.customer_segment,
        o.shipping_mode, o.carrier
) AS order_totals
ORDER BY total_profit ASC
LIMIT 10;