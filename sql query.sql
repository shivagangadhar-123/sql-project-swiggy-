SELECT COUNT(*) AS name
FROM swiggy;

SELECT COUNT(DISTINCT city) AS total_cities
FROM swiggy;

SELECT DISTINCT rating
FROM swiggy
ORDER BY rating;

SELECT DISTINCT cost
FROM swiggy
ORDER BY cost;

SELECT DISTINCT rating_count
FROM swiggy
LIMIT 25;

SELECT
    SUM(CASE WHEN id IS NULL OR id = '' THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN name IS NULL OR name = '' THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS missing_rating,
    SUM(CASE WHEN cuisine IS NULL OR cuisine = '' THEN 1 ELSE 0 END) AS missing_cuisine
FROM swiggy;

SELECT
    id,
    name,
    city,
    CASE
        WHEN rating = '--' OR rating = '' OR rating IS NULL THEN NULL
        ELSE CAST(rating AS DECIMAL(3,1))
    END AS rating_numeric,
    rating_count,
    CAST(
        REPLACE(
            REPLACE(
                REPLACE(cost, 'INR ', ''),
                'Rs. ',
                ''
            ),
            ',',
            ''
        ) AS UNSIGNED
    ) AS cost_numeric,
    cuisine,
    lic_no,
    link,
    address,
    menu
FROM swiggy;

SELECT
    city,
    COUNT(*) AS restaurant_count
FROM swiggy
GROUP BY city
ORDER BY restaurant_count DESC;

SELECT
    city,
    COUNT(*) AS rated_restaurants,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS average_rating
FROM swiggy
WHERE rating IS NOT NULL
  AND rating <> '--'
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC;

SELECT
    COUNT(*) AS restaurants_without_rating
FROM swiggy
WHERE rating IS NULL
   OR rating = '--'
   OR rating = '';
   
   SELECT
    cuisine,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE cuisine IS NOT NULL
  AND cuisine <> ''
GROUP BY cuisine
ORDER BY restaurant_count DESC
Limit 20;

SELECT
    city,
    COUNT(*) AS total_restaurants
FROM swiggy
GROUP BY city
ORDER BY total_restaurants DESC
LIMIT 10;

SELECT
    name,
    city,
    CAST(rating AS REAL) AS rating,
    rating_count,
    cuisine
FROM swiggy
WHERE rating IS NOT NULL
  AND rating <> '--'
ORDER BY rating DESC
LIMIT 20;

SELECT
    name,
    city,
    rating,
    rating_count,
    cost_numeric,
    cuisine
FROM (
    SELECT
        name,
        city,
        CASE
            WHEN rating = '--' OR rating = '' OR rating IS NULL THEN NULL
            ELSE CAST(rating AS DECIMAL(3,1))
        END AS rating,
        rating_count,
        CAST(
            REPLACE(
                REPLACE(
                    REPLACE(cost, 'INR ', ''),
                    'Rs. ',
                    ''
                ),
                ',',
                ''
            ) AS UNSIGNED
        ) AS cost_numeric,
        cuisine
    FROM swiggy
) AS cleaned_swiggy
WHERE rating >= 4.0
  AND rating_count IS NOT NULL
  AND rating_count != ''
ORDER BY rating DESC, CAST(REPLACE(rating_count, '+', '') AS UNSIGNED) DESC
LIMIT 10;
USE swiggy_db;

SELECT
    city,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS average_rating,
    COUNT(*) AS rated_restaurants
FROM swiggy
WHERE rating <> '--'
  AND rating IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 10
ORDER BY average_rating DESC;

SELECT
    CASE
        WHEN CAST(REPLACE(REPLACE(REPLACE(cost, 'INR ', ''), 'Rs. ', ''), ',', '') AS UNSIGNED) < 200 THEN 'Budget: below INR 200'
        WHEN CAST(REPLACE(REPLACE(REPLACE(cost, 'INR ', ''), 'Rs. ', ''), ',', '') AS UNSIGNED) BETWEEN 200 AND 399 THEN 'Mid-range: INR 200-399'
        WHEN CAST(REPLACE(REPLACE(REPLACE(cost, 'INR ', ''), 'Rs. ', ''), ',', '') AS UNSIGNED) BETWEEN 400 AND 599 THEN 'Premium: INR 400-599'
        ELSE 'Luxury: INR 600 and above'
    END AS price_segment,
    COUNT(*) AS restaurant_count
FROM swiggy
WHERE cost IS NOT NULL AND cost != ''
GROUP BY price_segment
ORDER BY restaurant_count DESC;

SELECT
    city,
    COUNT(DISTINCT cuisine) AS cuisine_listing_count
FROM swiggy
WHERE cuisine IS NOT NULL
  AND cuisine <> ''
GROUP BY city
ORDER BY cuisine_listing_count DESC
LIMIT 10;

SELECT
    name,
    city,
    cost,
    rating,
    cuisine
FROM swiggy
WHERE cost IS NOT NULL 
  AND cost != '' 
  AND cost != '--'
ORDER BY CAST(REPLACE(REPLACE(REPLACE(cost, 'INR ', ''), 'Rs. ', ''), ',', '') AS UNSIGNED) ASC
LIMIT 20;


SELECT
    CASE
        WHEN rating = '--' OR rating IS NULL THEN 'Not rated'
        WHEN CAST(rating AS REAL) < 3.0 THEN 'Below 3.0'
        WHEN CAST(rating AS REAL) < 4.0 THEN '3.0 to 3.9'
        WHEN CAST(rating AS REAL) < 4.5 THEN '4.0 to 4.4'
        ELSE '4.5 and above'
    END AS rating_band,
    COUNT(*) AS restaurant_count
FROM swiggy
GROUP BY rating_band
ORDER BY restaurant_count DESC;

SELECT
    city,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(CAST(rating AS REAL)), 2) AS average_rating
FROM swiggy
WHERE rating IS NOT NULL
  AND rating <> '--'
GROUP BY city
HAVING COUNT(*) >= 25
   AND AVG(CAST(rating AS REAL)) >= 4.0
ORDER BY average_rating DESC, restaurant_count DESC;

SELECT
    cuisine,
    COUNT(*) AS listing_count
FROM swiggy
WHERE cuisine IS NOT NULL
  AND cuisine <> ''
GROUP BY cuisine
ORDER BY listing_count DESC
LIMIT 20;