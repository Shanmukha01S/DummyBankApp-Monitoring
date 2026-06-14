package com.bank.servlet;

import com.bank.dao.TransactionDAO;
import com.bank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * TransferServlet.java
 * ---------------------
 * Handles money transfer between accounts.
 *
 * GET  /transfer → Show the transfer form
 * POST /transfer → Process the transfer
 *
 * IMPORTANT CONCEPT: After a successful POST, we REDIRECT (not forward).
 * This is called the PRG Pattern (Post-Redirect-Get).
 *
 * WHY?
 * If user refreshes the page after a POST, browser re-submits the form.
 * → Money gets transferred TWICE! 😱
 *
 * With PRG:
 * POST (transfer) → REDIRECT to /dashboard → GET /dashboard
 * Now refresh just reloads dashboard, no double transfer.
 */
@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {

    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User sender = (User) session.getAttribute("loggedInUser");

        // Read form data
        String toAccountNo  = request.getParameter("toAccountNo");
        String amountStr    = request.getParameter("amount");
        String description  = request.getParameter("description");

        // =============================================
        // INPUT VALIDATION
        // Never trust user input! Always validate server-side.
        // Client-side (JS) validation is just UX, not security.
        // =============================================
        if (toAccountNo == null || toAccountNo.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a valid account number.");
            request.setAttribute("user", sender);
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(request, response);
            return;
        }

        if (toAccountNo.trim().equals(sender.getAccountNo())) {
            request.setAttribute("error", "You cannot transfer money to your own account.");
            request.setAttribute("user", sender);
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(request, response);
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new NumberFormatException("Amount must be positive");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid positive amount.");
            request.setAttribute("user", sender);
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(request, response);
            return;
        }

        // =============================================
        // PERFORM TRANSFER
        // =============================================
        String result = transactionDAO.transferMoney(
                sender.getAccountNo(),
                toAccountNo.trim(),
                amount,
                description
        );

        if (result.startsWith("SUCCESS")) {
            // Refresh user data in session (balance has changed)
            // In production: re-fetch user from DB here
            // For simplicity: store success message and redirect
            session.setAttribute("successMessage", result);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", result);
            request.setAttribute("user", sender);
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(request, response);
        }
    }
}
