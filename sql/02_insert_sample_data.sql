/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Script: 02_insert_sample_data.sql

Description:
This script inserts portfolio-safe sample data
used for testing relationships, views, reporting,
and future Python automation workflows.

Notes:
- All names/emails/client codes are fake
- Safe for GitHub and portfolio demonstrations
===========================================================
*/

USE Dashboard_User_Access;
GO

/*
===========================================================
Insert Sample Contract Managers
===========================================================
*/

INSERT INTO dbo.ContractManagers
(
    FirstName,
    LastName,
    Email
)
VALUES
('Sarah', 'Johnson', 'sarah.johnson@example.com'),

('Michael', 'Rivera', 'michael.rivera@example.com'),

('Ashley', 'Turner', 'ashley.turner@example.com');
GO

/*
===========================================================
Insert Sample Dashboard Users
===========================================================
*/

INSERT INTO dbo.DashboardUsers
(
    FirstName,
    LastName,
    Email
)
VALUES
('Jane', 'Doe', 'jane.doe@example.com'),

('John', 'Smith', 'john.smith@example.com'),

('Emily', 'Davis', 'emily.davis@example.com');
GO

/*
===========================================================
Insert Sample Clients
===========================================================
*/

INSERT INTO dbo.Clients
(
    ClientCode,
    ClientName
)
VALUES
('CLIENT001', 'Sample Client One'),

('CLIENT002', 'Sample Client Two'),

('CLIENT003', 'Sample Client Three'),

('CLIENT004', 'Sample Client Four');
GO

/*
===========================================================
Insert Sample Access Requests
===========================================================
*/

INSERT INTO dbo.AccessRequests
(
    DashboardUserID,
    ContractManagerID,
    RequestType,
    RequestStatus,
    RequestedBy,
    Notes
)
VALUES
(
    1,
    1,
    'Add',
    'Draft',
    'Christian Arroyo',
    'Initial dashboard access request for Jane Doe'
),

(
    2,
    2,
    'Add',
    'Email Sent',
    'Christian Arroyo',
    'Access request submitted to third-party support'
),

(
    3,
    3,
    'Modify',
    'Completed',
    'Christian Arroyo',
    'Additional client access granted'
);
GO

/*
===========================================================
Insert Sample Request Client Relationships

Purpose:
Connects requests to one or more client accounts
===========================================================
*/

INSERT INTO dbo.AccessRequestClients
(
    AccessRequestID,
    ClientID
)
VALUES
(1, 1),
(1, 2),

(2, 2),
(2, 3),

(3, 1),
(3, 4);
GO

/*
===========================================================
Insert Sample User Client Access Relationships

Purpose:
Represents actual dashboard access relationships
===========================================================
*/

INSERT INTO dbo.UserClientAccess
(
    DashboardUserID,
    ClientID,
    IsActive,
    DateAccessConfirmed
)
VALUES
(
    1,
    1,
    1,
    GETDATE()
),

(
    1,
    2,
    1,
    GETDATE()
),

(
    2,
    2,
    1,
    GETDATE()
),

(
    2,
    3,
    1,
    GETDATE()
),

(
    3,
    1,
    1,
    GETDATE()
),

(
    3,
    4,
    1,
    GETDATE()
);
GO

/*
===========================================================
Insert Sample Email Log Records
===========================================================
*/

INSERT INTO dbo.EmailLog
(
    AccessRequestID,
    EmailType,
    SentTo,
    SentCC,
    SubjectLine,
    BodyText
)
VALUES
(
    1,
    'Add',
    'thirdparty.support@example.com',
    'itg.team@example.com',
    'Dashboard Access Request - Jane Doe',
    'Please provide dashboard access for Jane Doe to CLIENT001 and CLIENT002.'
),

(
    2,
    'Add',
    'thirdparty.support@example.com',
    'itg.team@example.com',
    'Dashboard Access Request - John Smith',
    'Please provide dashboard access for John Smith to CLIENT002 and CLIENT003.'
);
GO