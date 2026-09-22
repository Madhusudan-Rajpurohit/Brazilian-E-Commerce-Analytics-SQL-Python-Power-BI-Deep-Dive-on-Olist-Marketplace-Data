# Data Cleaning Notes (Excel Phase)

Validation performed on all 9 raw source files before loading into MySQL:

| File | Finding |
|---|---|
| `olist_customers_dataset.csv` | No duplicate values |
| `olist_geolocation_dataset.csv` | 24,924 rows cleaned — `são paulo` standardized to `sao paulo`. Duplicate rows retained: multiple people/orders can share the same city and zip prefix, so these are legitimate, not data errors |
| `olist_order_items_dataset.csv` | No duplicate values |
| `olist_order_payments_dataset.csv` | No duplicate values |
| `olist_order_reviews_dataset.csv` | No duplicate values |
| `olist_orders_dataset.csv` | No duplicate values |
| `olist_products_dataset.csv` | No duplicate values |
| `olist_sellers_dataset.csv` | No duplicate values |
| `product_category_name_translation.csv` | No duplicate values |

# Data Dictionary

### 1. Customers (`olist_customers_dataset.csv`)
Ties customer accounts to geographic locations and identity keys.
- `customer_id` — key joining to each order (unique per order)
- `customer_unique_id` — unique identifier for the actual customer (tracks repeat purchasers)
- `customer_zip_code_prefix` — first 5 digits of zip code
- `customer_city`, `customer_state`

### 2. Geolocation (`olist_geolocation_dataset.csv`)
Spatial coordinates for mapping logistics and shipping hubs.
- `geolocation_zip_code_prefix`, `geolocation_lat`, `geolocation_lng`, `geolocation_city`, `geolocation_state`

### 3. Order Items (`olist_order_items_dataset.csv`)
Line items within each order.
- `order_id`, `order_item_id` (sequential line number)
- `product_id`, `seller_id`
- `shipping_limit_date` — merchant fulfillment deadline
- `price`, `freight_value`

### 4. Order Payments (`olist_order_payments_dataset.csv`)
- `order_id`, `payment_sequential` (index if multiple payment methods used)
- `payment_type` (credit_card, boleto, voucher, debit_card)
- `payment_installments`, `payment_value`

### 5. Order Reviews (`olist_order_reviews_dataset.csv`)
- `review_id`, `order_id`
- `review_score` (1–5)
- `review_comment_title`, `review_comment_message`
- `review_creation_date`, `review_answer_timestamp`

### 6. Orders (`olist_orders_dataset.csv`)
Central logistical master record.
- `order_id`, `customer_id`
- `order_status` (delivered, shipped, canceled, invoiced, ...)
- `order_purchase_timestamp`, `order_approved_at`
- `order_delivered_carrier_date`, `order_delivered_customer_date`
- `order_estimated_delivery_date`

### 7. Products (`olist_products_dataset.csv`)
- `product_id`, `product_category_name` (Portuguese)
- `product_name_lenght`, `product_description_lenght`, `product_photos_qty`
- `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm`

### 8. Sellers (`olist_sellers_dataset.csv`)
- `seller_id`, `seller_zip_code_prefix`, `seller_city`, `seller_state`

### 9. Category Name Translation (`product_category_name_translation.csv`)
- `product_category_name` (Portuguese) → `product_category_name_english`
