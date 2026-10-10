/*
========================================================
GOLD LAYER - SALES FACT QUALITY CHECKS
========================================================
- Review records in gold.fact_sales.
- Validate customer and product dimension key mappings.
- Identify sales records with missing dimension keys.
- Expected result: No unmatched customer or product keys.
========================================================
*/



--quality checking

select * from gold.fact_sales


--final checking 
-- foreign key integrity (dimensions)
select * from gold.fact_sales f
left join gold.dim_customer cust
on cust.customer_key=f.customer_key
left join gold.dim_products p
on p.product_key=f.product_key
where cust.customer_key is null or p.product_key is null
