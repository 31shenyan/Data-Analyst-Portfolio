SELECT
  o.order_id,
  o.order_status,
  o.order_purchase_timestamp,
  c.customer_city,
  c.customer_state,
  i.price,
  p.product_category_name,
  t.product_category_name_english,
  s.seller_city,
  rev.review_score,
  pay.payment_type,
  pay.payment_value
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c 
  ON o.customer_id = c.customer_id
LEFT JOIN olist_order_items_dataset i 
  ON o.order_id = i.order_id
LEFT JOIN olist_products_dataset p 
  ON i.product_id = p.product_id
LEFT JOIN olist_sellers_dataset s 
  ON i.seller_id = s.seller_id
LEFT JOIN olist_order_reviews_dataset rev 
  ON o.order_id = rev.order_id
LEFT JOIN olist_order_payments_dataset pay 
  ON o.order_id = pay.order_id
LEFT JOIN product_category_name_translation t 
  ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered';