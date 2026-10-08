--quality checking silver layer

/*
========================================================
ERP PRODUCT CATEGORY - SILVER DATA QUALITY CHECKS
========================================================
- Check for unwanted spaces in category fields.
- Check category, subcategory and maintenance values
  for standardization and consistency.
- Review distinct values in the final Silver data.
========================================================
*/

select cat from silver.erp_PX_CAT_G1V2
where cat != TRIM(cat);

select subcat from silver.erp_PX_CAT_G1V2
where subcat != TRIM(subcat);

select MAINTENANCE from silver.erp_PX_CAT_G1V2
where MAINTENANCE != TRIM(MAINTENANCE);

--no results from the queries ,but better for future have to add trim for this column

--data standardization and consistency

select distinct cat from silver.erp_PX_CAT_G1V2;

select distinct subcat from silver.erp_PX_CAT_G1V2;

select distinct MAINTENANCE from silver.erp_PX_CAT_G1V2;


