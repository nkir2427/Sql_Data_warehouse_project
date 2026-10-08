
/*
========================================================
BRONZE LAYER - DATA QUALITY CHECKS
========================================================
Purpose:
- Check for NULLs and duplicate primary keys.
- Identify duplicate records and verify latest records.
- Check for unwanted spaces in text columns.
- Check data standardization and consistency.
- Check for Invalid Date Orders
- Expected result: No NULLs, duplicates, or unwanted spaces.
========================================================
*/





select * from [bronze].[crm_prd_info]


--quality checking in bronze table

--check for nulls or duplicates in primary key
--exceptation: no results

select prd_id,count(*) 
from bronze.[crm_prd_info]
group by prd_id
having count(*)>1 or prd_id is Null;

--check for unwanted Spaces
--exceptation: no results

select prd_nm
from bronze.[crm_prd_info]
where prd_nm != TRIM(prd_nm)

--check for Nulls or Negative Values
--exceptation: no results

select prd_cost 
from bronze.crm_prd_info
where prd_cost < 0 OR prd_cost IS NULL;

--data standardization & Consistency

select distinct prd_line from bronze.crm_prd_info;

--check for Invalid Date Orders

Select * from bronze.crm_prd_info
where prd_end_dt < prd_start_dt
