USE Dashboard_User_Access

SELECT *
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'Dashboard_User_Access';

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT * FROM dbo.AccessRequestClients
SELECT * FROM dbo.AccessRequests
SELECT * FROM dbo.Clients
SELECT * FROM dbo.ContractManagers
SELECT * FROM dbo.DashboardUsers
SELECT * FROM dbo.EmailLog
SELECT * FROM dbo.UserClientAccess