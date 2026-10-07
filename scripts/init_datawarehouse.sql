/*
===============================================================================
    Data Warehouse Database Setup
===============================================================================

    Purpose:
        This script creates the DataWarehouse database and defines the
        three-layer architecture used in the data warehouse.

    Layers:
        Bronze  -> Raw/source data
        Silver  -> Cleaned and transformed data
        Gold    -> Business-ready/analytical data

    Steps:
        1. Switch to the master database.
        2. Create the DataWarehouse database.
        3. Switch to the DataWarehouse database.
        4. Create the Bronze, Silver, and Gold schemas.

===============================================================================
    ⚠ WARNING
===============================================================================

    This script creates a new database named 'DataWarehouse' and its schemas.

    IMPORTANT:
    - Make sure the database does not already exist before running this script.
    - Running this script with an existing database name may cause an error.
    - Verify the target SQL Server instance before execution.
===============================================================================

*/

 
  
 --Create Database 'DataWarehouse'

Use master;

Create Database DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
