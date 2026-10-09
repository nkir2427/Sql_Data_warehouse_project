
/*
========================================================
GOLD LAYER - PRODUCT DIMENSION
========================================================
- Join CRM product data with ERP product category data.
- Check for duplicate product records after joining.
- Filter to current products using prd_end_dt IS NULL.
- Standardize column names and organize product attributes.
- Generate a surrogate product key using ROW_NUMBER().
- Create gold.dim_products as a view for reporting.
========================================================
*/




use DataWarehouse

select * from silver.crm_prd_info crm_prd;
select * from silver.erp_px_cat_g1v2 erp_prd;


--check the joined table has duplicates
--expectation:no duplicates
select prd_key,count(*) from
(select 
crm_prd.prd_id,
crm_prd.cat_id,
crm_prd.prd_key,
crm_prd.prd_nm,
crm_prd.prd_cost,
crm_prd.prd_line,
crm_prd.prd_start_dt,
--crm_prd.prd_end_dt,
erp_prd.cat,
erp_prd.subcat,
erp_prd.maintenance
from silver.crm_prd_info crm_prd
left join silver.erp_px_cat_g1v2 erp_prd
on crm_prd.cat_id=erp_prd.id
where crm_prd.prd_end_dt is null 
) t
group by prd_key 
having count(*) >1


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
create view gold.dim_products as
select 
ROW_NUMBER() OVER( ORDER BY crm_prd.prd_start_dt,crm_prd.prd_key) AS product_key,
crm_prd.prd_id as product_id,
crm_prd.prd_key as product_number,
crm_prd.prd_nm as product_name,
crm_prd.cat_id as category_id,
erp_prd.cat as category,
erp_prd.subcat as subcategory,
erp_prd.maintenance,
crm_prd.prd_cost as cost,
crm_prd.prd_line as product_line,
crm_prd.prd_start_dt as start_date
--crm_prd.prd_end_dt,
from silver.crm_prd_info crm_prd
left join silver.erp_px_cat_g1v2 erp_prd
on crm_prd.cat_id=erp_prd.id
where crm_prd.prd_end_dt is null -- filter out all historical data
