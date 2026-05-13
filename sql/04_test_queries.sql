/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Script: 04_test_queries.sql

Description:
Test queries used to validate tables, relationships,
views, and sample data.
===========================================================
*/

USE Dashboard_User_Access;
GO

-- View all current user-client access relationships
SELECT *
FROM dbo.vw_UserClientAccess;
GO

-- View all access requests
SELECT *
FROM dbo.vw_AccessRequests;
GO

-- View all requested clients tied to each request
SELECT *
FROM dbo.vw_AccessRequestClients;
GO

-- View email log history
SELECT *
FROM dbo.vw_EmailLog;
GO

-- Find all clients for one dashboard user
SELECT
    FirstName,
    LastName,
    Email,
    ClientCode,
    ClientName
FROM dbo.vw_UserClientAccess
WHERE Email = 'jane.doe@example.com';
GO

-- Find all users with access to one client
SELECT
    ClientCode,
    ClientName,
    FirstName,
    LastName,
    Email
FROM dbo.vw_UserClientAccess
WHERE ClientCode = 'CLIENT001';
GO

-- Count active users per client
SELECT
    ClientCode,
    ClientName,
    COUNT(*) AS ActiveUserCount
FROM dbo.vw_UserClientAccess
WHERE IsActive = 1
GROUP BY
    ClientCode,
    ClientName
ORDER BY
    ActiveUserCount DESC;
GO

-- Find pending or incomplete requests
SELECT
    AccessRequestID,
    FirstName,
    LastName,
    Email,
    RequestType,
    RequestStatus,
    DateRequested,
    DateEmailSent,
    DateCompleted
FROM dbo.vw_AccessRequests
WHERE DateCompleted IS NULL;
GO