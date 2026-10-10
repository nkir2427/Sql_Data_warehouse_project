/*
========================================================
GOLD LAYER - SALES FACT TABLE
========================================================
- Join sales data with customer and product dimensions.
- Replace source IDs with surrogate dimension keys.
- Standardize column names and organize sales attributes.
- Include order dates, sales, quantity and price measures.
- Create gold.fact_sales as a view for reporting.
========================================================
*/



use DataWarehouse

--identify the columns to connect dimension table with fact table  

select * from silver.crm_sales_details;
select * from gold.dim_customer;
select * from gold.dim_products;


-- step o2 : removing join columns and replacing joined tables surrogate keys

--step 02 : naming the columns in standard way

--step 03: put logically order if need

--step 04: identify the table is dimension or fact.after assign primary key or make surrogate key

-- step 05 :making the data as view to save in gold layer

create view gold.fact_sales as 
select 
crm_sales.sls_ord_num as order_number,
dim_prd.product_key,
--crm_sales.sls_prd_key, --removing this and using product_key from dim_product table 
dim_cust.customer_key,
--crm_sales.sls_cust_id, --removing this and using customer_key from dim_customer table 
crm_sales.sls_order_dt as order_date ,
crm_sales.sls_ship_dt as shipping_date,
crm_sales.sls_due_dt as due_date,
crm_sales.sls_sales as sales_amount,
crm_sales.sls_quantity as quantity,
crm_sales.sls_price as price
from silver.crm_sales_details crm_sales
left join gold.dim_customer dim_cust
on crm_sales.sls_cust_id=dim_cust.customer_id
left join gold.dim_products dim_prd
on crm_sales.sls_prd_key=dim_prd.product_number
