--- mssqlsever
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "pvbP5JUkSlQbk5Ap"

CREATE DATABASE Sales
GO
USE [SALES]
GO
CREATE TABLE TDS([id] [int] NOT NULL, [data] varchar(255) NOT NULL)
GO
INSERT INTO TDS (id, data) VALUES (1,'cat'),(2,'dog'),(3,'horse')
GO
SELECT * from [Sales].[dbo].[TDS]
GO


--- postgres

CREATE DATABASE ramdor;

\c ramdor;
CREATE EXTENSION tds_fdw;
SELECT oid, extname, extversion FROM pg_extension;

CREATE SERVER mssql_svr FOREIGN DATA WRAPPER tds_fdw OPTIONS (servername 'ramdor-mssql.demo.svc', port '1433', database 'sales', tds_version '7.1');

--- change the password with the server password
CREATE USER MAPPING FOR postgres SERVER mssql_svr  OPTIONS (username 'sa', password 'ifia0aiTTJsrMHHi');

CREATE FOREIGN TABLE tds (
 id integer,
 data varchar)
 SERVER mssql_svr
 OPTIONS (query 'SELECT * FROM [Sales].[dbo].[TDS]', row_estimate_method 'showplan_all');

SELECT srvname, srvoptions FROM pg_foreign_server WHERE srvname = 'mssql_svr';

\d+ tds

SELECT * FROM tds;

--- end


