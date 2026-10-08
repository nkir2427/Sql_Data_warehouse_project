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
