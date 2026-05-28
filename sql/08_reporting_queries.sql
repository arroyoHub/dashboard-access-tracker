/*
====================================================
Dashboard Access Tracker - Reporting Queries
====================================================
Purpose:
Operational reporting queries for access request tracking,
dashboard user visibility, client access review, and workflow monitoring.
====================================================
*/

----------------------------------------------------
-- 1. Pending Access Requests
----------------------------------------------------

SELECT 
    AccessRequestID,
    DashboardUserID,
    ContractManagerID,
    RequestType,
    RequestStatus,
    Notes,
    DateRequested,
    DateEmailSent,
    DateCompleted
FROM dbo.AccessRequests
WHERE RequestStatus = 'Pending'

----------------------------------------------------
-- 2. Active Dashboard Users
----------------------------------------------------

SELECT
    DashboardUserID,
    FirstName,
    LastName,
    Email,
    DateCreated,
    DateModified
FROM dbo.DashboardUsers
WHERE IsActive = 1
ORDER BY LastName, FirstName

----------------------------------------------------
-- 3. Access Requests Submitted in 2026
----------------------------------------------------

SELECT
    ar.AccessRequestID,
    du.FirstName,
    du.LastName,
    du.Email,
    ar.RequestType,
    ar.RequestStatus,
    ar.DateRequested,
    ar.DateEmailSent,
    ar.DateCompleted
FROM dbo.AccessRequests ar
JOIN dbo.DashboardUsers du
    ON ar.DashboardUserID = du.DashboardUserID
WHERE ar.DateRequested >= '2026-01-01' AND ar.DateRequested < '2027-01-01'
ORDER BY ar.DateRequested DESC;

----------------------------------------------------
-- 4. Users by Client Access
----------------------------------------------------

SELECT
    du.DashboardUserID,
    du.FirstName,
    du.LastName,
    du.Email,
    c.ClientID,
    c.ClientCode,
    c.ClientName
    ar.AccessRequestID,
    ar.RequestStatus
FROM dbo.DashboardUsers du
JOIN dbo.AccessRequests ar
    ON du.DashboardUserID = ar.DashboardUserID
JOIN dbo.AccessRequestClients arc
    ON ar.AccessRequestID = arc.AccessRequestID
JOIN dbo.Clients c
    ON arc.ClientID = c.ClientID
WHERE ar.RequestStatus = 'Completed'
ORDER BY
    du.LastName,
    du.FirstName,
    c.ClientCode;

----------------------------------------------------
-- 5. Requests by Contract Manager
----------------------------------------------------

SELECT
    cm.ContractManagerID,
    cm.FirstName,
    cm.LastName,
    cm.Email,
    COUNT(ar.AccessRequestID) AS TotalRequests
FROM dbo.ContractManagers cm
LEFT JOIN dbo.AccessRequests ar
    ON cm.ContractManagerID = ar.ContractManagerID
GROUP BY cm.ContractManagerID, cm.FirstName, cm.LastName, cm.Email
ORDER BY TotalRequests DESC;

----------------------------------------------------
-- 6. Monthly Access Request Trends (Last 12 Months)
----------------------------------------------------
SELECT
    YEAR(DateRequested) AS RequestYear,
    MONTH(DateRequested) AS RequestMonth,
    COUNT(AccessRequestID) AS TotalRequests
FROM dbo.AccessRequests
WHERE DateRequested >= DATEADD(MONTH, -12, GETDATE())
GROUP BY YEAR(DateRequested), MONTH(DateRequested)
ORDER BY RequestYear, RequestMonth;

----------------------------------------------------
-- 7. Total Access Requests by Status
----------------------------------------------------
SELECT
    RequestStatus,
    COUNT(AccessRequestID) AS TotalRequests
FROM dbo.AccessRequests
GROUP BY RequestStatus
ORDER BY TotalRequests DESC;