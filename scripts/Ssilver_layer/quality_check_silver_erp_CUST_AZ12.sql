/*
========================================================
ERP CUSTOMER - SILVER DATA QUALITY CHECKS
========================================================
- Check for invalid or future birth dates.
- Check gender values for standardization and consistency.
========================================================
*/



--identify out-of-range dates

select distinct bdate
from silver.erp_CUST_AZ12
where bdate < '1924-01-01' or bdate > GETDATE()

--data standardization & consistency

select distinct gen
from silver.erp_CUST_AZ12

