/*
========================================================
GOLD LAYER - PRODUCT DIMENSION QUALITY CHECKS
========================================================
- Review records in gold.dim_products.
- Check for duplicate product numbers.
- Expected result: No duplicate product numbers.
========================================================
*/

--quality checks 

select * from gold.dim_products;


select product_number,count(*) from gold.dim_products
group by product_number
having count(*)>1
