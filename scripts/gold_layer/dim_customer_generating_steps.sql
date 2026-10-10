/*
========================================================
GOLD LAYER - CUSTOMER DIMENSION
========================================================
- Join CRM customer data with ERP customer and location data.
- Check for duplicate records after joining.
- Standardize column names and organize attributes.
- Prioritize CRM gender; use ERP gender as a fallback.
- Generate a surrogate customer key using ROW_NUMBER().
- Create gold.dim_customer as a view for reporting.
========================================================
*/

use DataWarehouse

--identify the columns to join 
select * from silver.crm_cust_info crm_cust;
select * from silver.erp_CUST_AZ12 erp_cust;
select * from silver.erp_loc_a101 erp_loc;

--check the joined table has duplicates
--expectation:no duplicates
select cst_id,count(*) from
(select 
crm_cust.cst_id,
crm_cust.cst_key,
crm_cust.cst_firstname,
crm_cust.cst_lastname,
crm_cust.cst_marital_status,
crm_cust.cst_gndr,
crm_cust.cst_create_date,
erp_cust.bdate,
erp_cust.gen,
erp_loc.cntry
from silver.crm_cust_info crm_cust
left join silver.erp_CUST_AZ12 erp_cust
on crm_cust.cst_key=erp_cust.CID
left join silver.erp_loc_a101 erp_loc
on crm_cust.cst_key=erp_loc.CID
) t
group by cst_id 
having count(*) >1;


----main query building

--check duplicate columns

select distinct
crm_cust.cst_gndr,
erp_cust.gen
from silver.crm_cust_info crm_cust
left join silver.erp_CUST_AZ12 erp_cust
on crm_cust.cst_key=erp_cust.cid
left join silver.erp_loc_a101 erp_loc
on crm_cust.cst_key=erp_loc.cid;

--logic building

select distinct
crm_cust.cst_gndr,
erp_cust.gen,
case when cst_gndr !='n/a' then cst_gndr  ---  crm is the master table for taking customer data
	 else Coalesce(gen,'n/a')
end as new_gen
from silver.crm_cust_info crm_cust
left join silver.erp_CUST_AZ12 erp_cust
on crm_cust.cst_key=erp_cust.cid
left join silver.erp_loc_a101 erp_loc
on crm_cust.cst_key=erp_loc.cid;

--step 02 : naming the columns in standard way

--step 03: put logically order 

--step 04: identify the table is dimension or fact.after assign primary key or make surrogate key

-- step 05 :making the data as view to save in gold layer


--FInal query 
Create View gold.dim_customer as 
select 
ROW_NUMBER() OVER (ORDER BY crm_cust.cst_id) as customer_key, --step 04
crm_cust.cst_id as customer_id,
crm_cust.cst_key as customer_number,
crm_cust.cst_firstname as first_name,
crm_cust.cst_lastname as last_name,
erp_loc.cntry as country, --step 03 
crm_cust.cst_marital_status as marital_status,
case when cst_gndr !='n/a' then cst_gndr  ---  crm is the master table for taking customer data
	 else Coalesce(gen,'n/a')
end as gender,
erp_cust.bdate as birthdate, --step 03
crm_cust.cst_create_date as create_date
from silver.crm_cust_info crm_cust
left join silver.erp_CUST_AZ12 erp_cust
on crm_cust.cst_key=erp_cust.cid
left join silver.erp_loc_a101 erp_loc
on crm_cust.cst_key=erp_loc.cid
