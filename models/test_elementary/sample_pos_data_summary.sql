SELECT
  store_name,
  customer_id,
  DATE_TRUNC('day', purchase_datetime) AS purchase_date,
  COUNT(*) AS total_items,
  SUM(price) AS total_amount
FROM {{ ref('sample_pos_data') }}
GROUP BY store_name, customer_id, DATE_TRUNC('day', purchase_datetime)