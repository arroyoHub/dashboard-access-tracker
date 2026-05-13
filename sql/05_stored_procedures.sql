/*
===========================================================
Project: Third-Party Dashboard Access Tracker
Script: 05_stored_procedures.sql

Description:
Creates stored procedures that support cleaner inserts,
future Python automation, and repeatable request workflows.
===========================================================
*/

USE Dashboard_User_Access;
GO

/*
===========================================================
Procedure: usp_CreateDashboardUser

Purpose:
Creates a dashboard user if the email does not already exist.
Returns the DashboardUserID.
===========================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_CreateDashboardUser
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Email VARCHAR(255),
    @DashboardUserID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @DashboardUserID = DashboardUserID
    FROM dbo.DashboardUsers
    WHERE Email = @Email;

    IF @DashboardUserID IS NULL
    BEGIN
        INSERT INTO dbo.DashboardUsers
        (
            FirstName,
            LastName,
            Email
        )
        VALUES
        (
            @FirstName,
            @LastName,
            @Email
        );

        SET @DashboardUserID = SCOPE_IDENTITY();
    END
END;
GO


/*
===========================================================
Procedure: usp_CreateAccessRequest

Purpose:
Creates a new dashboard access request.

Workflow:
- Creates a request tied to a dashboard user
- Associates the request with a contract manager
- Tracks request type and status
- Returns the new AccessRequestID

Future Use:
- Python automation
- Outlook email generation
- GUI integration
===========================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_CreateAccessRequest
    @DashboardUserID INT,
    @ContractManagerID INT,
    @RequestType VARCHAR(25),
    @RequestStatus VARCHAR(25),
    @RequestedBy VARCHAR(255),
    @Notes VARCHAR(MAX),
    @AccessRequestID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

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
        @DashboardUserID,
        @ContractManagerID,
        @RequestType,
        @RequestStatus,
        @RequestedBy,
        @Notes
    );

    SET @AccessRequestID = SCOPE_IDENTITY();
END;
GO


/*
===========================================================
Procedure: usp_AddClientToAccessRequest

Purpose:
Adds a client code to an existing access request.

Workflow:
- Validates that the access request exists
- Validates that the client exists
- Prevents duplicate request/client combinations
- Inserts the requested client relationship
===========================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_AddClientToAccessRequest
    @AccessRequestID INT,
    @ClientID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.AccessRequests
        WHERE AccessRequestID = @AccessRequestID
    )
    BEGIN
        RAISERROR('Access request does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Clients
        WHERE ClientID = @ClientID
    )
    BEGIN
        RAISERROR('Client does not exist.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.AccessRequestClients
        WHERE AccessRequestID = @AccessRequestID
          AND ClientID = @ClientID
    )
    BEGIN
        INSERT INTO dbo.AccessRequestClients
        (
            AccessRequestID,
            ClientID
        )
        VALUES
        (
            @AccessRequestID,
            @ClientID
        );
    END;
END;
GO

/*
===========================================================
Procedure: usp_LogAccessRequestEmail

Purpose:
Logs an email sent to the third-party provider and updates
the related access request status.

Workflow:
- Inserts email details into EmailLog
- Updates AccessRequests to Email Sent
- Records DateEmailSent
===========================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_LogAccessRequestEmail
    @AccessRequestID INT,
    @EmailType VARCHAR(25),
    @SentTo VARCHAR(255),
    @SentCC VARCHAR(255),
    @SubjectLine VARCHAR(255),
    @BodyText VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.AccessRequests
        WHERE AccessRequestID = @AccessRequestID
    )
    BEGIN
        RAISERROR('Access request does not exist.', 16, 1);
        RETURN;
    END;

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
        @AccessRequestID,
        @EmailType,
        @SentTo,
        @SentCC,
        @SubjectLine,
        @BodyText
    );

    UPDATE dbo.AccessRequests
    SET
        RequestStatus = 'Email Sent',
        DateEmailSent = GETDATE()
    WHERE AccessRequestID = @AccessRequestID;
END;
GO

/*
===========================================================
Procedure: usp_MarkAccessRequestCompleted

Purpose:
Marks an access request as completed after the third-party
provider confirms the requested dashboard access was created.

Workflow:
- Updates AccessRequests to Completed
- Records DateCompleted
===========================================================
*/

CREATE OR ALTER PROCEDURE dbo.usp_MarkAccessRequestCompleted
    @AccessRequestID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.AccessRequests
        WHERE AccessRequestID = @AccessRequestID
    )
    BEGIN
        RAISERROR('Access request does not exist.', 16, 1);
        RETURN;
    END;

    UPDATE dbo.AccessRequests
    SET
        RequestStatus = 'Completed',
        DateCompleted = GETDATE()
    WHERE AccessRequestID = @AccessRequestID;
END;
GO