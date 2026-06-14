package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * User.java — MODEL class
 * -----------------------
 * A Model (also called POJO = Plain Old Java Object) is just a
 * blueprint that represents ONE ROW from the database table.
 *
 * The "users" table has columns: id, full_name, username, password, balance, account_no
 * This class mirrors those columns as Java fields.
 *
 * ANALOGY:
 * Database table = Excel sheet
 * One row in table = One User object in Java
 *
 * Flow:
 * MySQL Row → Java fetches it → Creates User object → Passes to JSP page to display
 */
public class User {

    private int id;
    private String fullName;
    private String username;
    private String password;        // BCrypt hashed
    private BigDecimal balance;     // BigDecimal for money (never use float/double for money!)
    private String accountNo;
    private Timestamp createdAt;

    // =============================================
    // CONSTRUCTORS
    // =============================================

    public User() {}   // Empty constructor — needed by some frameworks

    public User(String fullName, String username, String password,
                BigDecimal balance, String accountNo) {
        this.fullName  = fullName;
        this.username  = username;
        this.password  = password;
        this.balance   = balance;
        this.accountNo = accountNo;
    }

    // =============================================
    // GETTERS & SETTERS
    // Java convention: private fields + public getters/setters
    // This is called ENCAPSULATION
    // =============================================

    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }

    public String getFullName()                     { return fullName; }
    public void setFullName(String fullName)        { this.fullName = fullName; }

    public String getUsername()                     { return username; }
    public void setUsername(String username)        { this.username = username; }

    public String getPassword()                     { return password; }
    public void setPassword(String password)        { this.password = password; }

    public BigDecimal getBalance()                  { return balance; }
    public void setBalance(BigDecimal balance)      { this.balance = balance; }

    public String getAccountNo()                    { return accountNo; }
    public void setAccountNo(String accountNo)      { this.accountNo = accountNo; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)   { this.createdAt = createdAt; }
}
