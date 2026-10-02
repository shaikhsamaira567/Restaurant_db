drop database if exists restaurant_db;
create database restaurant_db;
use restaurant_db;


CREATE TABLE restaurants (
    restaurant_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255),
    address TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);


CREATE TABLE categories (
    category_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255)
);


CREATE TABLE dishes (
    dish_id CHAR(36) PRIMARY KEY,
    restaurant_id CHAR(36),
    category_id CHAR(36),
    name VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_dishes_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    CONSTRAINT fk_dishes_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


CREATE TABLE variants (
    variant_id CHAR(36) PRIMARY KEY,
    dish_id CHAR(36),
    size VARCHAR(50),
    price DECIMAL(10,2),
    attributes VARCHAR(255),

    CONSTRAINT fk_variants_dish
        FOREIGN KEY (dish_id)
        REFERENCES dishes(dish_id)
);


CREATE TABLE inventory (
    id CHAR(36) PRIMARY KEY,
    restaurant_id CHAR(36),
    dish_id CHAR(36),
    available_qty DECIMAL(10,2),
    threshold_qty DECIMAL(10,2),

    CONSTRAINT fk_inventory_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    CONSTRAINT fk_inventory_dish
        FOREIGN KEY (dish_id)
        REFERENCES dishes(dish_id)
);


CREATE TABLE orders (
    order_id CHAR(36) PRIMARY KEY,
    user_id CHAR(36),
    restaurant_id CHAR(36),
    total_price DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP,

    CONSTRAINT fk_orders_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);


CREATE TABLE order_items (
    id CHAR(36) PRIMARY KEY,
    order_id CHAR(36),
    dish_id CHAR(36),
    variant_id CHAR(36),
    quantity INT,
    price DECIMAL(10,2),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_dish
        FOREIGN KEY (dish_id)
        REFERENCES dishes(dish_id),

    CONSTRAINT fk_order_items_variant
        FOREIGN KEY (variant_id)
        REFERENCES variants(variant_id)
);