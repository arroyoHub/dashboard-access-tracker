/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Script: 06_test_stored_procedures.sql

Description:
Test script used to validate stored procedures,
relationships, workflow automation,
and reporting views.
===========================================================
*/

USE Dashboard_User_Access;
GO

/*
===========================================================
Variable Declarations
===========================================================
*/

DECLARE @NewDashboardUserID INT;
DECLARE @NewAccessRequestID INT;

/*
===========================================================
Test 1: Create Dashboard User
===========================================================
*/

EXEC dbo.usp_CreateDashboardUser
    @FirstName = 'Robert',
    @LastName = 'Miller',
    @Email = 'robert.miller@example.com',
    @DashboardUserID = @NewDashboardUserID OUTPUT;

SELECT @NewDashboardUserID AS DashboardUserID;

SELECT *
FROM dbo.DashboardUsers
WHERE DashboardUserID = @NewDashboardUserID;
GO

/*
===========================================================
Re-Declare Variables After GO

Important:
Variables are cleared after each GO batch separator.
===========================================================
*/

DECLARE @NewDashboardUserID INT;
DECLARE @NewAccessRequestID INT;

/*
===========================================================
Retrieve Existing DashboardUserID
===========================================================
*/

SELECT @NewDashboardUserID = DashboardUserID
FROM dbo.DashboardUsers
WHERE Email = 'robert.miller@example.com';

/*
===========================================================
Test 2: Create Access Request
===========================================================
*/

EXEC dbo.usp_CreateAccessRequest
    @DashboardUserID = @NewDashboardUserID,
    @ContractManagerID = 1,
    @RequestType = 'Add',
    @RequestStatus = 'Draft',
    @RequestedBy = 'Christian Arroyo',
    @Notes = 'Testing stored procedure workflow',
    @AccessRequestID = @NewAccessRequestID OUTPUT;

SELECT @NewAccessRequestID AS AccessRequestID;

SELECT *
FROM dbo.AccessRequests
WHERE AccessRequestID = @NewAccessRequestID;
GO

/*
===========================================================
Re-Declare Variables After GO
===========================================================
*/

DECLARE @NewAccessRequestID INT;

/*
===========================================================
Retrieve Latest AccessRequestID
===========================================================
*/

SELECT TOP 1
    @NewAccessRequestID = AccessRequestID
FROM dbo.AccessRequests
ORDER BY AccessRequestID DESC;

/*
===========================================================
Test 3: Add Client To Access Request
===========================================================
*/

EXEC dbo.usp_AddClientToAccessRequest
    @AccessRequestID = @NewAccessRequestID,
    @ClientID = 3;

SELECT *
FROM dbo.vw_AccessRequestClients
WHERE AccessRequestID = @NewAccessRequestID;
GO

/*
===========================================================
Re-Declare Variables After GO
===========================================================
*/

DECLARE @NewAccessRequestID INT;

/*
===========================================================
Retrieve Latest AccessRequestID
===========================================================
*/

SELECT TOP 1
    @NewAccessRequestID = AccessRequestID
FROM dbo.AccessRequests
ORDER BY AccessRequestID DESC;

/*
===========================================================
Test 4: Log Request Email
===========================================================
*/

EXEC dbo.usp_LogAccessRequestEmail
    @AccessRequestID = @NewAccessRequestID,
    @EmailType = 'Add',
    @SentTo = 'thirdparty.support@example.com',
    @SentCC = 'itg.team@example.com',
    @SubjectLine = 'Dashboard Access Request - Robert Miller',
    @BodyText = 'Please provide dashboard access for Robert Miller to CLIENT003.';

/*
===========================================================
Validate Email Log
===========================================================
*/

SELECT *
FROM dbo.vw_EmailLog
WHERE AccessRequestID = @NewAccessRequestID;

/*
===========================================================
Validate Access Request Status Update
===========================================================
*/

SELECT *
FROM dbo.vw_AccessRequests
WHERE AccessRequestID = @NewAccessRequestID;
GO

/*
===========================================================
Test 5: Mark request as completed
===========================================================
*/

DECLARE @LatestAccessRequestID INT;

SELECT TOP 1
    @LatestAccessRequestID = AccessRequestID
FROM dbo.AccessRequests
ORDER BY AccessRequestID DESC;

EXEC dbo.usp_MarkAccessRequestCompleted
    @AccessRequestID = @LatestAccessRequestID;

SELECT *
FROM dbo.vw_AccessRequests
WHERE AccessRequestID = @LatestAccessRequestID;
GO