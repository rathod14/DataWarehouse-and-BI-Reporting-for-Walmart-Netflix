/****** Object:  Database ist722_rnrathod_dw    Script Date: 4/25/2019 4:05:00 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_rnrathod_dw
GO
CREATE DATABASE ist722_rnrathod_dw
GO
ALTER DATABASE ist722_rnrathod_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oc6_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





/* Drop table fudgemart_v3.Proj_DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_v3.Proj_DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_v3.Proj_DimProduct 
;

IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Project')) 
BEGIN
    EXEC ('CREATE SCHEMA [Project] AUTHORIZATION [dbo]')
	PRINT 'CREATE SCHEMA [Project] AUTHORIZATION [dbo]'
END
go 

/* Create table dbo.Proj_DimCustomer */
CREATE TABLE dbo.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int  NULL
,  [AccountID]  int  NULL
,  [CustomerName]  varchar(50)  NULL
,  [CustomerType]  varchar(50) Default 'Mart' NOT NULL
,  [CustomerZip]  varchar(20)   NULL
,  [CustomerCity]  varchar(50)   NULL
,  [CustomerEmail]  varchar(100)   NULL
,  [CustomerState]  varchar(2) Null
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.Proj_DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

Alter Table DimCustomer
alter column CustomerName nvarchar(200) Null;

/* Create table fudgemart_v3.Proj_DimProduct */
CREATE TABLE Project.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int  NULL
,  [ProductName]  varchar(50)   NULL
,  [DepartmentName]  varchar(20) NULL
,  [IsActive]  nchar(50)   NULL
,  [VendorName]  varchar(50)  NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgemart_v3.Proj_DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT fudgemart_v3.Proj_DimProduct ON
;
INSERT INTO fudgemart_v3.Proj_DimProduct (ProductKey, ProductID, ProductName, DepartmentName, IsActive, VendorName, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', '?', 'None', Y, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemart_v3.Proj_DimProduct OFF
;

/* Drop table fudgemart_v3.Proj_FactOrderAnalysis */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart_v3.Proj_FactOrderAnalysis') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart_v3.Proj_FactOrderAnalysis 
;

/* Create table fudgemart_v3.Proj_FactOrderAnalysis */
CREATE TABLE Project.FactOrderAnalysis (
   [ProductKey]  int   NOT NULL
,  [CusotmerKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShipDateKey]  int   NOT NULL
,  [OrdeID]  int   NOT NULL
,  [OrderShiplagDays]  int   NULL
,  [Quantity]  int   NULL
,  [RetailRevenue]  money   NULL
,  [WholesaleRevenue]  money   NULL
,  [TotalRevenue]  money   NULL
, CONSTRAINT [PK_fudgemart_v3.Proj_FactOrderAnalysis] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrdeID] )
) ON [PRIMARY]
;

CREATE TABLE Project.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


/* Drop table fudgemart/flix.Proj_FactCustomerAnalysis */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemart/flix.Proj_FactCustomerAnalysis') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemart/flix.Proj_FactCustomerAnalysis 
;

/* Create table fudgemart/flix.Proj_FactCustomerAnalysis */
CREATE TABLE Project.FactCustomerAnalysis (
   [ProductKey] int Not null
,  [CustomerKey]  int NOT NULL
,  [OrderDateKey] int Not null 
,  [OrderID] int not null
,  [CustomerType]  nvarchar   NULL
,  [SpendingAmount]  numeric(18,4)   NULL
, CONSTRAINT [PK_fudgemart/flix.Proj_FactCustomerAnalysis] PRIMARY KEY NONCLUSTERED 
( [OrderID] )
) ON [PRIMARY]
;
alter Table Project.FactCustomerAnalysis
add constraint fkNorthwindFactCustomerAnalysisOrderDateKEy foreign key (OrderDateKey) 
		references Project.DimDate(DateKey);
alter Table Project.FactCustomerAnalysis
add constraint fkNorthwindFactCustomerAnalysisCustomerKey foreign key (CustomerKey) 
		references Project.DimDate(DateKey);

alter Table Project.FactCustomerAnalysis
drop constraint [PK_fudgemart/flix.Proj_FactCustomerAnalysis]


alter Table Project.FactCustomerAnalysis
alter column CustomerType nvarchar(10) not null;

Alter Table Project.FactCustomerAnalysis
alter column FlixPlanAmount money DEFAULT '0' Not Null;

 [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL

ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES Proj_DImProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_CusotmerKey FOREIGN KEY
   (
   CusotmerKey
   ) REFERENCES Proj_DImCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_ShipDateKey FOREIGN KEY
   (
   ShipDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart_v3.Proj_FactOrderAnalysis ADD CONSTRAINT
   FK_fudgemart_v3_Proj_FactOrderAnalysis_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemart/flix.Proj_FactCustomerAnalysis ADD CONSTRAINT
   FK_fudgemart/flix_Proj_FactCustomerAnalysis_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES Proj_DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
  