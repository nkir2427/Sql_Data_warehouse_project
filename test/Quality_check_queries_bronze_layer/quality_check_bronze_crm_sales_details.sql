/*
========================================================
CRM SALES - DATA QUALITY CHECKS
========================================================
- Check for invalid or out-of-range dates.
- Validate order, ship and due date consistency.
- Verify Sales = Quantity × Price.
- Check for NULL, zero or negative values.
========================================================
*/


USE DataWarehouse;
--check for invalid dates

select nullif(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 or LEN(sls_order_dt) !=8 or
 sls_order_dt > 20500101 or sls_order_dt < 19000101;

select nullif(sls_ship_dt,0) sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 or LEN(sls_ship_dt) !=8 or
 sls_ship_dt > 20500101 or sls_ship_dt < 19000101;

select nullif(sls_due_dt,0) sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0 or LEN(sls_due_dt) !=8 or
 sls_due_dt > 20500101 or sls_due_dt < 19000101;


 --check for invalid date orders

 select * from bronze.crm_sales_details
 where sls_due_dt < sls_ship_dt;

  select * from bronze.crm_sales_details
 where sls_due_dt < sls_order_dt;

 --check data consistency : Between Sales,Quantity and Price 
 -- sales =quantity * price
 -- values must be not Null,zero or negative
 
 select distinct 
 sls_sales,
 sls_quantity,
 sls_price
 from bronze.crm_sales_details
 where sls_sales != sls_quantity * sls_price
 or sls_sales is null or sls_quantity is null or sls_price is null
 or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
