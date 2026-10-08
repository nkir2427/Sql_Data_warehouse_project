/*
========================================================
SILVER LAYER - CRM CUSTOMER TRANSFORMATION
========================================================
Purpose:
- Load cleaned customer data from Bronze to Silver.
- Remove duplicate customer records.
- Trim unwanted spaces.
- Standardize marital status and gender.
- Exclude NULL customer IDs.
- Keep the latest record for each customer.
========================================================
*/


--Final query building to insert silver.crm_cust_info from bronze.crm_cust_info

insert into silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select cst_id,
cst_key,
TRIM(cst_firstname),
TRIM(cst_lastname),
case when Upper(Trim(cst_mariTal_status))='M' then 'Married'
	 when Upper(Trim(cst_marital_status))='S' then 'Single'
	 else 'n/a'
end cst_marital_status,
case when Upper(Trim(cst_gndr))='M' then 'Male'
	 when Upper(Trim(cst_gndr))='F' then 'Female'
	 else 'n/a'
end cst_gndr,
cst_create_date
 from
(SELECT *,ROW_NUMBER() OVER (PARTITION BY cst_id order by cst_create_date desc) as flag_lst
FROM bronze.crm_cust_info where cst_id is not NULL) t
WHERE flag_lst=1;


/*
========================================================
CRM PRODUCT - BRONZE TO SILVER
========================================================
- Transform product key and category ID.
- Replace NULL costs with 0.
- Standardize product line values.
- Convert dates to DATE format.
- Generate product end date from the next start date.
========================================================
*/

insert into silver.crm_prd_info (
prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
select prd_id,
Replace(SUBSTRING(prd_key,1,5), '-','_') as cat_id,
SUBSTRING(prd_key,7,LEN(prd_key)) As prd_key,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
CASE WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line))='R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line))='S' THEN 'Other Sales'	
	 WHEN UPPER(TRIM(prd_line))='T' THEN 'Touring'	
	 ELSE 'n/a'
END AS prd_line,
cast(prd_start_dt as date) as prd_start_dt,
CAST(DATEADD(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as date) AS prd_end_dt
from bronze.crm_prd_info;


*
========================================================
CRM SALES - BRONZE TO SILVER TRANSFORMATION
========================================================
- Convert invalid sales dates to NULL.
- Derive Sales using Quantity × ABS(Price) when invalid.
- Derive Price from Sales ÷ Quantity when invalid.
- Convert negative Price values to positive.
- Handle NULL and zero values safely.
========================================================
*/

 --rules for final query for sales,price and quantity
--if sales is negative,zero or null derive it using price and quantity
-- if price is zero or null ,derived using quantity and sales
-- if price is negative convert into positive

 insert into silver.crm_sales_details (sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
 SELECT sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,case when sls_order_dt=0 or LEN(sls_order_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt
       ,case when sls_ship_dt=0 or LEN(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt
       ,case when sls_due_dt=0 or LEN(sls_due_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt
      ,case when sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity * ABS(sls_price)
                then ABS(sls_price) * sls_quantity
            else sls_sales
       end AS sls_sales
      ,sls_quantity 
       ,CASE WHEN sls_price <=0 or sls_price is null then sls_sales/NULLIF(sls_quantity,0)
             ELSE sls_price
        END AS sls_price
  FROM [DataWarehouse].[bronze].[crm_sales_details];


/*
========================================================
ERP CUSTOMER - BRONZE TO SILVER TRANSFORMATION
========================================================
- Clean customer IDs by removing the 'NAS' prefix.
- Replace future birth dates with NULL.
- Standardize gender values to Male/Female.
- Set unknown gender values to 'n/a'.
========================================================
*/

insert into silver.erp_CUST_AZ12(cid,bdate,gen)
select 
case when cid like 'NAS%' THEN SUBSTRING(cid,4,len(cid))
	 else cid
end as cid,
case when bdate > GETDATE() THEN NULL
	 ELSE bdate
end as bdate,
case when upper(trim(gen)) in ('F','Female') then 'Female'
	 when upper(trim(gen)) in ('M','Male') then 'Male'
	 Else 'n/a'
end gen
from bronze.erp_CUST_AZ12;

