/*
========================================================
BRONZE LOAD PROCEDURE
========================================================
Purpose:
- Full load of raw CRM & ERP CSV data into Bronze tables.
- Truncates existing data before loading.
- Uses BULK INSERT to load CSV files.
- Tracks individual and total load duration.
- TRY...CATCH handles loading errors.

Execution:
EXEC bronze.load_bronze;
========================================================
*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();


		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		--bulk insert the data from csv files into the tables
		--crm TABLES
		--TABLE NAME: bronze.crm_cust_info
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_cust_info';

		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> INSERTING DATA into: bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		from 'D:\AWS\my_project_01\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_prd_info';

		--TABLE NAME: bronze.crm_prd_info
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> INSERTING DATA into: bronze.crm_prd_info';

		BULK INSERT bronze.crm_prd_info
		from 'D:\AWS\my_project_01\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.crm_sales_details';

		--TABLE NAME: bronze.crm_sales_details
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> INSERTING DATA into: bronze.crm_sales_details';

		BULK INSERT bronze.crm_sales_details
		from 'D:\AWS\my_project_01\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();


		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';



		--erp TABLES
		PRINT '>> Truncating Table: bronze.erp_CUST_AZ12';

		--TABLE NAME: bronze.erp_CUST_AZ12
		TRUNCATE TABLE bronze.erp_CUST_AZ12;
		PRINT '>> INSERTING DATA into: bronze.erp_CUST_AZ12';

		BULK INSERT bronze.erp_CUST_AZ12
		from 'D:\AWS\my_project_01\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_LOC_A101';


		--TABLE NAME: bronze.erp_LOC_A101
		TRUNCATE TABLE bronze.erp_LOC_A101;
		PRINT '>> INSERTING DATA into: bronze.erp_LOC_A101';

		BULK INSERT bronze.erp_LOC_A101
		from 'D:\AWS\my_project_01\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @start_time = GETDATE();

		PRINT '>> Truncating Table: bronze.erp_PX_CAT_G1V2';

		--TABLE NAME: bronze.erp_PX_CAT_G1V2
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
		PRINT '>> INSERTING DATA into: bronze.erp_PX_CAT_G1V2';

		BULK INSERT bronze.erp_PX_CAT_G1V2
		from 'D:\AWS\my_project_01\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

	END TRY
	BEGIN CATCH		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH		

END
;

EXEC bronze.load_bronze
