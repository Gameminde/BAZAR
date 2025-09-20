-- BAZAR Marketplace - Sample Data for Development
-- Migration V2: Insert sample data for testing

-- Insert sample categories
INSERT INTO categories (name, slug, description, sort_order, is_active) VALUES
('Electronics', 'electronics', 'Electronic devices and gadgets', 1, true),
('Fashion', 'fashion', 'Clothing and accessories', 2, true),
('Home & Garden', 'home-garden', 'Home improvement and garden supplies', 3, true),
('Sports & Outdoors', 'sports-outdoors', 'Sports equipment and outdoor gear', 4, true),
('Books', 'books', 'Books and literature', 5, true);

-- Insert subcategories
INSERT INTO categories (parent_id, name, slug, description, sort_order, is_active) VALUES
(1, 'Smartphones', 'smartphones', 'Mobile phones and accessories', 1, true),
(1, 'Laptops', 'laptops', 'Laptops and computers', 2, true),
(1, 'Audio', 'audio', 'Headphones, speakers, and audio equipment', 3, true),
(2, 'Men''s Clothing', 'mens-clothing', 'Clothing for men', 1, true),
(2, 'Women''s Clothing', 'womens-clothing', 'Clothing for women', 2, true),
(2, 'Shoes', 'shoes', 'Footwear for all', 3, true);

-- Insert sample users
INSERT INTO users (email, password_hash, first_name, last_name, phone, is_active, is_verified, email_verified_at) VALUES
('admin@bazar.dz', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfEpb.KMYq5/Oi6', 'Admin', 'User', '+213555000001', true, true, CURRENT_TIMESTAMP),
('john.doe@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfEpb.KMYq5/Oi6', 'John', 'Doe', '+213555000002', true, true, CURRENT_TIMESTAMP),
('jane.smith@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfEpb.KMYq5/Oi6', 'Jane', 'Smith', '+213555000003', true, true, CURRENT_TIMESTAMP),
('ahmed.benali@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfEpb.KMYq5/Oi6', 'Ahmed', 'Benali', '+213555000004', true, true, CURRENT_TIMESTAMP),
('fatima.khadra@email.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfEpb.KMYq5/Oi6', 'Fatima', 'Khadra', '+213555000005', true, true, CURRENT_TIMESTAMP);

-- Insert sample addresses
INSERT INTO user_addresses (user_id, type, first_name, last_name, address_line_1, city, postal_code, country, is_default) VALUES
(2, 'shipping', 'John', 'Doe', '123 Rue Didouche Mourad', 'Algiers', '16000', 'DZ', true),
(2, 'billing', 'John', 'Doe', '123 Rue Didouche Mourad', 'Algiers', '16000', 'DZ', true),
(3, 'shipping', 'Jane', 'Smith', '456 Boulevard Mohamed V', 'Oran', '31000', 'DZ', true),
(4, 'shipping', 'Ahmed', 'Benali', '789 Avenue de l''Indépendance', 'Constantine', '25000', 'DZ', true),
(5, 'shipping', 'Fatima', 'Khadra', '321 Rue des Martyrs', 'Annaba', '23000', 'DZ', true);

-- Insert sample products
INSERT INTO products (category_id, sku, name, slug, short_description, description, price, compare_price, stock_quantity, status, visibility, featured, tags) VALUES
-- Smartphones
(7, 'SM-001', 'Samsung Galaxy S23', 'samsung-galaxy-s23', 'Latest Samsung flagship smartphone', 'The Samsung Galaxy S23 features a stunning display, powerful processor, and advanced camera system.', 85000.00, 95000.00, 50, 'active', 'visible', true, ARRAY['smartphone', 'samsung', 'android', 'flagship']),
(7, 'IP-001', 'iPhone 14 Pro', 'iphone-14-pro', 'Apple iPhone with Pro features', 'Experience the power of A16 Bionic chip with iPhone 14 Pro. Advanced camera system and Dynamic Island.', 120000.00, 130000.00, 30, 'active', 'visible', true, ARRAY['smartphone', 'apple', 'iphone', 'pro']),
(7, 'XM-001', 'Xiaomi Redmi Note 12', 'xiaomi-redmi-note-12', 'Affordable smartphone with great features', 'Xiaomi Redmi Note 12 offers excellent value with good camera, battery life, and performance.', 35000.00, 40000.00, 100, 'active', 'visible', false, ARRAY['smartphone', 'xiaomi', 'budget', 'android']),

-- Laptops
(8, 'LP-001', 'MacBook Air M2', 'macbook-air-m2', 'Apple MacBook Air with M2 chip', 'Ultra-thin and light laptop with Apple M2 chip, perfect for productivity and creativity.', 150000.00, 160000.00, 25, 'active', 'visible', true, ARRAY['laptop', 'apple', 'macbook', 'm2']),
(8, 'LP-002', 'Dell XPS 13', 'dell-xps-13', 'Premium Windows laptop', 'Dell XPS 13 with Intel Core i7, stunning display, and premium build quality.', 110000.00, 120000.00, 40, 'active', 'visible', false, ARRAY['laptop', 'dell', 'windows', 'premium']),
(8, 'LP-003', 'ASUS ROG Gaming Laptop', 'asus-rog-gaming', 'High-performance gaming laptop', 'ASUS ROG laptop with RTX graphics, perfect for gaming and content creation.', 180000.00, 200000.00, 15, 'active', 'visible', true, ARRAY['laptop', 'asus', 'gaming', 'rtx']),

-- Audio
(9, 'AU-001', 'Sony WH-1000XM4', 'sony-wh-1000xm4', 'Premium noise-cancelling headphones', 'Industry-leading noise cancellation with premium sound quality and comfort.', 45000.00, 50000.00, 60, 'active', 'visible', true, ARRAY['headphones', 'sony', 'wireless', 'noise-cancelling']),
(9, 'AU-002', 'AirPods Pro 2nd Gen', 'airpods-pro-2', 'Apple AirPods Pro with advanced features', 'Active Noise Cancellation, Transparency mode, and spatial audio.', 35000.00, 40000.00, 80, 'active', 'visible', false, ARRAY['earbuds', 'apple', 'wireless', 'pro']),

-- Men's Clothing
(10, 'MC-001', 'Classic Cotton T-Shirt', 'classic-cotton-tshirt', 'Comfortable cotton t-shirt', 'High-quality cotton t-shirt in various colors, perfect for everyday wear.', 2500.00, 3000.00, 200, 'active', 'visible', false, ARRAY['tshirt', 'cotton', 'casual', 'men']),
(10, 'MC-002', 'Denim Jeans', 'denim-jeans', 'Classic blue denim jeans', 'Comfortable and durable denim jeans with modern fit.', 6500.00, 7500.00, 150, 'active', 'visible', false, ARRAY['jeans', 'denim', 'casual', 'men']),

-- Women's Clothing
(11, 'WC-001', 'Elegant Summer Dress', 'elegant-summer-dress', 'Beautiful dress for summer', 'Lightweight and elegant dress perfect for summer occasions.', 8500.00, 10000.00, 75, 'active', 'visible', true, ARRAY['dress', 'summer', 'elegant', 'women']),
(11, 'WC-002', 'Professional Blazer', 'professional-blazer', 'Stylish blazer for work', 'Professional blazer that combines style and comfort for the modern woman.', 12000.00, 15000.00, 50, 'active', 'visible', false, ARRAY['blazer', 'professional', 'formal', 'women']);

-- Insert product images
INSERT INTO product_images (product_id, url, alt_text, sort_order, is_primary) VALUES
-- Samsung Galaxy S23
(1, 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=500', 'Samsung Galaxy S23 front view', 1, true),
(1, 'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=500', 'Samsung Galaxy S23 back view', 2, false),

-- iPhone 14 Pro
(2, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500', 'iPhone 14 Pro front view', 1, true),
(2, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500', 'iPhone 14 Pro back view', 2, false),

-- Xiaomi Redmi Note 12
(3, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500', 'Xiaomi Redmi Note 12', 1, true),

-- MacBook Air M2
(4, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500', 'MacBook Air M2', 1, true),

-- Dell XPS 13
(5, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500', 'Dell XPS 13', 1, true),

-- ASUS ROG Gaming Laptop
(6, 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500', 'ASUS ROG Gaming Laptop', 1, true),

-- Sony WH-1000XM4
(7, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'Sony WH-1000XM4 Headphones', 1, true),

-- AirPods Pro 2nd Gen
(8, 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500', 'AirPods Pro 2nd Gen', 1, true),

-- Classic Cotton T-Shirt
(9, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', 'Classic Cotton T-Shirt', 1, true),

-- Denim Jeans
(10, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500', 'Denim Jeans', 1, true),

-- Elegant Summer Dress
(11, 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=500', 'Elegant Summer Dress', 1, true),

-- Professional Blazer
(12, 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=500', 'Professional Blazer', 1, true);

-- Insert sample carts (for testing)
INSERT INTO carts (user_id, currency) VALUES
(2, 'DZD'),
(3, 'DZD'),
(4, 'DZD');

-- Insert sample cart items
INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 85000.00, 85000.00),
(1, 7, 1, 45000.00, 45000.00),
(2, 4, 1, 150000.00, 150000.00),
(3, 9, 2, 2500.00, 5000.00),
(3, 10, 1, 6500.00, 6500.00);

-- Insert sample order
INSERT INTO orders (
    order_number, user_id, email, phone, status, payment_status, fulfillment_status,
    subtotal, tax_amount, shipping_amount, total_amount, currency,
    shipping_address, billing_address, shipping_method
) VALUES (
    'ORD-2024-0001', 2, 'john.doe@email.com', '+213555000002',
    'confirmed', 'paid', 'unfulfilled',
    85000.00, 8500.00, 1500.00, 95000.00, 'DZD',
    '{"first_name":"John","last_name":"Doe","address_line_1":"123 Rue Didouche Mourad","city":"Algiers","postal_code":"16000","country":"DZ"}',
    '{"first_name":"John","last_name":"Doe","address_line_1":"123 Rue Didouche Mourad","city":"Algiers","postal_code":"16000","country":"DZ"}',
    'Standard Shipping'
);

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, product_sku, product_name, quantity, unit_price, total_price) VALUES
(1, 1, 'SM-001', 'Samsung Galaxy S23', 1, 85000.00, 85000.00);

-- Update sequences to avoid conflicts
SELECT setval('users_id_seq', 100);
SELECT setval('categories_id_seq', 100);
SELECT setval('products_id_seq', 100);
SELECT setval('carts_id_seq', 100);
SELECT setval('orders_id_seq', 100);
