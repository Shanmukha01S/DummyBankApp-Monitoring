# 🏦 DummyBankApp

A simulated banking web application built for **Middleware/DevOps practice**.  
Demonstrates a real-world deployment setup: Java Web App → Maven Build → Jenkins CI/CD → Tomcat/WebLogic → Nginx Load Balancer → AWS EC2.

---

## 🏗️ Architecture

```
Developer Machine
      │
      │  git push
      ▼
   GitHub Repo
      │
      │  webhook trigger
      ▼
  Jenkins Server  ──── mvn clean package ────▶  DummyBankApp.war
      │
      │  scp WAR file
      ▼
┌─────────────────────────────────────────┐
│           AWS Cloud                      │
│                                          │
│    ┌─────────┐    ┌──────────────────┐  │
│    │  Nginx  │───▶│  Tomcat / WL - 1 │  │
│    │   :80   │    │     :8080        │  │
│    │  (LB)   │    └──────────────────┘  │
│    │         │    ┌──────────────────┐  │
│    │         │───▶│  Tomcat / WL - 2 │  │
│    └─────────┘    │     :8080        │  │
│                   └──────────────────┘  │
│                         │               │
│                   ┌─────▼──────┐        │
│                   │   MySQL    │        │
│                   │  :3306     │        │
│                   └────────────┘        │
└─────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
DummyBankApp/
├── pom.xml                          Maven build config
├── Jenkinsfile                      CI/CD pipeline
├── nginx-loadbalancer.conf          Nginx LB config
├── database_setup.sql               DB setup script
│
└── src/main/
    ├── java/com/bank/
    │   ├── util/
    │   │   └── DBConnection.java    Database connection
    │   ├── model/
    │   │   ├── User.java            User data model
    │   │   └── Transaction.java     Transaction model
    │   ├── dao/
    │   │   ├── UserDAO.java         User DB operations
    │   │   └── TransactionDAO.java  Transaction DB ops
    │   └── servlet/
    │       ├── LoginServlet.java    Handles login
    │       ├── DashboardServlet.java Shows dashboard
    │       ├── TransferServlet.java  Money transfer
    │       ├── TransactionHistoryServlet.java
    │       └── LogoutServlet.java   Logout
    │
    └── webapp/
        ├── index.jsp                Redirects to login
        └── WEB-INF/
            ├── web.xml              Deployment descriptor
            └── views/
                ├── login.jsp
                ├── dashboard.jsp
                ├── transfer.jsp
                ├── history.jsp
                └── error.jsp
```

---

## 🚀 Setup Guide (Phase by Phase)

---

### ✅ Phase 1 — Run Locally (WSL/Laptop)

**Prerequisites:**
- Java 11+
- Maven 3.6+
- MySQL 8+
- Tomcat 9+ (or WebLogic)

**Step 1: Setup Database**
```bash
mysql -u root -p < database_setup.sql
```

**Step 2: Update DB password in DBConnection.java**
```java
private static final String DB_PASSWORD = "your_mysql_password";
```

**Step 3: Build with Maven**
```bash
cd DummyBankApp
mvn clean package
# Output: target/DummyBankApp.war
```

**Step 4: Deploy to Tomcat**
```bash
cp target/DummyBankApp.war /opt/tomcat/webapps/
# Tomcat auto-deploys the WAR
```

**Step 5: Access the app**
```
http://localhost:8080/DummyBankApp/login
```

**Login credentials:**
| Username   | Password     | Balance    |
|------------|-------------|------------|
| shanmukha  | Password@123 | ₹50,000   |
| testuser   | Password@123 | ₹25,000   |

---

### ✅ Phase 2 — Jenkins CI/CD Pipeline

**Step 1: Install Jenkins**
```bash
# On Ubuntu (WSL or EC2)
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
# Access: http://localhost:8080 (Jenkins)
```

**Step 2: Create Pipeline Job**
1. Jenkins → New Item → Pipeline
2. Pipeline Definition: "Pipeline script from SCM"
3. SCM: Git → your GitHub repo URL
4. Script Path: `Jenkinsfile`
5. Save → Build Now

**Step 3: Watch the stages run**
```
[Checkout] ✅ → [Build] ✅ → [Test] ✅ → [Archive] ✅ → [Deploy] ✅ → [Smoke Test] ✅
```

---

### ✅ Phase 3 — AWS EC2 Deployment

**EC2 Setup (minimal for practice):**

| Instance | Purpose         | Instance Type |
|----------|-----------------|---------------|
| EC2-1    | App Server      | t2.micro      |
| EC2-2    | App Server      | t2.micro      |
| EC2-3    | Nginx LB        | t2.micro      |
| EC2-4    | MySQL DB        | t2.micro      |

**Step 1: Launch EC2 instances (Ubuntu 22.04)**

**Step 2: Install Tomcat on EC2-1 and EC2-2**
```bash
sudo apt update
sudo apt install -y openjdk-11-jdk
# Download and install Tomcat 9
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.x/bin/apache-tomcat-9.0.x.tar.gz
tar -xzf apache-tomcat-*.tar.gz
sudo mv apache-tomcat-* /opt/tomcat
sudo /opt/tomcat/bin/startup.sh
```

**Step 3: Install Nginx on EC2-3**
```bash
sudo apt install -y nginx
sudo cp nginx-loadbalancer.conf /etc/nginx/conf.d/bankapp.conf
# Edit the upstream IPs to your EC2-1 and EC2-2 private IPs
sudo nginx -t
sudo systemctl reload nginx
```

**Step 4: Install MySQL on EC2-4**
```bash
sudo apt install -y mysql-server
sudo mysql_secure_installation
mysql -u root -p < database_setup.sql
# Allow remote connections (update bind-address in my.cnf)
```

**Step 5: Update Jenkins pipeline**  
Set `TOMCAT_HOST` to your EC2 IPs and configure SSH keys.

---

### ✅ Phase 4 — What to Show in Interviews

> *"I built a simulated banking application and deployed it end-to-end on AWS.  
> The app is a Java Servlet WAR deployed on Apache Tomcat across two EC2 instances.  
> Jenkins automates the full pipeline — code pushed to GitHub triggers a Maven build,  
> runs smoke tests, and deploys via SCP to both app servers.  
> Nginx acts as a load balancer distributing traffic using ip_hash for session persistence.  
> MySQL on a separate EC2 handles all transactional data with ACID-compliant transfers."*

---

## 🔑 Key Concepts Demonstrated

| Concept | Where Used |
|---------|-----------|
| MVC Pattern | Servlet (Controller) + JSP (View) + DAO/Model |
| Session Management | Login/Logout with HttpSession |
| ACID Transactions | TransactionDAO (commit/rollback) |
| SQL Injection Prevention | PreparedStatement throughout |
| Password Hashing | BCrypt in UserDAO |
| Load Balancing | Nginx with ip_hash |
| CI/CD Pipeline | Jenkinsfile (6 stages) |
| WAR Deployment | Maven packaging → Tomcat/WebLogic |
| Infrastructure as Code | Nginx config, Jenkinsfile in Git |

---

## 🛠️ Tech Stack

- **Language:** Java 11
- **Web:** Java Servlets + JSP + JSTL
- **Build:** Maven
- **Database:** MySQL 8
- **App Server:** Apache Tomcat 9 / Oracle WebLogic 12c
- **Load Balancer:** Nginx
- **CI/CD:** Jenkins Declarative Pipeline
- **Cloud:** AWS EC2
- **Security:** BCrypt password hashing, PreparedStatements

---

*Built by Shanmukha — Middleware/DevOps Engineer*
