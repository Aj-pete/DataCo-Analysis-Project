CREATE OR REPLACE VIEW dataco.vw_product_returns AS
SELECT
    p.product_card_id,
    p.product_name,
    p.category_name,
    p.department_name,
    p.supplier_name,
    p.product_price,
    o.market,

    COUNT(oi.order_item_id)                                         AS total_line_items,
    COUNT(DISTINCT o.order_id)                                      AS total_orders,

    SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END)            AS returned_items,

    ROUND(
        SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(oi.order_item_id), 0) * 100
    , 1)                                                            AS return_rate_pct,

    ROUND(
        SUM(CASE WHEN o.return_flag = 1 THEN oi.sales ELSE 0 END)
    , 2)                                                            AS returned_revenue,

    ROUND(
        SUM(CASE WHEN o.return_flag = 1 THEN oi.benefit_per_order ELSE 0 END)
    , 2)                                                            AS profit_on_returned_items,

    ROUND(
        AVG(
            CASE
                WHEN o.return_flag = 1
                    AND oi.customer_satisfaction_score BETWEEN 1 AND 5
                THEN oi.customer_satisfaction_score
                ELSE NULL
            END
        )
    , 2)      AS avg_satisfaction_returned,

    ROUND(
        AVG(
            CASE
                WHEN o.return_flag = 0
                    AND oi.customer_satisfaction_score BETWEEN 1 AND 5
                THEN oi.customer_satisfaction_score
                ELSE NULL
            END
        )
    , 2)      AS avg_satisfaction_not_returned

FROM dataco.order_items oi
    INNER JOIN dataco.orders o
        ON oi.order_id = o.order_id
    INNER JOIN dataco.products p
        ON oi.product_card_id = p.product_card_id

GROUP BY
    p.product_card_id,
    p.product_name,
    p.category_name,
    p.department_name,
    p.supplier_name,
    p.product_price,
    o.market;

SELECT
    department_name,
    SUM(total_line_items)       AS total_items,
    SUM(returned_items)         AS returns,
    ROUND(
        SUM(returned_items)::NUMERIC
        / NULLIF(SUM(total_line_items), 0) * 100
    , 1)                        AS return_rate_pct,
    ROUND(SUM(returned_revenue), 0) AS returned_revenue
FROM dataco.vw_product_returns
GROUP BY department_name
ORDER BY return_rate_pct DESC;