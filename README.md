<div align="center">

# 🍽️ Restaurant Ordering Database

### A normalized MySQL schema for restaurants, menus, inventory, and customer orders

![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Tables](https://img.shields.io/badge/Tables-7-orange?style=for-the-badge)
![Foreign Keys](https://img.shields.io/badge/Foreign%20Keys-9-blueviolet?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Beginner%20→%20Intermediate-brightgreen?style=for-the-badge)

</div>

---

## 📑 Table of Contents

- [✨ Overview](#-overview)
- [🗂️ Project Structure](#️-project-structure)
- [🧱 Database Design](#-database-design)
- [📚 Table Reference](#-table-reference)
- [🚀 Quick Start](#-quick-start)
- [🔍 Example Queries](#-example-queries)
- [🛠️ Skills Demonstrated](#️-skills-demonstrated)
- [🗺️ Roadmap](#️-roadmap)
- [🤝 Contributing](#-contributing)

---

## ✨ Overview

This project is the database backbone for a **food-ordering platform** (think a simplified delivery or dine-in app). It models:

- 🏪 **Restaurants** with GPS coordinates
- 📋 **Menus**: dishes grouped into categories, each with multiple size/price **variants**
- 📦 **Inventory** tracking with low-stock thresholds
- 🧾 **Orders** and the individual **items** inside each order

All primary keys are `CHAR(36)` **UUIDs**, which suits distributed systems and APIs that generate IDs outside the database.

---

## 🗂️ Project Structure

```text
📦 restaurant-db-project
 ┣ 📜 restaurant.sql   ← Creates the database, all 7 tables, and foreign keys
 ┗ 📄 README.md        ← You are here
```

---

## 🧱 Database Design

### Entity-relationship diagram

```mermaid
erDiagram
    RESTAURANTS ||--o{ DISHES : "serves"
    CATEGORIES  ||--o{ DISHES : "groups"
    DISHES      ||--o{ VARIANTS : "comes in"
    RESTAURANTS ||--o{ INVENTORY : "stocks"
    DISHES      ||--o{ INVENTORY : "tracked in"
    RESTAURANTS ||--o{ ORDERS : "receives"
    ORDERS      ||--o{ ORDER_ITEMS : "contains"
    DISHES      ||--o{ ORDER_ITEMS : "ordered as"
    VARIANTS    ||--o{ ORDER_ITEMS : "size chosen"

    RESTAURANTS {
        char36 restaurant_id PK
        varchar name
        text address
        decimal latitude
        decimal longitude
    }
    CATEGORIES {
        char36 category_id PK
        varchar name
    }
    DISHES {
        char36 dish_id PK
        char36 restaurant_id FK
        char36 category_id FK
        varchar name
        boolean is_available
    }
    VARIANTS {
        char36 variant_id PK
        char36 dish_id FK
        varchar size
        decimal price
        varchar attributes
    }
    INVENTORY {
        char36 id PK
        char36 restaurant_id FK
        char36 dish_id FK
        decimal available_qty
        decimal threshold_qty
    }
    ORDERS {
        char36 order_id PK
        char36 user_id
        char36 restaurant_id FK
        decimal total_price
        varchar status
        timestamp created_at
    }
    ORDER_ITEMS {
        char36 id PK
        char36 order_id FK
        char36 dish_id FK
        char36 variant_id FK
        int quantity
        decimal price
    }
```

### Domain at a glance

| Area | Tables | Purpose |
|------|--------|---------|
| 🍕 **Menu** | `restaurants`, `categories`, `dishes`, `variants` | What each restaurant sells and at what price |
| 📦 **Stock** | `inventory` | How much of each dish is available vs. its reorder threshold |
| 🧾 **Sales** | `orders`, `order_items` | What customers bought, from where, and when |

---

## 📚 Table Reference

<details>
<summary>🏪 <b>restaurants</b>: restaurant locations</summary>

| Column | Type | Notes |
|--------|------|-------|
| `restaurant_id` | `CHAR(36)` | Primary key (UUID) |
| `name` | `VARCHAR(255)` | Restaurant name |
| `address` | `TEXT` | Full address |
| `latitude` | `DECIMAL(10,8)` | GPS latitude |
| `longitude` | `DECIMAL(11,8)` | GPS longitude |

</details>

<details>
<summary>📋 <b>categories</b>: dish groupings (e.g. Starters, Mains)</summary>

| Column | Type | Notes |
|--------|------|-------|
| `category_id` | `CHAR(36)` | Primary key (UUID) |
| `name` | `VARCHAR(255)` | Category name |

</details>

<details>
<summary>🍝 <b>dishes</b>: menu items</summary>

| Column | Type | Notes |
|--------|------|-------|
| `dish_id` | `CHAR(36)` | Primary key (UUID) |
| `restaurant_id` | `CHAR(36)` | FK → `restaurants` |
| `category_id` | `CHAR(36)` | FK → `categories` |
| `name` | `VARCHAR(255)` | Dish name |
| `is_available` | `BOOLEAN` | Defaults to `TRUE`; lets you hide a dish without deleting it |

</details>

<details>
<summary>📏 <b>variants</b>: sizes and prices per dish</summary>

| Column | Type | Notes |
|--------|------|-------|
| `variant_id` | `CHAR(36)` | Primary key (UUID) |
| `dish_id` | `CHAR(36)` | FK → `dishes` |
| `size` | `VARCHAR(50)` | e.g. Small / Medium / Large |
| `price` | `DECIMAL(10,2)` | Menu price for this variant |
| `attributes` | `VARCHAR(255)` | Free-form extras (e.g. "spicy", "gluten-free") |

</details>

<details>
<summary>📦 <b>inventory</b>: stock levels</summary>

| Column | Type | Notes |
|--------|------|-------|
| `id` | `CHAR(36)` | Primary key (UUID) |
| `restaurant_id` | `CHAR(36)` | FK → `restaurants` |
| `dish_id` | `CHAR(36)` | FK → `dishes` |
| `available_qty` | `DECIMAL(10,2)` | Current stock |
| `threshold_qty` | `DECIMAL(10,2)` | Reorder level; low stock when `available_qty <= threshold_qty` |

</details>

<details>
<summary>🧾 <b>orders</b>: customer orders</summary>

| Column | Type | Notes |
|--------|------|-------|
| `order_id` | `CHAR(36)` | Primary key (UUID) |
| `user_id` | `CHAR(36)` | Customer ID (no `users` table in this schema, so no FK) |
| `restaurant_id` | `CHAR(36)` | FK → `restaurants` |
| `total_price` | `DECIMAL(10,2)` | Order total |
| `status` | `VARCHAR(50)` | e.g. placed / preparing / delivered |
| `created_at` | `TIMESTAMP` | When the order was placed |

</details>

<details>
<summary>🛒 <b>order_items</b>: line items within an order</summary>

| Column | Type | Notes |
|--------|------|-------|
| `id` | `CHAR(36)` | Primary key (UUID) |
| `order_id` | `CHAR(36)` | FK → `orders` |
| `dish_id` | `CHAR(36)` | FK → `dishes` |
| `variant_id` | `CHAR(36)` | FK → `variants` |
| `quantity` | `INT` |

⭐ If you found this project useful, please consider giving it a Star!
Made with ❤️ by Samaira Shaikh
