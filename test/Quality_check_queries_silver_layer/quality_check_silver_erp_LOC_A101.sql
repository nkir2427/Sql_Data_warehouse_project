
/*
========================================================
ERP LOCATION - SILVER DATA QUALITY CHECKS
========================================================
- Check for unwanted spaces in country values.
- Check country values for standardization and consistency.
- Review the final Silver location data.
========================================================
*/


---quality check silver layer

select cntry
from silver.erp_LOC_A101
where cntry != trim(cntry);

--data standardization and consistency

select distinct cntry
from silver.erp_LOC_A101

select * from silver.erp_LOC_A101;

quality_check_silver_erp_LOC_A101
