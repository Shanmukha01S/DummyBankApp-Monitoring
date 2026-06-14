package com.bank.servlet;

import com.bank.dao.UserDAO;
import com.bank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet.java — CONTROLLER
 * --------------------------------
 * Handles login form submission.
 *
 * HOW SERVLET WORKS:
 * Browser sends POST request to /login
 *  → WebLogic receives it
 *  → WebLogic looks up @WebServlet("/login") annotation
 *  → Routes request to this class
 *  → doPost() method runs
 *  → Redirects browser to dashboard or back to login
 *
 * HTTP METHODS:
 *  GET  = "give me the page"    → doGet()  handles this
 *  POST = "process my form"     → doPost() handles this
 *
 * SESSION:
 * HTTP is stateless — server forgets who you are after each request.
 * Session = a small "memory" the server keeps per user (identified by cookie).
 * After login, we store User object in session.
 * Every other page checks: "is there a user in session?" → if not, go to login.
 */
@WebServlet("/login")   // URL mapping — this Servlet responds to /login
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    /**
     * GET /login → Show the login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If user is already logged in, send them to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        // Forward to login.jsp to display the form
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    /**
     * POST /login → Process login form submission
     * Form sends: username, password
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form fields submitted by user
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        // Check credentials against database
        User user = userDAO.authenticateUser(username.trim(), password);

System.out.println("DEBUG: username=" + username.trim());
System.out.println("DEBUG: password=" + password);
System.out.println("DEBUG: user=" + user);

if (user != null) {
            // =============================================
            // LOGIN SUCCESS
            // Create a new session and store user in it
            // =============================================
            HttpSession session = request.getSession(true);   // true = create if doesn't exist
            session.setAttribute("loggedInUser", user);
            session.setMaxInactiveInterval(30 * 60);          // Session expires after 30 mins of inactivity

            // Redirect to dashboard (POST-Redirect-GET pattern prevents form resubmission)
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // LOGIN FAILED
            request.setAttribute("error", "Invalid username or password. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
