CREATE OR REPLACE VIEW dataco.vw_delivery_performance AS
SELECT
    -- Dimensions
    o.shipping_mode,
    o.carrier,
    o.market,
    o.order_region,
    o.delivery_status,

    -- Volume
    COUNT(o.order_id)                                               AS total_orders,

    -- Late delivery metrics
    SUM(o.late_delivery_risk)                                       AS late_orders,
    COUNT(o.order_id) - SUM(o.late_delivery_risk)                  AS on_time_orders,

    ROUND(
        SUM(o.late_delivery_risk)::NUMERIC
        / NULLIF(COUNT(o.order_id), 0) * 100
    , 1)                                                            AS late_rate_pct,

    -- Days variance (positive = late, negative = early)
    ROUND(
        AVG(o.days_for_shipping_real - o.days_for_shipment_scheduled)::NUMERIC
    , 2)                                                            AS avg_days_variance,
    ROUND(AVG(o.days_for_shipping_real)::NUMERIC, 1)               AS avg_actual_days,
    ROUND(AVG(o.days_for_shipment_scheduled)::NUMERIC, 1)          AS avg_scheduled_days,

    -- Freight
    ROUND(AVG(ABS(o.freight_cost_usd)), 2)                         AS avg_freight_cost,
    ROUND(SUM(ABS(o.freight_cost_usd)), 2)                         AS total_freight_cost,

    --= Cost per on-time delivery
    ROUND(
        SUM(ABS(o.freight_cost_usd))
        / NULLIF(COUNT(o.order_id) - SUM(o.late_delivery_risk), 0)
    , 2)        AS cost_per_ontime_delivery,

    -- Return rate
    ROUND(
        SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(o.order_id), 0) * 100
    , 1)       AS return_rate_pct

FROM dataco.orders o
GROUP BY
    o.shipping_mode,
    o.carrier,
    o.market,
    o.order_region,
    o.delivery_status;

SELECT
    shipping_mode,
    SUM(total_orders)                                               AS total_orders,
    SUM(late_orders)                                                AS late_orders,
    ROUND(
        SUM(late_orders)::NUMERIC / NULLIF(SUM(total_orders),0) * 100
    , 1)                                                            AS late_rate_pct,
    ROUND(AVG(avg_freight_cost), 2)                                AS avg_freight
FROM dataco.vw_delivery_performance
GROUP BY shipping_mode
ORDER BY late_rate_pct DESC;