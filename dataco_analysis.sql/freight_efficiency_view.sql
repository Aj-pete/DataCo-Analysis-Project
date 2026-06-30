CREATE OR REPLACE VIEW dataco.vw_freight_efficiency AS
SELECT
    o.carrier,
    o.shipping_mode,
    o.market,

    COUNT(o.order_id)               AS total_orders,
    SUM(o.late_delivery_risk)          AS late_orders,
    COUNT(o.order_id) - SUM(o.late_delivery_risk)  AS on_time_orders,

    ROUND(
        SUM(o.late_delivery_risk)::NUMERIC
        / NULLIF(COUNT(o.order_id), 0) * 100
    , 1)          AS late_rate_pct,

    ROUND(SUM(ABS(o.freight_cost_usd)), 2)           AS total_freight_spend,
    ROUND(AVG(ABS(o.freight_cost_usd)), 2)          AS avg_freight_per_order,

    ROUND(
        SUM(ABS(o.freight_cost_usd))
        / NULLIF(COUNT(o.order_id) - SUM(o.late_delivery_risk), 0)
    , 2)                                                            AS cost_per_ontime_delivery,

    ROUND(
        (
            SUM(ABS(o.freight_cost_usd))
            / NULLIF(COUNT(o.order_id) - SUM(o.late_delivery_risk), 0)
            - AVG(ABS(o.freight_cost_usd))
        )
        / NULLIF(AVG(ABS(o.freight_cost_usd)), 0) * 100
    , 1)    AS freight_waste_pct

FROM dataco.orders o
GROUP BY
    o.carrier,
    o.shipping_mode,
    o.market;

SELECT
    shipping_mode,
    SUM(total_orders)                       AS orders,
    ROUND(AVG(avg_freight_per_order), 2)    AS avg_freight,
    ROUND(AVG(cost_per_ontime_delivery), 2) AS cost_per_ontime,
    ROUND(AVG(freight_waste_pct), 1)        AS avg_waste_pct
FROM dataco.vw_freight_efficiency
GROUP BY shipping_mode
ORDER BY avg_waste_pct DESC;