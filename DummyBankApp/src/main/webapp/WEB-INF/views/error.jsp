<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DummyBank — Error</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0a1628;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .error-box { text-align: center; }
        .error-code { font-size: 80px; font-weight: bold; color: #c9a84c; }
        .error-msg  { font-size: 20px; color: #aab8c8; margin: 12px 0 28px; }
        .back-btn {
            display: inline-block;
            padding: 12px 28px;
            background: #c9a84c;
            color: #0a1628;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <div class="error-code">⚠</div>
        <div class="error-msg">Something went wrong. Please try again.</div>
        <a href="javascript:history.back()" class="back-btn">← Go Back</a>
    </div>
</body>
</html>
