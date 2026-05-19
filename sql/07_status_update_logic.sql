CREATE OR ALTER PROCEDURE dbo.usp_UpdateAccessRequestStatus
    @AccessRequestID INT,
    @RequestStatus VARCHAR(50),
    @Notes VARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.AccessRequests
    SET
        RequestStatus = @RequestStatus,
        Notes = COALESCE(@Notes, Notes)
    WHERE AccessRequestID = @AccessRequestID;
END;
GO