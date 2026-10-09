/*
========================================================
ERP PRODUCT CATEGORY - DATA QUALITY CHECKS
========================================================
- Verify category ID mapping with CRM product data.
- Check for unwanted spaces in category fields.
- Check category, subcategory and maintenance values
  for standardization and consistency.
========================================================
*/



USE DataWarehouse;


select * from bronze.erp_PX_CAT_G1V2;


select * from silver.crm_prd_info;


--when comparing above two tables can identify cat_id which derived from the prd_key to the silver.crm_prd_info is mapping with
-- id of bronze.erp.px_cat_G1v2 table

------check for unwanted Spaces
--exceptation: no results

select cat from bronze.erp_PX_CAT_G1V2
where cat != TRIM(cat);

select subcat from bronze.erp_PX_CAT_G1V2
where subcat != TRIM(subcat);

select MAINTENANCE from bronze.erp_PX_CAT_G1V2
where MAINTENANCE != TRIM(MAINTENANCE);

--no results from the queries ,but better for future have to add trim for this column

--data standardization and consistency

select distinct cat from bronze.erp_PX_CAT_G1V2;

select distinct subcat from bronze.erp_PX_CAT_G1V2;

select distinct MAINTENANCE from bronze.erp_PX_CAT_G1V2;


