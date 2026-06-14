<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Root URL "/" redirects to /login
    // This is the entry point of the application
    response.sendRedirect(request.getContextPath() + "/login");
%>
