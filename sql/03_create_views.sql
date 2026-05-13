/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Script: 03_create_views.sql

Description:
Creates reporting views used to simplify queries,
support analysis, and prepare the database for
Python automation, Jupyter notebooks, and future dashboards.

Notes:
- Views do not store data
- Views display data from underlying tables
- These views are safe to use for portfolio demos with sample data
===========================================================
*/


USE Dashboard_User_Access;
GO

/*
===========================================================
View: vw_UserClientAccess

Purpose:
Shows which dashboard users have access to which clients.

Business question answered:
- What clients does each dashboard user have access to?
- Which users have access to a specific client?
===========================================================
*/

CREATE OR ALTER VIEW dbo.vw_UserClientAccess AS
SELECT
    uca.UserClientAccessID,
    u.DashboardUserID,
    u.FirstName,
    u.LastName,
    u.Email,
    c.ClientID,
    c.ClientCode,
    c.ClientName,
    uca.IsActive,
    uca.DateAccessRequested,
    uca.DateAccessConfirmed,
    uca.DateAccessRemoved
FROM dbo.UserClientAccess uca
INNER JOIN dbo.DashboardUsers u
    ON uca.DashboardUserID = u.DashboardUserID
INNER JOIN dbo.Clients c
    ON uca.ClientID = c.ClientID;
GO

/*
===========================================================
View: vw_AccessRequests

Purpose:
Shows access request details with dashboard user
and contract manager information.

Business question answered:
- Who requested dashboard access?
- Which dashboard user was the request for?
- What is the current request status?
===========================================================
*/

CREATE OR ALTER VIEW dbo.vw_AccessRequests AS
SELECT
    ar.AccessRequestID,
    du.DashboardUserID,
    du.FirstName,
    du.LastName,
    du.Email,
    cm.ContractManagerID,
    cm.FirstName + ' ' + cm.LastName AS ContractManager,
    cm.Email AS ContractManagerEmail,
    ar.RequestType,
    ar.RequestStatus,
    ar.RequestedBy,
    ar.Notes,
    ar.DateRequested,
    ar.DateEmailSent,
    ar.DateCompleted
FROM dbo.AccessRequests ar
INNER JOIN dbo.DashboardUsers du
    ON ar.DashboardUserID = du.DashboardUserID
LEFT JOIN dbo.ContractManagers cm
    ON ar.ContractManagerID = cm.ContractManagerID;
GO

/*
===========================================================
View: vw_AccessRequestClients

Purpose:
Shows each requested client tied to each access request.

Business question answered:
- Which client codes were included in each request?
- Which requests included a specific client?
===========================================================
*/

CREATE OR ALTER VIEW dbo.vw_AccessRequestClients AS
SELECT
    ar.AccessRequestID,
    du.FirstName,
    du.LastName,
    du.Email,
    c.ClientID,
    c.ClientCode,
    c.ClientName,
    ar.RequestType,
    ar.RequestStatus,
    ar.DateRequested,
    ar.DateEmailSent,
    ar.DateCompleted
FROM dbo.AccessRequests ar
INNER JOIN dbo.DashboardUsers du
    ON ar.DashboardUserID = du.DashboardUserID
INNER JOIN dbo.AccessRequestClients arc
    ON ar.AccessRequestID = arc.AccessRequestID
INNER JOIN dbo.Clients c
    ON arc.ClientID = c.ClientID;
GO

/*
===========================================================
View: vw_EmailLog

Purpose:
Shows email history connected to access requests.

Business question answered:
- What emails were sent for each access request?
- When were emails sent?
- What subject/body was used?
===========================================================
*/

CREATE OR ALTER VIEW dbo.vw_EmailLog AS
SELECT
    el.EmailLogID,
    el.AccessRequestID,
    du.FirstName,
    du.LastName,
    du.Email AS DashboardUserEmail,
    el.EmailType,
    el.SentTo,
    el.SentCC,
    el.SubjectLine,
    el.BodyText,
    el.DateSent
FROM dbo.EmailLog el
LEFT JOIN dbo.AccessRequests ar
    ON el.AccessRequestID = ar.AccessRequestID
LEFT JOIN dbo.DashboardUsers du
    ON ar.DashboardUserID = du.DashboardUserID;
GO
