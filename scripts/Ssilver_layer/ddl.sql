

/*
========================================================
SILVER LAYER - DDL
========================================================
Purpose:
- Creates Silver tables for CRM and ERP data.
- Drops existing tables before recreation.
- Defines columns and appropriate data types.
- Adds dwh_create_date to track data load time.
- Silver layer is used for cleaned and transformed data.
========================================================
*/



USE DataWarehouse;



-- DDL FOR CRM TABLES--

if object_id ('silver.crm_cust_info', 'U' ) is not null 
	drop table silver.crm_cust_info ;

Go

create table silver.crm_cust_info (
cst_id	INT,
cst_key	NVARCHAR(50),
cst_firstname	NVARCHAR(50),
cst_lastname	NVARCHAR(50),
cst_marital_status	NVARCHAR(50),
cst_gndr	NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);


if object_id ('silver.crm_prd_info', 'U' ) is not null 
	drop table silver.crm_prd_info ;

Go

CREATE TABLE silver.crm_prd_info (
prd_id	INT,
cat_id 	NVARCHAR(50),
prd_key	NVARCHAR(50),
prd_nm	NVARCHAR(50),
prd_cost	INT,
prd_line	NVARCHAR(50),
prd_start_dt	DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.crm_sales_details', 'U' ) is not null 
	drop table silver.crm_sales_details ;

Go

create table silver.crm_sales_details (
sls_ord_num	NVARCHAR(50),
sls_prd_key	NVARCHAR(50),
sls_cust_id	INT,
sls_order_dt	DATE,
sls_ship_dt	DATE,
sls_due_dt	DATE,
sls_sales	INT,
sls_quantity	INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

Go
-- DDL FOR ERP TABLES--



if object_id ('silver.erp_CUST_AZ12', 'U' ) is not null 
	drop table silver.erp_CUST_AZ12 ;

Go

CREATE TABLE silver.erp_CUST_AZ12 (
CID	NVARCHAR(50),
BDATE	DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
Go

if object_id ('silver.erp_LOC_A101', 'U' ) is not null 
	drop table silver.erp_LOC_A101 ;

Go

CREATE TABLE silver.erp_LOC_A101 (
CID	NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

Go

if object_id ('silver.erp_PX_CAT_G1V2', 'U' ) is not null 
	drop table silver.erp_PX_CAT_G1V2 ;

Go

CREATE TABLE silver.erp_PX_CAT_G1V2 (
ID	NVARCHAR(50),
CAT	NVARCHAR(50),
SUBCAT	NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
