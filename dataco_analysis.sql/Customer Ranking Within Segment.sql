SELECT
    customer_id,
    customer_name,
    customer_segment,
    total_orders,
    total_revenue,
    avg_satisfaction_score,
    late_delivery_rate_pct,

    RANK() OVER (
        PARTITION BY customer_segment
        ORDER BY total_revenue DESC
    )                           AS rank_within_segment,

    RANK() OVER (
        ORDER BY total_revenue DESC
    )                           AS rank_overall

FROM dataco.vw_customer_value
ORDER BY customer_segment, rank_within_segment
LIMIT 30;