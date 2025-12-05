/*
   SQL Assessment – Solutions
   Author: Harshit Mohan(BTECH/10588/22)
   College: Birla Institute of Technology, Mesra
   Note: All queries are written for MySQL 8.4.0
*/

/*
   Assumptions
   
   1. A NULL value in refund_time indicates that the order was not refunded.
   2. “First order” for a store or buyer is identified using the earliest purchase_time.
   3. The dataset available in the screenshots is considered complete.
   4. MySQL window functions are used wherever they simplify logic.
*/


/* Q1. Monthly purchase counts (excluding refunded transactions) */

SELECT 
    DATE_FORMAT(purchase_time, '%Y-%m') AS month,
    COUNT(*) AS total_purchases
FROM transactions
WHERE refund_time IS NULL
GROUP BY DATE_FORMAT(purchase_time, '%Y-%m')
ORDER BY month;


/* Q2. Number of stores that recorded 5 or more orders in Oct 2020 */

SELECT COUNT(*) AS stores_with_min_five_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM transactions
    WHERE purchase_time >= '2020-10-01'
      AND purchase_time < '2020-11-01'
    GROUP BY store_id
    HAVING COUNT(*) >= 5
) AS store_summary;


/* Q3. Minimum purchase-to-refund time difference (in minutes) computed per store */

SELECT
    store_id,
    MIN(TIMESTAMPDIFF(MINUTE, purchase_time, refund_time)) AS min_refund_interval_min
FROM transactions
WHERE refund_time IS NOT NULL
GROUP BY store_id;


/* Q4. Gross transaction value for the first order made at each store */

WITH ranked_orders AS (
    SELECT
        store_id,
        gross_transaction_value,
        ROW_NUMBER() OVER (PARTITION BY store_id ORDER BY purchase_time) AS order_rank
    FROM transactions
)
SELECT store_id, gross_transaction_value
FROM ranked_orders
WHERE order_rank = 1;


/* Q5. Most commonly purchased item on a buyer's first order */

WITH first_buy AS (
    SELECT
        buyer_id,
        item_id,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
    FROM transactions
)
SELECT i.item_name, COUNT(*) AS times_ordered
FROM first_buy fb
JOIN items i ON fb.item_id = i.item_id
WHERE fb.rn = 1
GROUP BY i.item_name
ORDER BY times_ordered DESC
LIMIT 1;


/* Q6. Flag indicating whether a refund is eligible for processing (refund must occur within 72 hours of purchase) */

SELECT
    t.*,
    CASE 
        WHEN refund_time IS NOT NULL
             AND TIMESTAMPDIFF(HOUR, purchase_time, refund_time) <= 72
        THEN 1
        ELSE 0
    END AS refund_eligible
FROM transactions t;


/* Q7. Retrieve only the second successful purchase for every buyer (refunds excluded) */

WITH buyer_order_rank AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
    FROM transactions
    WHERE refund_time IS NULL
)
SELECT *
FROM buyer_order_rank
WHERE rn = 2;


/* Q8. Extract the timestamp of the second transaction per buyer without using min or max functions */

WITH seq AS (
    SELECT
        buyer_id,
        purchase_time,
        ROW_NUMBER() OVER (PARTITION BY buyer_id ORDER BY purchase_time) AS rn
    FROM transactions
)
SELECT buyer_id, purchase_time
FROM seq
WHERE rn = 2;


/* END OF FILE */
