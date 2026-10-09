
--identify out-of-range dates

/*
========================================================
ERP CUSTOMER - DATA QUALITY CHECKS
========================================================
- Check for out-of-range or future birth dates.
- Check gender values for consistency and standardization.
========================================================
*/

select distinct bdate
from bronze.erp_CUST_AZ12
where bdate < '1924-01-01' or bdate > GETDATE()

--data standardization & consistency

select distinct gen
from bronze.erp_CUST_AZ12


