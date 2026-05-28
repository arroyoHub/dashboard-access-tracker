/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Author: Christian Arroyo
Database: Dashboard_User_Access

Description:
This script creates the core relational database tables
used to track third-party dashboard access requests,
client access relationships, request history,
and email workflow activity.

Purpose:
- Track dashboard users
- Track client access requests
- Track contract manager requests
- Track request status lifecycle
- Preserve historical audit records
- Support future automation and reporting

Notes:
- Sample data should be inserted separately
- Views should be created separately
- Portfolio-safe version uses fake/sample data only
===========================================================
*/

USE Dashboard_User_Access;
GO

/*
===========================================================
Table: ContractManagers

Purpose:
Stores the contract managers responsible for requesting
dashboard access for users and client accounts.
===========================================================
*/

CREATE TABLE dbo.ContractManagers (
    ContractManagerID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    DateCreated DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/*
===========================================================
Table: DashboardUsers

Purpose:
Stores users who require access to the third-party dashboard.
===========================================================
*/

CREATE TABLE dbo.DashboardUsers (
    DashboardUserID INT IDENTITY(1,1) PRIMARY KEY,

    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
    DateModified DATETIME NULL
);
GO

/*
===========================================================
Table: Clients

Purpose:
Stores client accounts and client codes associated
with dashboard access permissions.
===========================================================
*/

CREATE TABLE dbo.Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,

    ClientCode VARCHAR(50) NOT NULL UNIQUE,
    ClientName VARCHAR(255) NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    DateCreated DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/*
===========================================================
Table: AccessRequests

Purpose:
Stores individual dashboard access requests.

Each request is associated with:
- One dashboard user
- One contract manager
- One request type/status workflow

Examples:
- Add access
- Modify access
- Remove access
===========================================================
*/

CREATE TABLE dbo.AccessRequests (
    AccessRequestID INT IDENTITY(1,1) PRIMARY KEY,

    DashboardUserID INT NOT NULL,
    ContractManagerID INT NULL,

    RequestType VARCHAR(25) NOT NULL DEFAULT 'Add',
    RequestStatus VARCHAR(25) NOT NULL DEFAULT 'Draft',

    RequestedBy VARCHAR(255) NULL,
    Notes VARCHAR(MAX) NULL,

    DateRequested DATETIME NOT NULL DEFAULT GETDATE(),
    DateEmailSent DATETIME NULL,
    DateCompleted DATETIME NULL,

    CONSTRAINT FK_AccessRequests_DashboardUsers
        FOREIGN KEY (DashboardUserID)
        REFERENCES dbo.DashboardUsers(DashboardUserID),

    CONSTRAINT FK_AccessRequests_ContractManagers
        FOREIGN KEY (ContractManagerID)
        REFERENCES dbo.ContractManagers(ContractManagerID)
);
GO

/*
===========================================================
Table: AccessRequestClients

Purpose:
Junction table connecting access requests
to requested client access.

This supports:
- One request -> many clients
- One client -> many requests

Business Rule:
Prevent duplicate client assignments
within the same request.
===========================================================
*/

CREATE TABLE dbo.AccessRequestClients (
    AccessRequestClientID INT IDENTITY(1,1) PRIMARY KEY,

    AccessRequestID INT NOT NULL,
    ClientID INT NOT NULL,

    CONSTRAINT FK_AccessRequestClients_AccessRequests
        FOREIGN KEY (AccessRequestID)
        REFERENCES dbo.AccessRequests(AccessRequestID),

    CONSTRAINT FK_AccessRequestClients_Clients
        FOREIGN KEY (ClientID)
        REFERENCES dbo.Clients(ClientID),

    CONSTRAINT UQ_AccessRequest_Client
        UNIQUE (AccessRequestID, ClientID)
);
GO

/*
===========================================================
Table: UserClientAccess

Purpose:
Tracks active and historical dashboard access
between users and clients.

This table represents actual access relationships,
not just requests.

Supports:
- Access activation tracking
- Access removal tracking
- Historical audit retention
===========================================================
*/

CREATE TABLE dbo.UserClientAccess (
    UserClientAccessID INT IDENTITY(1,1) PRIMARY KEY,

    DashboardUserID INT NOT NULL,
    ClientID INT NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    DateAccessRequested DATETIME NOT NULL DEFAULT GETDATE(),
    DateAccessConfirmed DATETIME NULL,
    DateAccessRemoved DATETIME NULL,

    CONSTRAINT FK_UserClientAccess_DashboardUsers
        FOREIGN KEY (DashboardUserID)
        REFERENCES dbo.DashboardUsers(DashboardUserID),

    CONSTRAINT FK_UserClientAccess_Clients
        FOREIGN KEY (ClientID)
        REFERENCES dbo.Clients(ClientID),

    CONSTRAINT UQ_User_Client_Access
        UNIQUE (DashboardUserID, ClientID)
);
GO

/*
===========================================================
Table: EmailLog

Purpose:
Tracks emails sent to the third-party provider
related to dashboard access activity.

Supports:
- Audit history
- Troubleshooting
- Request traceability
===========================================================
*/

CREATE TABLE dbo.EmailLog (
    EmailLogID INT IDENTITY(1,1) PRIMARY KEY,

    AccessRequestID INT NULL,

    EmailType VARCHAR(25) NOT NULL,

    SentTo VARCHAR(255) NOT NULL,
    SentCC VARCHAR(255) NULL,

    SubjectLine VARCHAR(255) NOT NULL,
    BodyText VARCHAR(MAX) NOT NULL,

    DateSent DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_EmailLog_AccessRequests
        FOREIGN KEY (AccessRequestID)
        REFERENCES dbo.AccessRequests(AccessRequestID)
);
GO

/*
===========================================================
Table: UserClientAccess

Purpose:
Tracks actual dashboard access granted between
users and clients.

Supports:
- Active access tracking
- Access audit history
- Access lifecycle management
- Reporting visibility
===========================================================
*/

CREATE TABLE dbo.UserClientAccess (
    UserClientAccessID INT IDENTITY(1,1) PRIMARY KEY,

    AccessRequestID INT NULL,

    DashboardUserID INT NOT NULL,
    ClientID INT NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    DateAccessRequested DATETIME NULL,
    DateAccessConfirmed DATETIME NULL,
    DateAccessRemoved DATETIME NULL,

    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NULL,

    CONSTRAINT FK_UserClientAccess_AccessRequests
        FOREIGN KEY (AccessRequestID)
        REFERENCES dbo.AccessRequests(AccessRequestID),

    CONSTRAINT FK_UserClientAccess_DashboardUsers
        FOREIGN KEY (DashboardUserID)
        REFERENCES dbo.DashboardUsers(DashboardUserID),

    CONSTRAINT FK_UserClientAccess_Clients
        FOREIGN KEY (ClientID)
        REFERENCES dbo.Clients(ClientID)
);
GO