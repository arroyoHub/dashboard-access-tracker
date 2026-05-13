# Third-Party Dashboard Access Tracker

## Project Overview

This project is a relational database and workflow automation system designed to track third-party dashboard access requests.

The original business process relied heavily on:
- Manual emails
- Spreadsheet tracking
- Limited audit visibility
- No centralized relational database structure

This project improves:
- Access request tracking
- Client access relationships
- Workflow visibility
- Email logging
- Historical auditing
- Future automation readiness

The system was designed as a portfolio-safe demonstration project using fake/sample data only.

---

## Business Problem

Contract managers request dashboard access for users who need visibility into specific client accounts.

The actual dashboard access is managed externally by a third-party provider. Internal teams must:
- Receive the request
- Track the request
- Email the third-party provider
- Track request status
- Track which users have access to which clients

Originally, this process was tracked primarily through spreadsheets and email history.

---

## Project Goals

- Build a normalized relational database in SQL Server
- Create reusable reporting views
- Create stored procedures for workflow automation
- Prepare the system for Python and Outlook automation
- Build a future GUI for internal request management
- Create a portfolio-quality backend systems project

---

## Technologies Used

- SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- VS Code
- GitHub
- Python (planned)
- Jupyter Notebook (planned)
- Outlook Automation (planned)

---

## Database Design Concepts Used

- Relational database design
- Primary keys
- Foreign keys
- Junction tables
- Many-to-many relationships
- Views
- Stored procedures
- Workflow state tracking
- Audit logging

---

## Database Workflow

Dashboard User Request Flow:

1. Contract manager requests dashboard access
2. Internal team creates dashboard user record
3. Internal team creates access request
4. Requested client relationships are added
5. Email is sent to third-party provider
6. Email activity is logged
7. Request is marked completed after confirmation

---

## Current Database Objects

### Tables

- ContractManagers
- DashboardUsers
- Clients
- AccessRequests
- AccessRequestClients
- UserClientAccess
- EmailLog

### Views

- vw_UserClientAccess
- vw_AccessRequests
- vw_AccessRequestClients
- vw_EmailLog

### Stored Procedures

- usp_CreateDashboardUser
- usp_CreateAccessRequest
- usp_AddClientToAccessRequest
- usp_LogAccessRequestEmail
- usp_MarkAccessRequestCompleted

---

## Project Structure

```text
third-party-dashboard-access-tracker/
│
├── README.md
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_sample_data.sql
│   ├── 03_create_views.sql
│   ├── 04_test_queries.sql
│   ├── 05_stored_procedures.sql
│   └── 06_test_stored_procedures.sql
│
├── notebooks/
│
├── src/
│
├── docs/
│
└── sample_data/
```

---

## Portfolio Safety

This repository contains:
- Fake names
- Fake emails
- Fake client codes
- No company data
- No internal server names
- No production credentials

This project is intended strictly for educational and portfolio demonstration purposes.

---

## Future Enhancements

Planned future improvements include:
- Python database integration
- Outlook email automation
- Jupyter Notebook workflow walkthrough
- GUI interface
- Dashboard analytics
- Reporting automation
- Access removal workflow
- Role-based access tracking

---

## Author

Christian Arroyo

GitHub:
https://github.com/arroyoHub