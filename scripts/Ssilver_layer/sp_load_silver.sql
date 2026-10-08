create or alter procedure silver.load_silver as 
begin
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY 
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Silver Layer';
		PRINT '================================================';
		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
		
        SET @start_time = GETDATE();
        PRINT '>> Truncating data from :silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Inserting data into:silver.crm_cust_info';
        insert into silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
        select cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        case when Upper(Trim(cst_mariTal_status))='M' then 'Married'
	         when Upper(Trim(cst_marital_status))='S' then 'Single'
	         else 'n/a'
        end cst_marital_status,
        case when Upper(Trim(cst_gndr))='M' then 'Male'
	         when Upper(Trim(cst_gndr))='F' then 'Female'
	         else 'n/a'
        end cst_gndr,
        cst_create_date
         from
        (SELECT *,ROW_NUMBER() OVER (PARTITION BY cst_id order by cst_create_date desc) as flag_lst
        FROM bronze.crm_cust_info where cst_id is not NULL) t
        WHERE flag_lst=1;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		
		SET @start_time = GETDATE();
        PRINT '>> Truncating data from :silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>> Inserting data into:silver.crm_prd_info';
        insert into silver.crm_prd_info (
        prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
        select prd_id,
        Replace(SUBSTRING(prd_key,1,5), '-','_') as cat_id,
        SUBSTRING(prd_key,7,LEN(prd_key)) As prd_key,
        prd_nm,
        ISNULL(prd_cost,0) as prd_cost,
        CASE WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
	         WHEN UPPER(TRIM(prd_line))='R' THEN 'Road'
	         WHEN UPPER(TRIM(prd_line))='S' THEN 'Other Sales'	
	         WHEN UPPER(TRIM(prd_line))='T' THEN 'Touring'	
	         ELSE 'n/a'
        END AS prd_line,
        cast(prd_start_dt as date) as prd_start_dt,
        CAST(DATEADD(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as date) AS prd_end_dt
        from bronze.crm_prd_info;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();
        PRINT '>> Truncating data from :silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>> Inserting data into:silver.crm_sales_details';

         insert into silver.crm_sales_details (sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
         SELECT sls_ord_num
              ,sls_prd_key
              ,sls_cust_id
              ,case when sls_order_dt=0 or LEN(sls_order_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
                END AS sls_order_dt
               ,case when sls_ship_dt=0 or LEN(sls_ship_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
                END AS sls_ship_dt
               ,case when sls_due_dt=0 or LEN(sls_due_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
                END AS sls_due_dt
              ,case when sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity * ABS(sls_price)
                        then ABS(sls_price) * sls_quantity
                    else sls_sales
               end AS sls_sales
              ,sls_quantity 
               ,CASE WHEN sls_price <=0 or sls_price is null then sls_sales/NULLIF(sls_quantity,0)
                     ELSE sls_price
                END AS sls_price
          FROM [DataWarehouse].[bronze].[crm_sales_details];
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		


		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();

        PRINT '>> Truncating data from :silver.erp_CUST_AZ12';
        TRUNCATE TABLE silver.erp_CUST_AZ12;
        PRINT '>> Inserting data into:silver.erp_CUST_AZ12';
        insert into silver.erp_CUST_AZ12(cid,bdate,gen)
        select 
        case when cid like 'NAS%' THEN SUBSTRING(cid,4,len(cid))
	         else cid
        end as cid,
        case when bdate > GETDATE() THEN NULL
	         ELSE bdate
        end as bdate,
        case when upper(trim(gen)) in ('F','Female') then 'Female'
	         when upper(trim(gen)) in ('M','Male') then 'Male'
	         Else 'n/a'
        end gen
        from bronze.erp_CUST_AZ12;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();

        PRINT '>> Truncating data from :silver.erp_LOC_A101';
        TRUNCATE TABLE silver.erp_LOC_A101;
        PRINT '>> Inserting data into:silver.erp_LOC_A101';
        insert into silver.erp_LOC_A101 (cid,cntry)
        select 
        Replace(cid, '-','') as cid,
        CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
	         WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	         WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n/a'
	         else TRIM(cntry)
        end as cntry
        from bronze.erp_LOC_A101;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		
		SET @start_time = GETDATE();

        PRINT '>> Truncating data from :silver.erp_PX_CAT_G1V2';
        TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
        PRINT '>> Inserting data into:silver.erp_PX_CAT_G1V2';
        insert into silver.erp_PX_CAT_G1V2(id,cat,subcat,maintenance)
        select 
        id,
        cat,
        subcat,
        maintenance
        from bronze.erp_PX_CAT_G1V2;

		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

	END TRY
	BEGIN CATCH		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH	
END

exec silver.load_silver
