# Cyclouse - Bicycle E-Commerce API

Cyclouse is a Vapor-based API for a bicycle e-commerce platform. It provides endpoints for user authentication, product management, shopping cart operations, and order processing.

## Features

- User Authentication (Login/Logout)
- Product Listing and Details
- Shopping Cart Management
- Checkout Process
- Order History

## API Endpoints

### 🔐Authentication
- POST `/auth/login`: User login
- POST `/auth/logout`: User logout (requires authentication)

### 📦Products
- GET `/`: Get all products
- GET `/product`: Get all products (alternative route)
- GET `/product/:id`: Get product details by ID

### 🛒Shopping Cart
- POST `/cart/add`: Add item to cart (requires authentication)
- GET `/cart`: Get current cart contents (requires authentication)

### Checkout
- POST `/checkout`: Process checkout (requires authentication)

### 📋Order History
- GET `/orders`: Get order history (requires authentication)

## Models

- `User`: Represents a user account
- `Product`: Represents a bicycle or bicycle part
- `Category`: Represents a product category
- `CartItem`: Represents an item in the shopping cart
- `Order`: Represents a completed order

## Configuration

The `configure(_:)` function in `configure.swift` sets up the application:

- Registers routes
- Sets up static file middleware

## Getting Started

1. Clone the repository
2. Install Vapor if not already installed
3. Run `vapor build` to build the project
4. Run `vapor run serve` to start the server

## Setup & Deployment 🚀

### Start Ngrok Tunnel
```bash
# Start tunnel on Vapor's port (8080)
ngrok http 8080
```
## Dependencies

- Vapor 4.x

