
CREATE DATABASE marketingdb;
USE marketingdb;


CREATE TABLE campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    launch_date DATE NOT NULL
);


CREATE TABLE email_opens (
    open_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    campaign_id INT NOT NULL,
    open_time DATETIME NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);


CREATE TABLE conversions (
    conversion_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    campaign_id INT NOT NULL,
    conversion_time DATETIME NOT NULL,
    revenue DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

INSERT INTO campaigns (campaign_name, launch_date) VALUES
('Summer Sale', '2023-06-01'),
('Winter Deals', '2023-12-01'),
('Spring Promo', '2024-03-15');


INSERT INTO email_opens (user_id, campaign_id, open_time) VALUES
(101, 1, '2023-06-01 09:15:00'),
(102, 1, '2023-06-01 10:30:00'),
(103, 1, '2023-06-01 14:20:00'),
(101, 2, '2023-12-01 08:45:00'),
(104, 2, '2023-12-01 09:10:00'),
(105, 2, '2023-12-01 16:00:00'),
(106, 3, '2024-03-15 11:45:00'),
(107, 3, '2024-03-15 12:30:00');


INSERT INTO conversions (user_id, campaign_id, conversion_time, revenue) VALUES
(101, 1, '2023-06-01 09:45:00', 120.00),
(102, 1, '2023-06-01 11:00:00', 200.00),
(104, 2, '2023-12-01 09:40:00', 150.00),
(105, 2, '2023-12-01 16:30:00', 300.00),
(107, 3, '2024-03-15 13:00:00', 250.00),
(108, 3, '2024-03-15 14:10:00', 400.00);



--   Q1. Open rate for each campaign
  
SELECT c.campaign_id, 
       c.campaign_name,
       COUNT(DISTINCT e.user_id) * 100.0 / COUNT(DISTINCT conv.user_id) AS open_rate
FROM campaigns c
LEFT JOIN email_opens e ON c.campaign_id = e.campaign_id
LEFT JOIN conversions conv ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name;



-- Q2. Conversion rate per campaign

SELECT c.campaign_id, 
       c.campaign_name,
       COUNT(DISTINCT conv.user_id) * 100.0 / COUNT(DISTINCT eo.user_id) AS conversion_rate
FROM campaigns c
LEFT JOIN email_opens eo ON c.campaign_id = eo.campaign_id
LEFT JOIN conversions conv ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name;


   -- Q3. Revenue per campaign

SELECT c.campaign_id, 
       c.campaign_name,
       COALESCE(SUM(conv.revenue),0) AS total_revenue
FROM campaigns c
LEFT JOIN conversions conv ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name;



  -- Q4. Campaign with the highest ROI (Assume estimated cost = 1000 per campaign)

SELECT c.campaign_id, 
       c.campaign_name,
       SUM(conv.revenue) / 1000 AS ROI
FROM campaigns c
LEFT JOIN conversions conv ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name
ORDER BY ROI DESC
LIMIT 1;



-- Q5. Users who opened but didn’t convert (drop-off rate)
   
SELECT c.campaign_id,
       c.campaign_name,
       COUNT(DISTINCT eo.user_id) - COUNT(DISTINCT conv.user_id) AS drop_off_users
FROM campaigns c
LEFT JOIN email_opens eo ON c.campaign_id = eo.campaign_id
LEFT JOIN conversions conv 
       ON c.campaign_id = conv.campaign_id 
      AND eo.user_id = conv.user_id
GROUP BY c.campaign_id, c.campaign_name;



   -- Q6. Time of day with highest open rate

SELECT HOUR(open_time) AS hour_of_day,
       COUNT(*) AS open_count
FROM email_opens
GROUP BY HOUR(open_time)
ORDER BY open_count DESC
LIMIT 1;



   -- Q7. Average time between open and conversion (minutes)
  
SELECT c.campaign_id,
       c.campaign_name,
       AVG(TIMESTAMPDIFF(MINUTE, eo.open_time, conv.conversion_time)) AS avg_minutes_to_convert
FROM campaigns c
JOIN email_opens eo ON c.campaign_id = eo.campaign_id
JOIN conversions conv 
     ON eo.user_id = conv.user_id 
    AND eo.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name;



  -- Q8. Users who converted without opening

SELECT DISTINCT conv.user_id, conv.campaign_id
FROM conversions conv
LEFT JOIN email_opens eo 
       ON conv.user_id = eo.user_id 
      AND conv.campaign_id = eo.campaign_id
WHERE eo.user_id IS NULL;



   -- Q9. Campaign with the fastest conversion after opening

SELECT c.campaign_id, 
       c.campaign_name,
       MIN(TIMESTAMPDIFF(MINUTE, eo.open_time, conv.conversion_time)) AS fastest_conversion_minutes
FROM campaigns c
JOIN email_opens eo ON c.campaign_id = eo.campaign_id
JOIN conversions conv 
     ON eo.user_id = conv.user_id 
    AND eo.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name
ORDER BY fastest_conversion_minutes ASC
LIMIT 1;



 --  Q10. Average revenue per conversion per campaign

SELECT c.campaign_id, 
       c.campaign_name,
       AVG(conv.revenue) AS avg_revenue_per_conversion
FROM campaigns c
JOIN conversions conv ON c.campaign_id = conv.campaign_id
GROUP BY c.campaign_id, c.campaign_name;
