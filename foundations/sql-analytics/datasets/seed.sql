INSERT INTO customers (customer_id, first_name, last_name, email, country, signup_date) VALUES
(1, 'Alice', 'Martin', 'alice.martin@email.com', 'France', '2024-01-15'),
(2, 'Bob', 'Durand', 'bob.durand@email.com', 'France', '2024-02-10'),
(3, 'Claire', 'Bernard', 'claire.bernard@email.com', 'Belgium', '2024-03-05'),
(4, 'David', 'Petit', 'david.petit@email.com', 'France', '2024-03-18'),
(5, 'Emma', 'Robert', 'emma.robert@email.com', 'Germany', '2024-04-22'),
(6, 'Farid', 'Lamrani', 'farid.lamrani@email.com', 'Morocco', '2024-05-01'),
(7, 'Grace', 'Lopez', 'grace.lopez@email.com', 'Spain', '2024-05-15'),
(8, 'Hugo', 'Morel', 'hugo.morel@email.com', 'France', '2024-06-07');
(9, 'Isabelle', 'Roux', 'isabelle.roux@email.com', 'France', '2024-07-20');

INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Home'),
(3, 'Sports'),
(4, 'Books');

INSERT INTO products (product_id, product_name, category_id, unit_price, cost_price, created_at) VALUES
(101, 'Wireless Mouse', 1, 25.00, 12.00, '2024-01-01'),
(102, 'Mechanical Keyboard', 1, 80.00, 45.00, '2024-01-01'),
(103, 'USB-C Hub', 1, 45.00, 22.00, '2024-01-15'),
(104, 'Desk Lamp', 2, 35.00, 18.00, '2024-02-01'),
(105, 'Office Chair', 2, 150.00, 95.00, '2024-02-10'),
(106, 'Yoga Mat', 3, 30.00, 14.00, '2024-03-01'),
(107, 'Dumbbell Set', 3, 90.00, 55.00, '2024-03-10'),
(108, 'SQL for Analysts', 4, 40.00, 10.00, '2024-04-01');
(109, 'Laptop Stand', 1, 55.00, 25.00, '2024-05-01');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1001, 1, '2024-06-01', 'completed'),
(1002, 2, '2024-06-03', 'completed'),
(1003, 1, '2024-06-10', 'completed'),
(1004, 3, '2024-06-11', 'cancelled'),
(1005, 4, '2024-06-15', 'completed'),
(1006, 5, '2024-06-20', 'completed'),
(1007, 6, '2024-07-02', 'pending'),
(1008, 7, '2024-07-04', 'completed'),
(1009, 8, '2024-07-10', 'completed'),
(1010, 2, '2024-07-12', 'completed');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1001, 101, 2, 25.00),
(2, 1001, 108, 1, 40.00),

(3, 1002, 102, 1, 80.00),
(4, 1002, 103, 1, 45.00),

(5, 1003, 104, 2, 35.00),
(6, 1003, 101, 1, 25.00),

(7, 1004, 105, 1, 150.00),

(8, 1005, 106, 2, 30.00),
(9, 1005, 108, 1, 40.00),

(10, 1006, 105, 1, 150.00),
(11, 1006, 104, 1, 35.00),

(12, 1007, 107, 1, 90.00),

(13, 1008, 103, 2, 45.00),
(14, 1008, 106, 1, 30.00),

(15, 1009, 108, 2, 40.00),
(16, 1009, 101, 1, 25.00),

(17, 1010, 102, 1, 80.00),
(18, 1010, 105, 1, 150.00);

INSERT INTO payments (payment_id, order_id, payment_date, payment_method, amount) VALUES
(5001, 1001, '2024-06-01', 'card', 90.00),
(5002, 1002, '2024-06-03', 'paypal', 125.00),
(5003, 1003, '2024-06-10', 'card', 95.00),
(5004, 1004, '2024-06-11', 'card', 0.00),
(5005, 1005, '2024-06-15', 'paypal', 100.00),
(5006, 1006, '2024-06-20', 'bank_transfer', 185.00),
(5007, 1007, '2024-07-02', 'card', 90.00),
(5008, 1008, '2024-07-04', 'card', 120.00),
(5009, 1009, '2024-07-10', 'paypal', 105.00),
(5010, 1010, '2024-07-12', 'card', 230.00);