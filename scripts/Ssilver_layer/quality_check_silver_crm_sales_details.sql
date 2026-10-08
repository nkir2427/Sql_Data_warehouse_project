
/*
========================================================
SILVER SALES - DATA QUALITY CHECKS
========================================================
- Validate order, ship and due date sequence.
- Verify Sales = Quantity × Price.
- Check for NULL, zero or negative values.
- Review final Silver sales data.
========================================================
*/

--check for invalid date orders

 select * from silver.crm_sales_details
 where sls_due_dt < sls_ship_dt;

  select * from silver.crm_sales_details
 where sls_due_dt < sls_order_dt;

 --check data consistency : Between Sales,Quantity and Price 
 -- sales =quantity * price
 -- values must be not Null,zero or negative
 
 select distinct 
 sls_sales,
 sls_quantity,
 sls_price
 from silver.crm_sales_details
 where sls_sales != sls_quantity * sls_price
 or sls_sales is null or sls_quantity is null or sls_price is null
 or sls_sales <=0 or sls_quantity <=0 or sls_price <=0


 select * from silver.crm_sales_details
