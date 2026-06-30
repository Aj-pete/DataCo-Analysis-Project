CREATE OR REPLACE VIEW dataco.vw_monthly_trends AS
WITH monthly_base AS (
    SELECT
        TO_CHAR(o.order_date_dateorders::DATE, 'YYYY')      AS order_year,
        TO_CHAR(o.order_date_dateorders::DATE, 'MM')        AS order_month,
        TO_CHAR(o.order_date_dateorders::DATE, 'YYYY-MM')   AS year_month,

        COUNT(DISTINCT o.order_id)                          AS total_orders,
        SUM(o.late_delivery_risk)                           AS late_orders,
        SUM(ABS(o.freight_cost_usd))                        AS total_freight,
        SUM(CASE WHEN o.return_flag = 1 THEN 1 ELSE 0 END) AS total_returns,
        ROUND(SUM(oi.sales), 2)                            AS total_revenue,
        ROUND(SUM(oi.benefit_per_order), 2)                AS total_profit,

        ROUND(
            AVG(
                CASE
                    WHEN oi.customer_satisfaction_score BETWEEN 1 AND 5
                    THEN oi.customer_satisfaction_score
                    ELSE NULL
                END
            )
        , 2)         AS avg_satisfaction

    FROM dataco.orders o
        INNER JOIN dataco.order_items oi
            ON o.order_id = oi.order_id

    WHERE o.order_date_dateorders IS NOT NULL

    GROUP BY
        TO_CHAR(o.order_date_dateorders::DATE, 'YYYY'),
        TO_CHAR(o.order_date_dateorders::DATE, 'MM'),
        TO_CHAR(o.order_date_dateorders::DATE, 'YYYY-MM')
)

SELECT
    order_year,
    order_month,
    year_month,
    total_orders,
    late_orders,
    total_freight,
    total_returns,
    total_revenue,
    total_profit,
    avg_satisfaction,

    -- Derived rates
    ROUND(
        late_orders::NUMERIC / NULLIF(total_orders, 0) * 100
    , 1)           AS late_rate_pct,

    ROUND(
        total_returns::NUMERIC / NULLIF(total_orders, 0) * 100
    , 1)  AS return_rate_pct,

    ROUND(
        total_profit / NULLIF(total_revenue, 0) * 100
    , 1)  AS profit_margin_pct,

    
    ROUND(
        SUM(total_revenue) OVER (ORDER BY year_month)
    , 2)                     AS running_total_revenue,

    -- 
    LAG(total_revenue, 1) OVER (ORDER BY year_month)       AS prev_month_revenue,

    
    ROUND(
        (total_revenue - LAG(total_revenue, 1) OVER (ORDER BY year_month))
        / NULLIF(LAG(total_revenue, 1) OVER (ORDER BY year_month), 0) * 100
    , 1)            AS mom_revenue_change_pct,


    ROUND(
        AVG(total_revenue) OVER (
            ORDER BY year_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
    , 2)                                                    AS rolling_3m_avg_revenue,

    -- 
    RANK() OVER (ORDER BY total_revenue DESC)              AS revenue_rank

FROM monthly_base
ORDER BY year_month;

SELECT
    year_month,
    total_orders,
    total_revenue,
    mom_revenue_change_pct,
    running_total_revenue,
    late_rate_pct
FROM dataco.vw_monthly_trends
ORDER BY year_month
LIMIT 15;