package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Transaction.java — MODEL class
 * --------------------------------
 * Represents ONE ROW from the "transactions" table.
 * Every time money moves between accounts, one Transaction object is created.
 *
 * Real banks call this an "audit trail" — every rupee movement is recorded forever.
 */
public class Transaction {

    private int id;
    private String fromAccount;     // sender's account number
    private String toAccount;       // receiver's account number
    private BigDecimal amount;
    private String description;
    private String status;          // "SUCCESS" or "FAILED"
    private Timestamp createdAt;

    // Used for display — show names instead of just account numbers
    private String fromName;
    private String toName;

    public Transaction() {}

    // =============================================
    // GETTERS & SETTERS
    // =============================================

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getFromAccount()              { return fromAccount; }
    public void setFromAccount(String from)     { this.fromAccount = from; }

    public String getToAccount()                { return toAccount; }
    public void setToAccount(String to)         { this.toAccount = to; }

    public BigDecimal getAmount()               { return amount; }
    public void setAmount(BigDecimal amount)    { this.amount = amount; }

    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }

    public String getStatus()                   { return status; }
    public void setStatus(String status)        { this.status = status; }

    public Timestamp getCreatedAt()             { return createdAt; }
    public void setCreatedAt(Timestamp ts)      { this.createdAt = ts; }

    public String getFromName()                 { return fromName; }
    public void setFromName(String name)        { this.fromName = name; }

    public String getToName()                   { return toName; }
    public void setToName(String name)          { this.toName = name; }
}
