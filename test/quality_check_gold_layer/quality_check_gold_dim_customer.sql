
/*
========================================================
GOLD LAYER - CUSTOMER DIMENSION QUALITY CHECKS
========================================================
- Review records in gold.dim_customer.
- Check distinct gender values for consistency.
- Identify duplicate customer IDs.
- Expected result: No duplicate customer IDs.
========================================================
*/

--quality check for gold.dim_customer view

select * from gold.dim_customer

select distinct gender from gold.dim_customer

select customer_id,count(*) from gold.dim_customer
group by customer_id
having count(*)>1
