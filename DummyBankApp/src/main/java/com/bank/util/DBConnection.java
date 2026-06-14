package com.bank.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection.java
 * -----------------
 * This is a UTILITY class — its only job is to give a database connection
 * to whoever asks for it.
 *
 * Think of it like a "key" to the database.
 * Whenever a Servlet needs to read/write data, it calls:
 *     Connection conn = DBConnection.getConnection();
 *
 * HOW DATABASE CONNECTION WORKS:
 * Java App → JDBC Driver → MySQL Server
 *
 * JDBC = Java Database Connectivity
 * It's a standard API so your Java code works with any DB (MySQL, Oracle, etc.)
 * You just change the driver and URL — code stays same!
 */
public class DBConnection {

    // =============================================
    // DATABASE CONFIG
    // In real banks, these come from environment variables
    // or a secrets vault (HashiCorp Vault / CyberArk)
    // For now, we hardcode for learning purposes
    // =============================================

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/bankdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    //                                          ↑ protocol  ↑ host    ↑ port  ↑ database name

    private static final String DB_USER     = "Bankuser";
    private static final String DB_PASSWORD = "Bank@1234";  // Change this!

    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    /**
     * Returns a live connection to the MySQL database.
     * Called by DAO classes (Data Access Objects) to run SQL queries.
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Step 1: Load the MySQL JDBC driver into JVM memory
            Class.forName(DRIVER_CLASS);

            // Step 2: Create and return the actual connection
            // DriverManager handles the TCP connection to MySQL server
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        } catch (ClassNotFoundException e) {
            // This means mysql-connector-java.jar is missing from classpath
            throw new SQLException("MySQL JDBC Driver not found! Check pom.xml dependency.", e);
        }
    }
}
