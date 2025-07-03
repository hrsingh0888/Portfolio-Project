
-- Sample SQL to calculate KPIs from campaign data
SELECT
    campaign_id,
    channel,
    SUM(clicks) AS total_clicks,
    SUM(impressions) AS total_impressions,
    SUM(conversions) AS total_conversions,
    SUM(cost) AS total_cost,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 2) AS CTR,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS Conversion_Rate,
    ROUND(SUM(cost) / NULLIF(SUM(conversions), 0), 2) AS CPA
FROM marketing_campaign_data
GROUP BY campaign_id, channel;
