## **Evaluating Traffic Sources**

### **Business Concept: Analyzing Traffic Origins**
Understanding where your customers come from and which channels drive the highest quality traffic is crucial for business success.

### **Common Use Cases: Traffic Source Analysis**
- Analyzing search data to reallocate budget towards the most effective engines, campaigns, or keywords
- Comparing user behavior across different traffic sources to refine creative and messaging strategies
- Identifying opportunities to cut unnecessary spending or enhance high-converting traffic

### **Task**
### **1. Identifying Leading Traffic Sources**

<p align="center">
  <kbd><img width="330" alt="email1_1" src="https://user-images.githubusercontent.com/115857221/216097426-509b18d3-7fc6-4bc2-ba07-fff86f586ee3.png"> </kbd> <br>
</p>
<br>

**Steps :**
- Break down sessions by UTM source, campaign, and referring domain
- Filter results to include only sessions before **'2012-04-12'** and group by **utm_source**, **utm_campaign**, and **http_referer**
<br>

**Query :**
```sql
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS session_count
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY session_count DESC;
```
<br>

**Result :**
<p align="center">
  <kbd> <img width="500" alt="tabel_top_traffic" src="https://user-images.githubusercontent.com/115857221/216097751-9cf81722-0923-48ce-87cb-67c4c43e1a15.png"> </kbd> <br>
 
  1 — The majority of sessions originated from the gsearch nonbrand campaign. Explore optimization opportunities for this traffic.
</p>

<br>

<p align="center">
  <kbd><img width="330" alt="email1_2" src="https://user-images.githubusercontent.com/115857221/216097918-e6348a69-05b2-4e59-8ad6-b754076673e9.png"> <br>
</p>
<br>

### **2. Calculating Traffic Conversion Rate**

<p align="center">
  <kbd><img width="330" alt="email1_3" src="https://user-images.githubusercontent.com/115857221/216098062-374ab27d-37be-4de3-b002-d1a1767b17d6.png"> </kbd> <br>
</p>
<br>

**Steps :**
- Calculate the conversion rate (CVR) from session counts to order counts. Adjust bids if CVR is less than 4%; otherwise, increase bids to drive more volume.
- Filter sessions **< '2012-04-14'**, **utm_source = 'gsearch'**, and **utm_campaign = 'nonbrand'**
<br>

**Query :**
```sql
SELECT
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_order_CVR
FROM website_sessions w
LEFT JOIN orders o
    ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-04-14'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand';
```
<br>

**Result :**
<p align="center">
  <kbd><img width="380" alt="tabel_traffic_cvr" src="https://user-images.githubusercontent.com/115857221/216098251-06f32653-8c9c-478a-83f5-0d286efbdb70.png"> </kbd> <br>
  
  2 — The conversion rate is 2.88%, which is below the 4% threshold, indicating a need to reduce bids. Monitor the impact of bid adjustments and analyze performance trends by device type.
</p>

<br>

<p align="center">
  <kbd><img width="330" alt="email1_4" src="https://user-images.githubusercontent.com/115857221/216098576-b5d77b1b-b1b6-4036-9196-b5828c308a9d.png"> </kbd> <br>
</p>
<br>

### 📌 **Business Concept: Optimizing Bids**
Bid optimization involves understanding the value of different segments of paid traffic to make the most of your marketing budget.

### 📌 **Common Use Cases: Bid Optimization**
- Analyzing conversion rates and revenue per click to determine optimal spend per click
- Assessing performance across various traffic subsegments (e.g., mobile vs. desktop) to refine channel strategies
- Evaluating the impact of bid changes on auction rankings and customer volume<br>
<br>

### **3. Analyzing Traffic Source Trends**

<p align="center">
  <kbd> <img width="330" alt="email1_5" src="https://user-images.githubusercontent.com/115857221/216099554-e346086f-ed31-424a-9228-a312830672ba.png"> </kbd> <br>
</p>
<br>

**Steps :**
- Analyze session trends and the impact of bid reductions for the gsearch nonbrand campaign starting April 15, 2021
- Filter to **< '2012-05-10'**, **utm_source = 'gsearch'**, **utm_campaign = 'nonbrand'**
<br>

**Query :**
```sql
SELECT
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS session_count
FROM website_sessions 
WHERE created_at < '2012-05-10'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at);
```
<br>

**Result :**
<p align="center">
  <kbd> <img width="230" alt="tabel_traffic_trending" src="https://user-images.githubusercontent.com/115857221/216099721-18749403-05ba-4a2c-b562-ed10076282e1.png"></kbd> <br>
  
  3 — Sessions dropped after April 15, 2021. Monitor session volume and adjust campaigns to maximize volume at the lowest possible bid.
</p>

<br>

<p align="center">
  <kbd><img width="330" alt="email1_6" src="https://user-images.githubusercontent.com/115857221/216099857-425a6456-57e6-4ab3-9b4a-62db953f5c98.png"> </kbd> <br>
</p>
<br>

### **4. Optimizing Bids by Traffic Source**

<p align="center">
  <kbd> <img width="330" alt="email1_7" src="https://user-images.githubusercontent.com/115857221/216099972-b8f55eb5-a1c6-4c5b-9d33-369544050738.png"> </kbd> <br>
</p>
<br>

**Steps :**
- Calculate the conversion rate from session to order by device type
<br>

**Query :**
```sql
SELECT
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_order_CVR
FROM website_sessions w
LEFT JOIN orders o
    ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-05-11'
    AND w.utm_source = 'gsearch'
    AND w.utm_campaign = 'nonbrand'
GROUP BY w.device_type
ORDER BY session_to_order_CVR DESC;
```
<br>

**Result :**
<p align="center">
  <kbd><img width="480" alt="tabel_bid_opz" src="https://user-images.githubusercontent.com/115857221/216100125-db73b60e-23b2-4491-9233-a72886b31827.png"> </kbd> <br>
  
  4 — Desktop traffic achieved nearly a 4% conversion rate. Shift paid traffic spend to the desktop channel for better returns.
</p>

<br>

<p align="center">
  <kbd> <img width="330" alt="email1_8" src="https://user-images.githubusercontent.com/115857221/216100248-c15d75af-7f7b-4dd5-8be9-9262689b9eb8.png"> </kbd> <br>
</p>
<br>

### **5. Segmenting Traffic Source Trends**

<p align="center">
  <kbd> <img width="330" alt="email1_9" src="https://user-images.githubusercontent.com/115857221/216100406-763878cb-f233-45a4-985c-7b95e8d3679f.png"> </kbd> <br>
</p>
<br>

**Steps :**
- Calculate weekly session trends for both desktop and mobile after increasing bids on the desktop channel on May 19, 2012
-

 Filter to sessions between **'2012-04-15' to '2012-06-19'**, **utm_source = 'gsearch'**, **utm_campaign = 'nonbrand'**
<br>

**Query :**
```sql
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
```
<br>

**Result :**
<p align="center">
  <kbd> <img width="405" alt="tabel_segm_tren" src="https://user-images.githubusercontent.com/115857221/216100559-cb7142a5-8022-4ad5-b183-ab005bc5212d.png"> </kbd> <br>
  
  5 — Desktop session volume increased after May 19, 2012, but mobile sessions dropped. Focus on desktop optimization while monitoring device-level performance to optimize spend.
</p>

<br>

<p align="center">
  <kbd> <img width="330" alt="email1_10" src="https://user-images.githubusercontent.com/115857221/216100702-a9f3a551-0558-48fe-a10e-76a07ab8445c.png"> </kbd> <br>
</p>
<br>