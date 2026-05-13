USE Dashboard_User_Access;
GO

DELETE FROM dbo.EmailLog;
DELETE FROM dbo.UserClientAccess;
DELETE FROM dbo.AccessRequestClients;
DELETE FROM dbo.AccessRequests;
DELETE FROM dbo.DashboardUsers;
DELETE FROM dbo.Clients;
DELETE FROM dbo.ContractManagers;
GO

DBCC CHECKIDENT ('dbo.EmailLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.UserClientAccess', RESEED, 0);
DBCC CHECKIDENT ('dbo.AccessRequestClients', RESEED, 0);
DBCC CHECKIDENT ('dbo.AccessRequests', RESEED, 0);
DBCC CHECKIDENT ('dbo.DashboardUsers', RESEED, 0);
DBCC CHECKIDENT ('dbo.Clients', RESEED, 0);
DBCC CHECKIDENT ('dbo.ContractManagers', RESEED, 0);
GO