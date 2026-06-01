-- =============================================
-- Olist 巴西电商平台 SQL 分析脚本
-- 包含多表关联查询与窗口函数分析
-- =============================================

-- 1. 基础数据探索：订单-用户-商品-商家-评价-支付 全量关联
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


-- =============================================
-- 以下为进阶分析：使用窗口函数
-- =============================================

-- 2. 商家销售排名（使用 RANK 窗口函数）
-- 按商家销售额降序排列，选出 Top 10 头部商家
WITH seller_revenue AS (
  SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    SUM(i.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM olist_orders_dataset o
  JOIN olist_order_items_dataset i ON o.order_id = i.order_id
  JOIN olist_sellers_dataset s ON i.seller_id = s.seller_id
  WHERE o.order_status = 'delivered'
  GROUP BY s.seller_id, s.seller_city, s.seller_state
)
SELECT
  RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
  seller_id,
  seller_city,
  seller_state,
  total_revenue,
  order_count
FROM seller_revenue
ORDER BY revenue_rank
LIMIT 10;


-- 3. 月度销售趋势与环比增长率（使用 LAG 窗口函数）
-- 计算每月订单量，并对比上月变化幅度
WITH monthly_orders AS (
  SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(oi.price) AS total_revenue
  FROM olist_orders_dataset o
  JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
  ORDER BY order_month
)
SELECT
  order_month,
  order_count,
  total_revenue,
  LAG(order_count, 1) OVER (ORDER BY order_month) AS prev_month_orders,
  ROUND(
    (order_count - LAG(order_count, 1) OVER (ORDER BY order_month)) 
    * 100.0 / LAG(order_count, 1) OVER (ORDER BY order_month), 2
  ) AS mom_growth_pct
FROM monthly_orders
ORDER BY order_month;


-- 4. 品类销售排名与累计占比（使用 SUM OVER + NTILE）
-- 分析各品类对总销售额的贡献度，识别核心品类
WITH category_sales AS (
  SELECT
    p.product_category_name,
    t.product_category_name_english,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(i.price) AS total_revenue
  FROM olist_orders_dataset o
  JOIN olist_order_items_dataset i ON o.order_id = i.order_id
  JOIN olist_products_dataset p ON i.product_id = p.product_id
  JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
  WHERE o.order_status = 'delivered'
  GROUP BY p.product_category_name, t.product_category_name_english
),
category_ranked AS (
  SELECT
    product_category_name_english,
    order_count,
    total_revenue,
    SUM(total_revenue) OVER () AS grand_total,
    ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC) / SUM(total_revenue) OVER () * 100, 2) AS cum_pct
  FROM category_sales
)
SELECT
  ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS rank,
  product_category_name_english,
  order_count,
  total_revenue,
  cum_pct
FROM category_ranked
ORDER BY rank
LIMIT 15;


-- 5. 客户价值分层排名（使用 NTILE 窗口函数进行分位分组）
-- 将用户按消费金额分为 5 个等级，辅助 RFM 分析
WITH customer_spending AS (
  SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(pay.payment_value) AS total_spend
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
  JOIN olist_order_payments_dataset pay ON o.order_id = pay.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_id, c.customer_city, c.customer_state
)
SELECT
  customer_id,
  customer_city,
  customer_state,
  total_orders,
  total_spend,
  NTILE(5) OVER (ORDER BY total_spend DESC) AS spend_quintile,
  ROUND(total_spend / total_orders, 2) AS avg_order_value
FROM customer_spending
ORDER BY spend_quintile, total_spend DESC;
