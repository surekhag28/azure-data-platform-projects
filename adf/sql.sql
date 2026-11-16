IF NOT EXISTS (
    select
        *
    from
        sys.schemas
    where
        name = 'sales'
) BEGIN EXEC ('CREATE SCHEMA sales');

END;

GO
CREATE TABLE
    sales.Customers (
        CustomerID INT PRIMARY KEY,
        CustomerName VARCHAR(100),
        City VARCHAR(50),
        ModifiedDate DATETIME
    );

INSERT INTO
    sales.Customers
VALUES
    (101, 'John', 'New York', '2026-05-01 10:00:00'),
    (102, 'Mary', 'Dallas', '2026-05-02 09:30:00'),
    (103, 'David', 'Seattle', '2026-05-03 15:45:00');

select
    *
from
    sales.Customers;

CREATE TABLE
    sales.Orders (
        OrderID INT PRIMARY KEY,
        CustomerID INT,
        OrderAmount DECIMAL(10, 2),
        UpdatedDate DATETIME
    );

INSERT INTO
    sales.Orders
VALUES
    (1001, 101, 250.00, '2026-05-01 12:00:00'),
    (1002, 102, 475.50, '2026-05-02 14:00:00'),
    (1003, 103, 620.75, '2026-05-04 18:00:00');

select
    *
from
    sales.Orders;

CREATE TABLE
    sales.Products (
        ProductID INT PRIMARY KEY,
        ProductName VARCHAR(100),
        Category VARCHAR(50),
        ModifiedDate DATETIME
    );

INSERT INTO
    sales.Products
VALUES
    (1, 'Laptop', 'Electronics', '2026-05-01 08:00:00'),
    (2, 'Mouse', 'Accessories', '2026-05-02 11:00:00'),
    (3, 'Desk', 'Furniture', '2026-05-03 16:00:00');

select
    *
from
    sales.Products;

create table
    sales.etl_metadata (
        MetadataID INT IDENTITY (1, 1) PRIMARY KEY,
        PipelineName VARCHAR(100),
        SourceSchema VARCHAR(50),
        SourceTable VARCHAR(100),
        WatermarkColumn VARCHAR(100),
        LastWatermark DATETIME,
        LoadType VARCHAR(520),
        TargetPath VARCHAR(200),
        IsActive BIT
    );

INSERT INTO
    sales.etl_metadata (
        PipelineName,
        SourceSchema,
        SourceTable,
        WatermarkColumn,
        LastWatermark,
        LoadType,
        TargetPath,
        IsActive
    )
VALUES
    (
        'pl_data_ingestion',
        'sales',
        'Customers',
        'ModifiedDate',
        '2026-01-01 00:00:00',
        'Incremental',
        'bronze/customers/',
        1
    ),
    (
        'pl_data_ingestion',
        'sales',
        'Orders',
        'UpdatedDate',
        '2026-01-01 00:00:00',
        'Incremental',
        'bronze/orders/',
        1
    ),
    (
        'pl_data_ingestion',
        'sales',
        'Products',
        'ModifiedDate',
        '1900-01-01 00:00:00',
        'Full',
        'bronze/products/',
        1
    );

select
    *
from
    sales.etl_metadata;



CREATE TABLE sales.etl_audit(

    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    RunID VARCHAR(100),
    SourceTable VARCHAR(100),
    RowsCopied INT,
    Status VARCHAR(20),
    StartTime DATETIME,
    EndTime DATETIME,
    ErrorMessage VARCHAR(MAX)
);

select * from sales.etl_audit;

GO

CREATE PROCEDURE dbo.usp_UpdateWaterMark
    @SourceTable VARCHAR(100),
    @NewWaterMark DATETIME
AS
BEGIN
    UPDATE sales.etl_metadata
    SET LastWatermark = @NewWaterMark
    WHERE @SourceTable=@SourceTable
END;

GO
CREATE PROCEDURE dbo.usp_InsertAudit
    @RunID VARCHAR(100),
    @SourceTable VARCHAR(100),
    @RowsCopied INT,
    @Status VARCHAR(20),
    @StartTime DATETIME,
    @EndTime DATETIME,
    @ErrorMessage VARCHAR(MAX) = NULL
AS
BEGIN

    INSERT INTO sales.etl_audit
    (
        RunID,
        SourceTable,
        RowsCopied,
        Status,
        StartTime,
        EndTime,
        ErrorMessage
    )
    VALUES
    (
        @RunID,
        @SourceTable,
        @RowsCopied,
        @Status,
        @StartTime,
        @EndTime,
        @ErrorMessage
    );
END;


