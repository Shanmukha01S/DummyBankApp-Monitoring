<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DummyBank — Secure Login</title>
    <style>
        /* =============================================
           Clean, professional bank login UI
           Dark navy + gold — classic banking aesthetic
        ============================================= */
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Georgia', serif;
            background: #0a1628;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: radial-gradient(ellipse at top, #1a2d4a 0%, #0a1628 70%);
        }

        .login-card {
            background: #fff;
            width: 420px;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }

        .card-header {
            background: #0a1628;
            padding: 36px 40px 28px;
            text-align: center;
            border-bottom: 3px solid #c9a84c;
        }

        .bank-logo {
            font-size: 28px;
            font-weight: bold;
            color: #c9a84c;
            letter-spacing: 2px;
        }

        .bank-tagline {
            color: #8899aa;
            font-size: 12px;
            letter-spacing: 1px;
            margin-top: 6px;
            text-transform: uppercase;
        }

        .card-body { padding: 36px 40px; }

        .form-group { margin-bottom: 20px; }

        label {
            display: block;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: #555;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 3px;
            font-size: 15px;
            font-family: 'Courier New', monospace;
            color: #333;
            transition: border-color 0.2s;
        }

        input:focus {
            outline: none;
            border-color: #c9a84c;
            box-shadow: 0 0 0 3px rgba(201,168,76,0.15);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background: #0a1628;
            color: #c9a84c;
            border: none;
            border-radius: 3px;
            font-size: 14px;
            font-weight: bold;
            letter-spacing: 2px;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.2s;
        }

        .btn-login:hover { background: #1a2d4a; }

        .error-box {
            background: #fff0f0;
            border-left: 4px solid #e74c3c;
            color: #c0392b;
            padding: 12px 14px;
            font-size: 14px;
            margin-bottom: 20px;
            border-radius: 0 3px 3px 0;
        }

        .success-box {
            background: #f0fff4;
            border-left: 4px solid #27ae60;
            color: #1e8449;
            padding: 12px 14px;
            font-size: 14px;
            margin-bottom: 20px;
            border-radius: 0 3px 3px 0;
        }

        .demo-hint {
            text-align: center;
            font-size: 12px;
            color: #999;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .demo-hint strong { color: #555; }
    </style>
</head>
<body>

<div class="login-card">
    <div class="card-header">
        <div class="bank-logo">⬡ DUMMYBANK</div>
        <div class="bank-tagline">Secure Internet Banking</div>
    </div>

    <div class="card-body">

        <%-- Show error message if login failed --%>
        <%-- These are JSP scriplets — Java code embedded in HTML --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-box"><%= request.getAttribute("error") %></div>
        <% } %>

        <%-- Show success message e.g. after logout --%>
        <% if ("logged_out".equals(request.getParameter("message"))) { %>
            <div class="success-box">You have been securely logged out.</div>
        <% } %>

        <%-- LOGIN FORM
             action="/login"   → submits to LoginServlet
             method="post"     → POST request (form data hidden from URL)
        --%>
        <form action="<%= request.getContextPath() %>/login" method="post">

            <div class="form-group">
                <label for="username">Customer ID / Username</label>
                <input type="text" id="username" name="username"
                       placeholder="Enter your username"
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                       required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password"
                       required>
            </div>

            <button type="submit" class="btn-login">Login Securely</button>
        </form>

        <div class="demo-hint">
            <strong>Demo credentials:</strong><br>
            Username: <strong>shanmukha</strong> or <strong>testuser</strong><br>
            Password: <strong>Password@123</strong>
        </div>
    </div>
</div>

</body>
</html>
