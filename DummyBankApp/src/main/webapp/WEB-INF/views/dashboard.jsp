<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DummyBank — Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f0f4f8;
            color: #333;
        }

        /* ---- NAVBAR ---- */
        .navbar {
            background: #0a1628;
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            border-bottom: 3px solid #c9a84c;
        }

        .nav-brand { color: #c9a84c; font-size: 20px; font-weight: bold; letter-spacing: 2px; }

        .nav-links a {
            color: #aab8c8;
            text-decoration: none;
            margin-left: 28px;
            font-size: 14px;
            transition: color 0.2s;
        }

        .nav-links a:hover, .nav-links a.active { color: #c9a84c; }

        .nav-user { color: #aab8c8; font-size: 13px; }
        .nav-user strong { color: #fff; }

        /* ---- MAIN CONTENT ---- */
        .container { max-width: 1000px; margin: 40px auto; padding: 0 20px; }

        .welcome-text { font-size: 22px; color: #0a1628; margin-bottom: 28px; }
        .welcome-text span { color: #c9a84c; font-weight: bold; }

        /* ---- SUCCESS MESSAGE ---- */
        .success-banner {
            background: #d4edda;
            border-left: 4px solid #28a745;
            color: #155724;
            padding: 14px 18px;
            border-radius: 0 4px 4px 0;
            margin-bottom: 24px;
            font-size: 14px;
        }

        /* ---- BALANCE CARD ---- */
        .balance-card {
            background: linear-gradient(135deg, #0a1628 0%, #1a3a5c 100%);
            border-radius: 8px;
            padding: 36px 40px;
            color: white;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }

        .balance-card::after {
            content: '';
            position: absolute;
            right: -30px; top: -30px;
            width: 180px; height: 180px;
            border-radius: 50%;
            background: rgba(201,168,76,0.08);
        }

        .balance-label { font-size: 12px; letter-spacing: 2px; text-transform: uppercase; color: #8899aa; }
        .balance-amount { font-size: 42px; font-weight: bold; color: #c9a84c; margin: 10px 0; }
        .balance-amount span { font-size: 22px; margin-right: 4px; }
        .account-no { font-size: 13px; color: #8899aa; letter-spacing: 1px; }
        .account-no strong { color: #ccc; font-family: 'Courier New', monospace; }

        /* ---- ACTION BUTTONS ---- */
        .actions { display: flex; gap: 16px; margin-bottom: 36px; flex-wrap: wrap; }

        .action-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            background: white;
            border: 2px solid #e0e6ed;
            border-radius: 6px;
            padding: 18px 28px;
            text-decoration: none;
            color: #333;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s;
            flex: 1; min-width: 160px;
        }

        .action-btn:hover {
            border-color: #c9a84c;
            color: #0a1628;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .action-btn .icon { font-size: 24px; }

        /* ---- RECENT TRANSACTIONS PREVIEW ---- */
        .section-title {
            font-size: 16px;
            font-weight: bold;
            color: #0a1628;
            margin-bottom: 14px;
            letter-spacing: 0.5px;
        }

        .view-all { float: right; font-size: 13px; color: #c9a84c; text-decoration: none; }
        .view-all:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%-- Get the logged-in user from session --%>
<% User user = (User) session.getAttribute("loggedInUser"); %>

<!-- NAVBAR -->
<div class="navbar">
    <div class="nav-brand">⬡ DUMMYBANK</div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/dashboard" class="active">Dashboard</a>
        <a href="<%= request.getContextPath() %>/transfer">Transfer</a>
        <a href="<%= request.getContextPath() %>/history">History</a>
    </div>
    <div class="nav-user">
        Welcome, <strong><%= user.getFullName() %></strong> &nbsp;|&nbsp;
        <a href="<%= request.getContextPath() %>/logout" style="color:#e57373; font-size:13px; text-decoration:none;">Logout</a>
    </div>
</div>

<div class="container">

    <div class="welcome-text">
        Good day, <span><%= user.getFullName() %></span> 👋
    </div>

    <%-- Show success message after transfer --%>
    <% String successMsg = (String) session.getAttribute("successMessage");
       if (successMsg != null) {
           session.removeAttribute("successMessage"); %>
        <div class="success-banner">✅ <%= successMsg %></div>
    <% } %>

    <!-- BALANCE CARD -->
    <div class="balance-card">
        <div class="balance-label">Available Balance</div>
        <div class="balance-amount">
            <span>₹</span><%= String.format("%,.2f", user.getBalance()) %>
        </div>
        <div class="account-no">
            Account No: <strong><%= user.getAccountNo() %></strong>
            &nbsp;&nbsp;|&nbsp;&nbsp;
            Customer ID: <strong><%= user.getUsername() %></strong>
        </div>
    </div>

    <!-- ACTION BUTTONS -->
    <div class="actions">
        <a href="<%= request.getContextPath() %>/transfer" class="action-btn">
            <span class="icon">💸</span> Fund Transfer
        </a>
        <a href="<%= request.getContextPath() %>/history" class="action-btn">
            <span class="icon">📋</span> Transaction History
        </a>
        <a href="#" class="action-btn" onclick="alert('Feature coming soon!')">
            <span class="icon">💳</span> My Account
        </a>
        <a href="#" class="action-btn" onclick="alert('Feature coming soon!')">
            <span class="icon">🏦</span> Fixed Deposits
        </a>
    </div>

    <!-- QUICK LINKS SECTION -->
    <div class="section-title">
        Quick Access
        <a href="<%= request.getContextPath() %>/history" class="view-all">View All Transactions →</a>
    </div>

    <div style="background:white; border-radius:6px; padding:24px; color:#888; text-align:center; border: 1px dashed #ddd;">
        Click "Transaction History" to view your recent transactions.
    </div>

</div>

</body>
</html>
