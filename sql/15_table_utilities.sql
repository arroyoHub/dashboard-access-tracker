USE Dashboard_User_Access;
GO

/* =========================================================
   1. Show all base tables
========================================================= */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;


/* =========================================================
   2. Show all columns by table
========================================================= */

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;


/* =========================================================
   3. Show row counts by table
========================================================= */

SELECT
    t.name AS TableName,
    SUM(p.[rows]) AS RowCount
FROM sys.tables t
JOIN sys.partitions p
    ON t.object_id = p.object_id
WHERE p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;


/* =========================================================
   4. Show foreign key relationships
========================================================= */

SELECT
    fk.name AS ForeignKeyName,
    parent.name AS ChildTable,
    parent_col.name AS ChildColumn,
    referenced.name AS ParentTable,
    referenced_col.name AS ParentColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables parent
    ON fkc.parent_object_id = parent.object_id
JOIN sys.columns parent_col
    ON fkc.parent_object_id = parent_col.object_id
    AND fkc.parent_column_id = parent_col.column_id
JOIN sys.tables referenced
    ON fkc.referenced_object_id = referenced.object_id
JOIN sys.columns referenced_col
    ON fkc.referenced_object_id = referenced_col.object_id
    AND fkc.referenced_column_id = referenced_col.column_id
ORDER BY parent.name;


/* =========================================================
   5. Quick table previews
========================================================= */

SELECT TOP 25 * FROM dbo.DashboardUsers;
SELECT TOP 25 * FROM dbo.Clients;
SELECT TOP 25 * FROM dbo.AccessRequests;
SELECT TOP 25 * FROM dbo.AccessRequestClients;
SELECT TOP 25 * FROM dbo.ContractManagers;


/* =========================================================
   6. Quick relationship check
========================================================= */

SELECT TOP 25
    ar.AccessRequestID,
    du.FirstName,
    du.LastName,
    du.Email,
    ar.RequestType,
    ar.RequestStatus,
    ar.RequestDate
FROM dbo.AccessRequests ar
JOIN dbo.DashboardUsers du
    ON ar.DashboardUserID = du.DashboardUserID
ORDER BY ar.RequestDate DESC;