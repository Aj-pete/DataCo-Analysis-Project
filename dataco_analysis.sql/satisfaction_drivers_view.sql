CREATE OR REPLACE VIEW dataco.vw_satisfaction_drivers AS
SELECT
    o.late_delivery_risk,
    o.delivery_status,
    o.shipping_mode,
    o.carrier,
    o.market,
    o.return_flag,

    -- Discount tier
    CASE
        WHEN oi.order_item_discount_rate = 0        THEN 'No Discount'
        WHEN oi.order_item_discount_rate <= 0.10    THEN 'Low (1-10%)'
        WHEN oi.order_item_discount_rate <= 0.20    THEN 'Medium (11-20%)'
        WHEN oi.order_item_discount_rate <= 0.50    THEN 'High (21-50%)'
        ELSE 'Very High (>50%)'
    END                                             AS discount_tier,

    -- Stock level tier
    CASE
        WHEN oi.stock_level_at_order < 50           THEN 'Low Stock (<50)'
        WHEN oi.stock_level_at_order < 150          THEN 'Medium Stock (50-149)'
        WHEN oi.stock_level_at_order < 300          THEN 'Good Stock (150-299)'
        ELSE 'High Stock (300+)'
    END                                             AS stock_tier,

    COUNT(oi.order_item_id)                         AS line_items,

    COUNT(
        CASE
            WHEN oi.customer_satisfaction_score BETWEEN 1 AND 5
            THEN 1 ELSE NULL
        END
    )              AS valid_score_count,

    ROUND(
        AVG(
            CASE
                WHEN oi.customer_satisfaction_score BETWEEN 1 AND 5
                THEN oi.customer_satisfaction_score
                ELSE NULL
            END
        )
    , 2)       AS avg_satisfaction_score,

    SUM(CASE WHEN oi.customer_satisfaction_score = 1 THEN 1 ELSE 0 END) AS score_1,
    SUM(CASE WHEN oi.customer_satisfaction_score = 2 THEN 1 ELSE 0 END) AS score_2,
    SUM(CASE WHEN oi.customer_satisfaction_score = 3 THEN 1 ELSE 0 END) AS score_3,
    SUM(CASE WHEN oi.customer_satisfaction_score = 4 THEN 1 ELSE 0 END) AS score_4,
    SUM(CASE WHEN oi.customer_satisfaction_score = 5 THEN 1 ELSE 0 END) AS score_5

FROM dataco.order_items oi
    INNER JOIN dataco.orders o
        ON oi.order_id = o.order_id

GROUP BY
    o.late_delivery_risk,
    o.delivery_status,
    o.shipping_mode,
    o.carrier,
    o.market,
    o.return_flag,
    discount_tier,
    stock_tier;

SELECT
    late_delivery_risk,
    SUM(valid_score_count)      AS scored_items,
    ROUND(
        SUM(avg_satisfaction_score * valid_score_count)
        / NULLIF(SUM(valid_score_count), 0)
    , 2)                        AS weighted_avg_score
FROM dataco.vw_satisfaction_drivers
GROUP BY late_delivery_risk
ORDER BY late_delivery_risk;