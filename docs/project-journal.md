# Project Journal - Dashboard Access Tracker

## 2026-05-11 - Project Planning + Database Design

### Initial Project Vision
Planned and began development of an internal dashboard access tracking system to replace manual email/request workflows for third-party dashboard access management.

### Business Workflow Goals
Current manual process:
1. Contract manager requests dashboard access
2. IT manually emails third-party support
3. Access changes are difficult to track historically
4. No centralized workflow visibility

Planned automation goals:
- Centralized request tracking
- SQL Server relational database
- Outlook email workflow automation
- Historical auditing/logging
- Cleaner onboarding/offboarding process
- Portfolio-quality internal business application

### Initial Database Design
Planned relational structure for:
- Dashboard users
- Clients
- Contract managers
- Access requests
- Request/client relationships
- Email logging

### Important Early Design Decisions
- SQL Server as backend database
- Python for workflow orchestration
- Outlook integration using Python
- Stored procedures for business logic
- Modular project structure for scalability

---

## 2026-05-12 - SQL Database Foundation + GitHub Setup

### Database Setup Completed
Created SQL Server database:
- `Dashboard_User_Access`

Created core tables:
- DashboardUsers
- Clients
- ContractManagers
- AccessRequests
- AccessRequestClients
- EmailLog

Added:
- primary keys
- foreign keys
- unique constraints
- default timestamps
- relational integrity rules

### SQL Development Completed
Created:
- sample data insert scripts
- SQL test scripts
- SQL views for reporting

Views created:
- vw_UserClientAccess
- vw_AccessRequests
- vw_AccessRequestClients
- vw_EmailLog

### Stored Procedures Created
- usp_CreateDashboardUser
- usp_CreateAccessRequest
- usp_AddClientToAccessRequest
- usp_LogAccessRequestEmail

### SQL Testing + Debugging
Learned importance of:
- resetting test data
- validating stored procedure outputs
- debugging relational dependencies
- testing workflow sequence order

Resolved issues involving:
- duplicate key violations
- foreign key conflicts
- view recreation problems
- invalid column references
- output parameter handling

### GitHub + Project Structure Setup
Initialized local Git repository.

Created GitHub repository:
- `dashboard-access-tracker`

Created organized project folders:
- sql/
- src/
- notebooks/
- docs/

Created initial documentation files:
- README.md
- .gitignore
- project_journal.md

### Git Concepts Learned
- tracked vs staged files
- commits vs pushes
- importance of modular folder structure
- importance of saving all files before testing/running

---

## 2026-05-13 - Python Environment + SQL Server Integration

### Python Environment Setup
Created and configured:
- `.venv` virtual environment

Configured:
- VS Code Python interpreter
- integrated terminal workflow
- Jupyter notebook support

### Python Packages Installed
Installed:
- pyodbc
- pandas
- jupyter
- pywin32

### Jupyter Notebook Setup
Created:
- `access_tracker_walkthrough.ipynb`

Notebook demonstrates:
- SQL Server connectivity
- querying SQL views
- pandas DataFrame usage
- workflow walkthrough examples
- future reporting concepts

### SQL Server Connectivity
Created:
- `src/db_connection.py`

Successfully:
- connected Python to SQL Server
- built reusable database connection function
- tested SQL Server connectivity from Python

Troubleshot:
- server naming issues
- ODBC driver issues
- virtual environment package isolation
- import path issues
- VS Code execution/debugging issues

### Important Python Concepts Learned
- difference between notebooks and Python scripts
- importance of virtual environments
- reusable connection modules
- imports and execution context
- Save All workflow habits
- dependency isolation

---

## 2026-05-13 - Workflow Automation + Outlook Integration

### Python Workflow Modules Created

#### db_connection.py
Responsible for:
- reusable SQL Server connectivity

#### request_workflow.py
Responsible for:
- workflow orchestration
- business process coordination

#### email_generator.py
Responsible for:
- generating formatted email subject/body content

#### outlook_email.py
Responsible for:
- Outlook COM automation
- Outlook draft creation

### Workflow Functions Created
- create_dashboard_user()
- create_access_request()
- add_client_to_access_request()
- log_access_request_email()
- generate_access_request_email()
- send_access_request_email()
- process_access_request()

### Full Workflow Successfully Automated
Successfully built end-to-end workflow automation for:
1. Create/retrieve dashboard user
2. Create access request
3. Attach one or more client relationships
4. Generate formatted email content
5. Open Outlook email draft automatically
6. Log email activity into SQL Server
7. Return completed AccessRequestID

### Outlook Integration Success
Successfully integrated:
- `win32com.client`

Program successfully:
- opened Outlook drafts automatically
- generated formatted email subject/body
- displayed fake/sample access request workflow emails

### Important Software Engineering Concepts Learned
- separation of concerns
- workflow orchestration
- infrastructure vs orchestration layers
- external integration layers
- fail-fast workflow handling
- defensive programming
- resource cleanup using `finally`
- reusable functions
- modular architecture
- parameterized SQL queries
- centralized timestamp handling

### Major Architecture Realization
Project evolved from:
- isolated SQL scripts

Into:
- a modular backend workflow automation system using:
  - SQL Server
  - Python
  - Stored Procedures
  - Outlook Automation
  - Relational Database Design
  - Workflow Orchestration

### Major Workflow Architecture Layers
Infrastructure layer:
- db_connection.py

Workflow orchestration layer:
- request_workflow.py

Communication formatting layer:
- email_generator.py

External integration layer:
- outlook_email.py

---

## Planned Next Steps

### Immediate Next Steps
- Create requirements.txt
- Improve README documentation
- Add workflow diagrams
- Expand notebook walkthrough
- Add request status update logic
- Improve email logging/status handling
- Add reporting queries/views

### Future Enhancements
- GUI/web interface
- batch access request support
- manager notification workflows
- approval workflows
- automatic email sending
- Power BI reporting integration
- coworker collaboration improvements

### Long-Term Goal
Prepare a presentation/demo walkthrough for DBA team showing:
- database architecture
- workflow automation
- Python orchestration
- Outlook integration
- business process improvements