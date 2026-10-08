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

