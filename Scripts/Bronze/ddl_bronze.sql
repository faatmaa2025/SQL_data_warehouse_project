/*
====================================================================
DDL Script: Create Bronze Tables
====================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
====================================================================
*/

-- Drop and recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Datawarehouse')
BEGIN

    ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Datawarehouse;
END;
GO

--Create Database "DataWareHouse"
Use master ;
Create Database DataWarehouse;

Use DataWarehouse;

-- Create Schemas for each layer

create schema Bronze;
GO
create schema Silver;
GO
create schema Gold;
GO

-- check before create any table first that the table not exists 
IF OBJECT_ID ('bronze.crm_cust_info' , 'U') IS NOT NULL
Drop Table bronze.crm_cust_info ;
Create Table bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR (50),
cst_firstname NVARCHAR (50),
cst_lastname NVARCHAR (50),
cst_marital_status NVARCHAR (50),
cst_gndr NVARCHAR (50),
cst_create_date Date
);

Create Table bronze.crm_prd_info (
prd_id INT,
prd_key  NVARCHAR (50),
prd_nm  NVARCHAR (50),
prd_cost INT,
prd_line  NVARCHAR (50),
prd_start_dt DateTIME,
prd_end_dt DateTIME
);

Create Table bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT 
);


Create Table bronze.erp_CUST_AZ12 (
CID NVARCHAR (50),
BDATE DATE,
GEN NVARCHAR (50)
);

Create Table bronze.erp_LOC_A101 (
CID NVARCHAR (50),
CNTRY NVARCHAR (50)
);

Create Table bronze.erp_PX_CAT_G1V2 (
ID  NVARCHAR (50),
CAT  NVARCHAR (50),
SUBCAT  NVARCHAR (50),
MAINTENANCE NVARCHAR (50)
);

==================================================================
CREATE OR ALTER PROCEDURE DataWarehouse AS
BEGIN -- Opens the Stored Procedure
    BEGIN TRY -- Opens the Error Handling block
        
        -- Declare variables once at the top of the block
        DECLARE @Start_time DATETIME;
        DECLARE @end_time DATETIME;
        DECLARE @msg NVARCHAR(200);

        PRINT '=============================';
        PRINT 'Loading the bronze layer';
        PRINT '=============================';
        PRINT 'Loading CRM Tables';
        
        -- 1. crm_cust_info ---------------------------------------------------
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.crm_cust_info';
        TRUNCATE TABLE Bronze.crm_cust_info; 

        PRINT '>> Inserting Data Into Table: Bronze.crm_cust_info';
        BULK INSERT Bronze.crm_cust_info 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        -- Assign the string to the variable, then pass it to RAISERROR
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';

        -- 2. crm_prd_info ----------------------------------------------------
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.crm_prd_info';
        TRUNCATE TABLE Bronze.crm_prd_info; 

        PRINT '>> Inserting Data Into Table: Bronze.crm_prd_info';
        BULK INSERT Bronze.crm_prd_info 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';

        -- 3. crm_sales_details -----------------------------------------------
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.crm_sales_details';
        TRUNCATE TABLE Bronze.crm_sales_details; 

        PRINT '>> Inserting Data Into Table: Bronze.crm_sales_details';
        BULK INSERT Bronze.crm_sales_details 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';
     
        -- 4. erp_CUST_AZ12 ---------------------------------------------------
        PRINT '------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------';
        
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.erp_CUST_AZ12';
        TRUNCATE TABLE Bronze.erp_CUST_AZ12; 

        PRINT '>> Inserting Data Into Table: Bronze.erp_CUST_AZ12';
        BULK INSERT Bronze.erp_CUST_AZ12 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';

        -- 5. erp_LOC_A101 ----------------------------------------------------
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.erp_LOC_A101';
        TRUNCATE TABLE Bronze.erp_LOC_A101; 

        PRINT '>> Inserting Data Into Table: Bronze.erp_LOC_A101';
        BULK INSERT Bronze.erp_LOC_A101 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';

        -- 6. erp_PX_CAT_G1V2 -------------------------------------------------
        SET @Start_time = GETDATE();
        PRINT '>> Truncate Table: Bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2; 

        PRINT '>> Inserting Data Into Table: Bronze.erp_PX_CAT_G1V2';
        BULK INSERT Bronze.erp_PX_CAT_G1V2 
        FROM 'D:\SQL Baraa\SQL Projects with Bara\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        
        SET @msg = 'Time Duration: ' + CAST(DATEDIFF(Second, @Start_time, @end_time) AS NVARCHAR(50)) + ' Second';
        RAISERROR(@msg, 0, 1) WITH NOWAIT;
        PRINT '---------------------------------------------------';

    END TRY
    BEGIN CATCH  
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'ERROR Message: ' + ERROR_MESSAGE();
        PRINT 'ERROR Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
        PRINT 'ERROR State: ' + CAST(ERROR_STATE() AS NVARCHAR(50));
        PRINT '================================================';
    END CATCH
END; -- Closes the procedure definition block
GO

-- To run the procedure and see your output, execute this line:
EXEC DataWarehouse;
