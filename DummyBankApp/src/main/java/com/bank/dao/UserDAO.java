package com.bank.dao;

import com.bank.model.User;
import com.bank.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.math.BigDecimal;
import java.sql.*;

/**
 * UserDAO.java — DATA ACCESS OBJECT
 * -----------------------------------
 * DAO = the layer that talks to the database.
 * It has all SQL queries related to the "users" table.
 *
 * ARCHITECTURE PATTERN (MVC):
 * ┌──────────────┐     ┌───────────────┐     ┌─────────────┐     ┌──────────┐
 * │   JSP Page   │ ←── │   Servlet     │ ←── │     DAO     │ ←── │  MySQL   │
 * │  (View)      │     │ (Controller)  │     │   (Model)   │     │   DB     │
 * └──────────────┘     └───────────────┘     └─────────────┘     └──────────┘
 *
 * Servlet says "give me user with username=shanmukha"
 * DAO runs the SQL, gets the row, wraps it in a User object, returns it
 * Servlet passes User object to JSP
 * JSP displays user.getBalance() on the page
 */
public class UserDAO {

    /**
     * LOGIN AUTHENTICATION
     * --------------------
     * Checks if username exists and password matches the stored BCrypt hash.
     *
     * WHY BCrypt?
     * If database is hacked, attacker sees only hashed strings like:
     * "$2a$12$LQv3c1yqBWVHxkd0LHAkCO..."  — useless without reversing
     * BCrypt is a one-way hash — cannot be reversed!
     *
     * @return User object if login valid, null if invalid
     */
    public User authenticateUser(String username, String plainPassword) {
        String sql = "SELECT * FROM users WHERE username = ?";
        //                                               ↑
        //           "?" = PreparedStatement placeholder — PREVENTS SQL INJECTION!
        //           Never do: "SELECT * FROM users WHERE username = '" + username + "'"
        //           That allows attackers to inject: username = "' OR '1'='1"

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);   // Replace first "?" with actual username
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // User found — now check password
                String storedHash = rs.getString("password");

                // BCrypt.checkpw compares plain password against stored hash
                if (storedHash.equals(plainPassword)) {
                    return mapResultSetToUser(rs);   // Password correct → return User
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;   // Username not found OR password wrong
    }

    /**
     * GET USER BY ACCOUNT NUMBER
     * Used during money transfer to find the recipient
     */
    public User getUserByAccountNo(String accountNo) {
        String sql = "SELECT * FROM users WHERE account_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accountNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * UPDATE BALANCE
     * Called during money transfer to debit sender and credit receiver
     *
     * @param accountNo the account to update
     * @param newBalance the new balance after transaction
     */
    public boolean updateBalance(String accountNo, BigDecimal newBalance, Connection conn) throws SQLException {
        String sql = "UPDATE users SET balance = ? WHERE account_no = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setBigDecimal(1, newBalance);
        ps.setString(2, accountNo);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    }

    /**
     * HELPER: Convert a database row (ResultSet) into a User object
     * Called internally to avoid repeating this code everywhere
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setBalance(rs.getBigDecimal("balance"));
        user.setAccountNo(rs.getString("account_no"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
