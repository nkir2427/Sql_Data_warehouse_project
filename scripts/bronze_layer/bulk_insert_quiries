

USE DataWarehouse;
--bulk insert the data from csv files into the tables
--crm TABLES
--TABLE NAME: bronze.crm_cust_info
TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
from 'D:\AWS\my_project_01\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.crm_cust_info;

--TABLE NAME: bronze.crm_prd_info
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
from 'D:\AWS\my_project_01\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.crm_prd_info;


--TABLE NAME: bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
from 'D:\AWS\my_project_01\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.crm_sales_details;


--erp TABLES

--TABLE NAME: bronze.erp_CUST_AZ12
TRUNCATE TABLE bronze.erp_CUST_AZ12;

BULK INSERT bronze.erp_CUST_AZ12
from 'D:\AWS\my_project_01\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.erp_CUST_AZ12;


--TABLE NAME: bronze.erp_LOC_A101
TRUNCATE TABLE bronze.erp_LOC_A101;

BULK INSERT bronze.erp_LOC_A101
from 'D:\AWS\my_project_01\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.erp_LOC_A101;


--TABLE NAME: bronze.erp_PX_CAT_G1V2
TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

BULK INSERT bronze.erp_PX_CAT_G1V2
from 'D:\AWS\my_project_01\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW =2 ,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT COUNT(*) FROM bronze.erp_PX_CAT_G1V2;
