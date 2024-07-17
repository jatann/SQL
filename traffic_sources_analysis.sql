-- **************************
-- EVALUATING TRAFFIC ORIGINS
-- **************************
USE mavenfuzzyfactory;

-- 1. Identifying Leading Traffic Sources
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS session_count
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY session_count DESC;

-- 2. Calculating Traffic Conversion Ratio
SELECT
    COUNT(DISTINCT w.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM website_sessions w
LEFT JOIN orders o
    ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-04-14'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand';

-- 3. Analyzing Traffic Source Trends
SELECT
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS session_count
FROM website_sessions 
WHERE created_at < '2012-05-10'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at);

-- 4. Optimizing Bids Based on Traffic Source
SELECT
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS session_count,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS conversion_rate
FROM website_sessions w
LEFT JOIN orders o
    ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-05-11'
    AND w.utm_source = 'gsearch'
    AND w.utm_campaign = 'nonbrand'
GROUP BY w.device_type
ORDER BY conversion_rate DESC;

-- 5. Tracking Segment Trends in Traffic Source
SELECT
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions
WHERE created_at < '2012-06-09'
    AND created_at > '2012-04-15'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at);
