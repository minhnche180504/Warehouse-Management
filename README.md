# Warehouse-Management
Comprehensive warehouse management web app built with Java EE and JSP. Supports role-based dashboards for admin, manager, staff to manage inventory, purchasing, sales, and real-time stock tracking.
📦 Warehouse Management System

A Java EE web application for managing warehouse operations such as inventory tracking, purchasing, sales, and staff workflows.
The system supports multiple roles (Admin, Manager, Staff) with tailored dashboards and tools to streamline daily logistics tasks.

🚀 Features

🔐 Role-based access for administrators, managers, and staff

📦 Real-time inventory monitoring with low-stock alerts

🧾 Purchase request management and approval flows

💰 Sales order tracking with detailed order views

🔄 Stock adjustment, transfer, and reporting dashboards

👤 User profile management and password reset flows

💻 Responsive UI built with JSP, JSTL, HTML/CSS, and JavaScript

🛠️ Tech Stack
Layer	Technology
Backend	Java EE (Servlets, JSP, JSTL)
Server	Apache Tomcat 9+
Database	Microsoft SQL Server (ISP392_DTB.sql)
Build Tool	Apache Ant / Maven
Frontend	Bootstrap 5, custom JS & CSS
Logging	Logback (src/conf/logback.xml)
🧩 Project Structure
src/           # Java source (controllers, DAO, models, utils)
web/           # JSP views, static assets, WEB-INF config
lib/           # External JAR dependencies
build.xml      # Ant build script
dist/          # Generated WAR artifacts (if built)
ISP392_DTB.sql # Database schema and seed data

⚙️ Getting Started
1️⃣ Prerequisites

☕ JDK 8 or higher

🧱 Apache Tomcat 9+

🗃️ Microsoft SQL Server (import ISP392_DTB.sql)

🔧 Ant or Maven (for build management)

2️⃣ Setup
# Import project into your IDE (IntelliJ / NetBeans / Eclipse)
# Configure DB credentials in DAO or config class
# Build and deploy:
ant war
# or use IDE deployment tools


Then place the generated .war file into Tomcat’s /webapps folder.

3️⃣ Run

Start Tomcat and open:

http://localhost:8080/Warehouse


(Adjust context path if necessary.)

🧪 Testing

A small suite of DAO-level tests is located under:

test/java/


Before running tests, configure database access credentials accordingly.

🤝 Contributing

Fork this repository

Create a new branch

git checkout -b feature/your-feature-name


Commit with clear messages

Open a Pull Request describing your changes and testing steps

📜 License

Specify your license here (e.g., MIT, Apache 2.0, etc.)

✨ Maintained with ❤️ by the Warehouse Management Development Team.
