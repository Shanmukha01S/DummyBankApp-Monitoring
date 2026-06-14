package com.bank.servlet;

import com.bank.dao.TransactionDAO;
import com.bank.model.Transaction;
import com.bank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * TransactionHistoryServlet.java
 * --------------------------------
 * Fetches and displays the last 20 transactions for the logged-in user.
 * Simple GET-only servlet — no form processing needed.
 */
@WebServlet("/history")
public class TransactionHistoryServlet extends HttpServlet {

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

        // Fetch transaction list from DB
        List<Transaction> transactions = transactionDAO.getTransactionHistory(user.getAccountNo());

        // Put data in request scope for JSP to read
        request.setAttribute("user", user);
        request.setAttribute("transactions", transactions);

        request.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(request, response);
    }
}
