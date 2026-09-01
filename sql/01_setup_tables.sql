CREATE TABLE orders (
    order_id INTEGER,
    user_id INTEGER,
    eval_set VARCHAR(10),
    order_number INTEGER,
    order_dow INTEGER,
    order_hour_of_day INTEGER,
    days_since_prior_order NUMERIC
);

CREATE TABLE order_products (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER
);

CREATE TABLE products (
    product_id INTEGER,
    product_name TEXT,
    aisle TEXT,
    department TEXT
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_order ON orders(order_id);
CREATE INDEX idx_op_order ON order_products(order_id);
CREATE INDEX idx_op_product ON order_products(product_id);