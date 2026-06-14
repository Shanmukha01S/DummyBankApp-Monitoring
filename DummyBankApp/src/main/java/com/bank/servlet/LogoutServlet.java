package com.bank.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * LogoutServlet.java
 * -------------------
 * Destroys the user session and redirects to login.
 *
 * session.invalidate() = deletes the session from server memory
 * The session cookie on browser becomes useless after this.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();   // Kill the session
        }

        // Redirect to login with a logout message
        response.sendRedirect(request.getContextPath() + "/login?message=logged_out");
    }
}
