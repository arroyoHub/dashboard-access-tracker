/*
====================================================
Dashboard Access Tracker - Test Queries
====================================================
Purpose:
Reusable validation queries for checking database records,
relationships, workflow status, email logs, and reporting views.
====================================================
*/

USE Dashboard_User_Access

----------------------------------------------------
-- Core Tables
----------------------------------------------------

SELECT *
FROM dbo.DashboardUsers;

SELECT *
FROM dbo.Clients;

SELECT *
FROM dbo.ContractManagers;

SELECT *
FROM dbo.AccessRequests;

SELECT *
FROM dbo.AccessRequestClients;

SELECT *
FROM dbo.EmailLog;

----------------------------------------------------
-- Access Request Status Checks
----------------------------------------------------

SELECT
    AccessRequestID,
    DashboardUserID,
    RequestStatus,
    Notes,
    DateRequested,
    DateEmailSent,
    DateCompleted
FROM dbo.AccessRequests
ORDER BY AccessRequestID DESC;

----------------------------------------------------
-- Email Log Checks
----------------------------------------------------

SELECT
    EmailLogID,
    AccessRequestID,
    SentTo,
    SentCC,
    SubjectLine,
    BodyText,
    DateSent
FROM dbo.EmailLog
ORDER BY EmailLogID DESC;

----------------------------------------------------
-- Views
----------------------------------------------------

SELECT *
FROM dbo.vw_AccessRequests;

SELECT *
FROM dbo.vw_AccessRequestClients;

SELECT *
FROM dbo.vw_EmailLog;

SELECT *
FROM dbo.vw_UserClientAccess;

----------------------------------------------------
-- Stored Procedure Test: Status Update
----------------------------------------------------

EXEC dbo.usp_UpdateAccessRequestStatus
    @AccessRequestID = 1,
    @RequestStatus = 'Pending',
    @Notes = 'Testing status update logic from SQL test script.';

SELECT
    AccessRequestID,
    RequestStatus,
    Notes
FROM dbo.AccessRequests
WHERE AccessRequestID = 1;