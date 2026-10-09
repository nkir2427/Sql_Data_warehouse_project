/*
========================================================
ERP LOCATION - DATA QUALITY CHECKS
========================================================
- Check country values for unwanted spaces.
- Check country values for standardization and consistency.
- Normalize customer IDs before joining with CRM data.
========================================================
*/


USE DataWarehouse;


select * from bronze.erp_LOC_A101;

select * from silver.crm_cust_info;

--when comparing  two tables ( bronze.erp_LOC_A101 and silver.crm_cust_info) to join both have to do some transaction into cid column
-- in erp_loc_a101 table with removing AW-00011000 --> AW00011000)


----check for unwanted Spaces
--exceptation: no results

select cntry
from bronze.erp_LOC_A101
where cntry != trim(cntry)
--no results from the query ,but better for future have to add trim for this column

--data standardization and consistency

select distinct cntry
from bronze.erp_LOC_A101;

quality_check_bronze_erp_LOC_A101
