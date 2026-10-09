
/*
========================================================
BRONZE LAYER - DATA QUALITY CHECKS
========================================================
Purpose:
- Check for NULLs and duplicate primary keys.
- Identify duplicate records and verify latest records.
- Check for unwanted spaces in text columns.
- Check data standardization and consistency.
- Expected result: No NULLs, duplicates, or unwanted spaces.
========================================================
*/


USE DataWarehouse;
--quality checking in bronze table

--check for nulls or duplicates in primary key
--exceptation: no results

select cst_id,count(*) 
from bronze.crm_cust_info
group by cst_id
having count(*)>1;

select cst_id,count(*) 
from bronze.crm_cust_info
group by cst_id
having count(*)>1 OR cst_id is NULL

select * from bronze.crm_cust_info where cst_id=29466;



select * from
(SELECT *,ROW_NUMBER() OVER (PARTITION BY cst_id order by cst_create_date desc) as flag_lst
FROM bronze.crm_cust_info) t
WHERE flag_lst=1
and  cst_id=29466;


select cst_id,count(*) from
(SELECT *,ROW_NUMBER() OVER (PARTITION BY cst_id order by cst_create_date desc) as flag_lst
FROM bronze.crm_cust_info) t
WHERE flag_lst=1
group by cst_id
having count(*)>1 OR cst_id is NULL


--check for unwanted Spaces
--exceptation: no results


select cst_firstname from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

select cst_lastname from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

select cst_key from bronze.crm_cust_info
where cst_key != TRIM(cst_key);



--data standardization & accuracy

select distinct cst_gndr from bronze.crm_cust_info;
select distinct cst_marital_status from bronze.crm_cust_info;


