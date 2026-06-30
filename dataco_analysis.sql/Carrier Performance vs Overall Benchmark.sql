WITH overall_benchmark AS (
    SELECT
        ROUND(
            SUM(late_delivery_risk)::NUMERIC
            / NULLIF(COUNT(order_id), 0) * 100
        , 1)                                AS overall_late_rate_pct,
        ROUND(AVG(ABS(freight_cost_usd)), 2) AS overall_avg_freight
    FROM dataco.orders
),
carrier_performance AS (
    SELECT
        carrier,
        COUNT(order_id)                     AS total_orders,
        ROUND(
            SUM(late_delivery_risk)::NUMERIC
            / NULLIF(COUNT(order_id), 0) * 100
        , 1)                                AS carrier_late_rate_pct,
        ROUND(AVG(ABS(freight_cost_usd)), 2) AS carrier_avg_freight
    FROM dataco.orders
    GROUP BY carrier
)
SELECT
    cp.carrier,
    cp.total_orders,
    cp.carrier_late_rate_pct,
    ob.overall_late_rate_pct,
    ROUND(cp.carrier_late_rate_pct - ob.overall_late_rate_pct, 1) AS vs_benchmark_pct,
    CASE
        WHEN cp.carrier_late_rate_pct < ob.overall_late_rate_pct THEN 'Above Average'
        WHEN cp.carrier_late_rate_pct = ob.overall_late_rate_pct THEN 'At Benchmark'
        ELSE 'Below Average'
    END                                     AS performance_vs_benchmark,
    cp.carrier_avg_freight,
    ob.overall_avg_freight
FROM carrier_performance cp
CROSS JOIN overall_benchmark ob
ORDER BY cp.carrier_late_rate_pct ASC;