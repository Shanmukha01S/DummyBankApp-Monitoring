<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bank.model.User, com.bank.model.Transaction, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DummyBank — Transaction History</title>
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

        .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 22px; color: #0a1628; margin-bottom: 24px; }

        .history-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .card-header {
            padding: 20px 28px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
            color: #666;
        }

        table { width: 100%; border-collapse: collapse; }

        th {
            padding: 14px 20px;
            text-align: left;
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #888;
            background: #fafafa;
            border-bottom: 1px solid #eee;
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafbfc; }

        .amount-credit { color: #27ae60; font-weight: bold; font-size: 15px; }
        .amount-debit  { color: #e74c3c; font-weight: bold; font-size: 15px; }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .badge-success { background: #d4edda; color: #155724; }
        .badge-failed  { background: #f8d7da; color: #721c24; }

        .direction-in  { color: #27ae60; font-size: 16px; }
        .direction-out { color: #e74c3c; font-size: 16px; }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state .icon { font-size: 48px; margin-bottom: 16px; }

        .date-text { color: #999; font-size: 12px; }
        .desc-text { color: #777; font-size: 12px; margin-top: 3px; }
    </style>
</head>
<body>

<% User user = (User) session.getAttribute("loggedInUser"); %>

<div class="navbar">
    <div class="nav-brand">⬡ DUMMYBANK</div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/transfer">Transfer</a>
        <a href="<%= request.getContextPath() %>/history" class="active">History</a>
    </div>
    <div style="color:#aab8c8; font-size:13px;">
        <a href="<%= request.getContextPath() %>/logout" style="color:#e57373; text-decoration:none;">Logout</a>
    </div>
</div>

<div class="container">
    <div class="page-title">📋 Transaction History</div>

    <div class="history-card">
        <div class="card-header">
            Account: <strong><%= user.getAccountNo() %></strong>
            &nbsp;&nbsp;|&nbsp;&nbsp; Showing last 20 transactions
        </div>

        <%
            List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
            if (transactions == null || transactions.isEmpty()) {
        %>
            <div class="empty-state">
                <div class="icon">🏦</div>
                <div>No transactions yet.</div>
                <div style="margin-top:8px; font-size:13px;">
                    <a href="<%= request.getContextPath() %>/transfer">Make your first transfer →</a>
                </div>
            </div>

        <% } else { %>

        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Type</th>
                    <th>Particulars</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Date & Time</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String myAccount = user.getAccountNo();
                    for (Transaction t : transactions) {
                        boolean isSender = t.getFromAccount().equals(myAccount);
                %>
                <tr>
                    <td style="color:#ccc; font-size:12px;"><%= t.getId() %></td>

                    <td>
                        <% if (isSender) { %>
                            <span class="direction-out" title="Debit">↑</span>
                            <span style="font-size:12px; color:#e74c3c; margin-left:4px;">DEBIT</span>
                        <% } else { %>
                            <span class="direction-in" title="Credit">↓</span>
                            <span style="font-size:12px; color:#27ae60; margin-left:4px;">CREDIT</span>
                        <% } %>
                    </td>

                    <td>
                        <% if (isSender) { %>
                            <div>To: <strong><%= t.getToName() %></strong> (<code><%= t.getToAccount() %></code>)</div>
                        <% } else { %>
                            <div>From: <strong><%= t.getFromName() %></strong> (<code><%= t.getFromAccount() %></code>)</div>
                        <% } %>
                        <% if (t.getDescription() != null && !t.getDescription().isEmpty()) { %>
                            <div class="desc-text"><%= t.getDescription() %></div>
                        <% } %>
                    </td>

                    <td>
                        <% if (isSender) { %>
                            <span class="amount-debit">− ₹<%= String.format("%,.2f", t.getAmount()) %></span>
                        <% } else { %>
                            <span class="amount-credit">+ ₹<%= String.format("%,.2f", t.getAmount()) %></span>
                        <% } %>
                    </td>

                    <td>
                        <span class="badge <%= "SUCCESS".equals(t.getStatus()) ? "badge-success" : "badge-failed" %>">
                            <%= t.getStatus() %>
                        </span>
                    </td>

                    <td class="date-text">
                        <%= t.getCreatedAt() %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <% } %>
    </div>
</div>

</body>
</html>
