-- =============================================
-- DATABASE SETUP SCRIPT
-- Run this ONCE on your MySQL server before starting the app
-- Command: mysql -u root -p < database_setup.sql
-- =============================================

-- Create the database
CREATE DATABASE IF NOT EXISTS bankdb;
USE bankdb;

-- =============================================
-- USERS TABLE
-- Stores customer login credentials and balance
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,  -- unique ID for each user
    full_name   VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  NOT NULL UNIQUE,     -- login username, must be unique
    password    VARCHAR(255) NOT NULL,            -- BCrypt hashed password (never plain text!)
    balance     DECIMAL(15,2) DEFAULT 0.00,       -- account balance, 15 digits, 2 decimal places
    account_no  VARCHAR(20)  NOT NULL UNIQUE,     -- bank account number
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- TRANSACTIONS TABLE
-- Records every money transfer (like a ledger)
-- =============================================
CREATE TABLE IF NOT EXISTS transactions (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    from_account    VARCHAR(20) NOT NULL,          -- sender's account number
    to_account      VARCHAR(20) NOT NULL,           -- receiver's account number
    amount          DECIMAL(15,2) NOT NULL,
    description     VARCHAR(255),
    status          ENUM('SUCCESS','FAILED') DEFAULT 'SUCCESS',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key links to users table (data integrity)
    FOREIGN KEY (from_account) REFERENCES users(account_no),
    FOREIGN KEY (to_account)   REFERENCES users(account_no)
);

-- =============================================
-- SAMPLE DATA
-- Two test users for practicing
-- Password for both = "Password@123"
-- (BCrypt hashed below)
-- =============================================
INSERT INTO users (full_name, username, password, balance, account_no) VALUES
(
    'Shanmukha Kumar',
    'shanmukha',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.ihlm',  -- Password@123
    50000.00,
    'ACC0001001'
),
(
    'Test User',
    'testuser',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/HS.ihlm',  -- Password@123
    25000.00,
    'ACC0001002'
);

-- Verify data inserted
SELECT id, full_name, username, balance, account_no FROM users;
