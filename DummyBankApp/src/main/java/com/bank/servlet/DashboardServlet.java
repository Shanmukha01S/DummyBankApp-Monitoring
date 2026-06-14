package com.bank.servlet;

import com.bank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * DashboardServlet.java
 * ----------------------
 * Shows the main banking dashboard after login.
 * Displays: welcome message, account number, current balance.
 *
 * SECURITY: Checks session before showing any data.
 * If no valid session → redirect to login.
 * This is called "Authentication Guard" or "Session Check".
 *
 * In real banks, this also checks:
 * - Is account locked/frozen?
 * - Is session IP same as login IP? (prevents session hijacking)
 * - Has session token been tampered? (CSRF protection)
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =============================================
        // SESSION CHECK — Every protected page must do this!
        // =============================================
        HttpSession session = request.getSession(false);  // false = don't create new session
        if (session == null || session.getAttribute("loggedInUser") == null) {
            // Not logged in → go to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get the logged-in user from session
        User user = (User) session.getAttribute("loggedInUser");

        // Pass user data to JSP for display
        // request.setAttribute = "put this data in the request so JSP can read it"
        request.setAttribute("user", user);

        // Forward to dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}
