package com.bank.dao;

import com.bank.model.Transaction;
import com.bank.model.User;
import com.bank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    private UserDAO userDAO = new UserDAO();

    public String transferMoney(String fromAccountNo, String toAccountNo,
                                BigDecimal amount, String description) {

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            User sender = userDAO.getUserByAccountNo(fromAccountNo);
            if (sender == null) {
                return "Sender account not found.";
            }

            User receiver = userDAO.getUserByAccountNo(toAccountNo);
            if (receiver == null) {
                conn.rollback();
                return "Receiver account number not found. Please check and retry.";
            }

            if (sender.getBalance().compareTo(amount) < 0) {
                conn.rollback();
                return "Insufficient balance. Your current balance is Rs." + sender.getBalance();
            }

            BigDecimal newSenderBalance = sender.getBalance().subtract(amount);
            userDAO.updateBalance(fromAccountNo, newSenderBalance, conn);

            BigDecimal newReceiverBalance = receiver.getBalance().add(amount);
            userDAO.updateBalance(toAccountNo, newReceiverBalance, conn);

            String insertSQL = "INSERT INTO transactions (from_account, to_account, amount, description, status) VALUES (?, ?, ?, ?, 'SUCCESS')";
            PreparedStatement ps = conn.prepareStatement(insertSQL);
            ps.setString(1, fromAccountNo);
            ps.setString(2, toAccountNo);
            ps.setBigDecimal(3, amount);
            ps.setString(4, description);
            ps.executeUpdate();

            conn.commit();
            return "SUCCESS: Rs." + amount + " transferred to " + receiver.getFullName();

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return "Transfer failed due to a system error. Please try again.";

        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Transaction> getTransactionHistory(String accountNo) {
        List<Transaction> list = new ArrayList<>();

        String sql = "SELECT t.*, u1.full_name AS from_name, u2.full_name AS to_name " +
                     "FROM transactions t " +
                     "JOIN users u1 ON t.from_account = u1.account_no " +
                     "JOIN users u2 ON t.to_account = u2.account_no " +
                     "WHERE t.from_account = ? OR t.to_account = ? " +
                     "ORDER BY t.created_at DESC " +
                     "LIMIT 20";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accountNo);
            ps.setString(2, accountNo);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setId(rs.getInt("id"));
                t.setFromAccount(rs.getString("from_account"));
                t.setToAccount(rs.getString("to_account"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setDescription(rs.getString("description"));
                t.setStatus(rs.getString("status"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                t.setFromName(rs.getString("from_name"));
                t.setToName(rs.getString("to_name"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
