<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DummyBank — Fund Transfer</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; color: #333; }

        .navbar {
            background: #0a1628; padding: 0 40px;
            display: flex; align-items: center; justify-content: space-between;
            height: 60px; border-bottom: 3px solid #c9a84c;
        }
        .nav-brand { color: #c9a84c; font-size: 20px; font-weight: bold; letter-spacing: 2px; }
        .nav-links a { color: #aab8c8; text-decoration: none; margin-left: 28px; font-size: 14px; }
        .nav-links a:hover, .nav-links a.active { color: #c9a84c; }

        .container { max-width: 600px; margin: 40px auto; padding: 0 20px; }

        .page-title { font-size: 22px; color: #0a1628; margin-bottom: 24px; }

        .transfer-card {
            background: white;
            border-radius: 8px;
            padding: 36px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }

        .balance-info {
            background: #f8f9fa;
            border-radius: 4px;
            padding: 14px 18px;
            margin-bottom: 28px;
            font-size: 14px;
            color: #555;
            border-left: 4px solid #c9a84c;
        }

        .balance-info strong { color: #0a1628; font-size: 18px; }

        .form-group { margin-bottom: 22px; }

        label {
            display: block;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #666;
            margin-bottom: 8px;
        }

        input, textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.2s;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #c9a84c;
            box-shadow: 0 0 0 3px rgba(201,168,76,0.12);
        }

        .amount-wrapper { position: relative; }
        .amount-prefix {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%);
            font-size: 18px; color: #888; font-weight: bold;
        }
        .amount-wrapper input { padding-left: 30px; font-size: 18px; font-weight: bold; }

        .btn-transfer {
            width: 100%;
            padding: 14px;
            background: #0a1628;
            color: #c9a84c;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            font-weight: bold;
            letter-spacing: 1px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-transfer:hover { background: #1a3a5c; }

        .error-box {
            background: #fff0f0;
            border-left: 4px solid #e74c3c;
            color: #c0392b;
            padding: 12px 14px;
            font-size: 14px;
            margin-bottom: 20px;
            border-radius: 0 4px 4px 0;
        }

        .hint { font-size: 12px; color: #999; margin-top: 6px; }
    </style>
</head>
<body>

<% User user = (User) session.getAttribute("loggedInUser"); %>

<div class="navbar">
    <div class="nav-brand">⬡ DUMMYBANK</div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/transfer" class="active">Transfer</a>
        <a href="<%= request.getContextPath() %>/history">History</a>
    </div>
    <div style="color:#aab8c8; font-size:13px;">
        <a href="<%= request.getContextPath() %>/logout" style="color:#e57373; text-decoration:none;">Logout</a>
    </div>
</div>

<div class="container">
    <div class="page-title">💸 Fund Transfer</div>

    <div class="transfer-card">

        <div class="balance-info">
            Your available balance: <strong>₹<%= String.format("%,.2f", user.getBalance()) %></strong>
            &nbsp;&nbsp; | &nbsp;&nbsp; From: <code><%= user.getAccountNo() %></code>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-box">⚠️ <%= request.getAttribute("error") %></div>
        <% } %>

        <%-- TRANSFER FORM
             All fields are sent to TransferServlet via POST
        --%>
        <form action="<%= request.getContextPath() %>/transfer" method="post">

            <div class="form-group">
                <label for="toAccountNo">Beneficiary Account Number</label>
                <input type="text" id="toAccountNo" name="toAccountNo"
                       placeholder="e.g. ACC0001002"
                       required
                       value="<%= request.getParameter("toAccountNo") != null ? request.getParameter("toAccountNo") : "" %>">
                <div class="hint">Test: transfer to account ACC0001002</div>
            </div>

            <div class="form-group">
                <label for="amount">Transfer Amount</label>
                <div class="amount-wrapper">
                    <span class="amount-prefix">₹</span>
                    <input type="number" id="amount" name="amount"
                           placeholder="0.00"
                           step="0.01" min="1"
                           required>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Remarks (Optional)</label>
                <input type="text" id="description" name="description"
                       placeholder="e.g. Rent payment, Personal transfer...">
            </div>

            <button type="submit" class="btn-transfer">Transfer Now →</button>
        </form>

    </div>
</div>

</body>
</html>
