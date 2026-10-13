# Data Warehouse and Analytics Project

👋 Welcome to my Data Warehouse and Analytics Project! 🚀

This repository showcases the development of a SQL Server data warehouse, covering the complete data engineering workflow, from raw data ingestion and transformation to analytical data modeling .

The project demonstrates practical skills in SQL development, ETL pipeline design, data quality management, dimensional modeling, and data analytics. It is designed to serve as a portfolio project highlighting the implementation of a structured and scalable analytical data solution.

---
# Data Architecture

The project follows the Medallion Architecture, consisting of three layers:

![Data Architecture](docs/High%20level%20data%20architecture%20of%20the%20project.jpg)


**Bronze Layer** : Raw Data Ingestion

          -Imports source data from ERP and CRM CSV files into SQL Server.
          
          -Preserves the original source data for traceability and further processing.
          
          -Provides the foundation for downstream data transformations.


**Silver Layer** : Data Cleaning and Transformation

          -Identifies and handles data quality issues.
          
          -Standardizes data formats and values.
          
          -Integrates and prepares data for analytical use.


**Gold Layer** : Analytics-Ready Data

          -Organizes transformed data into fact and dimension tables.
          
          -Implements a star schema to support efficient analytical queries.
          
          -Provides a consistent data foundation for reporting and business intelligence.

---
#Project Objectives

The primary goal of this project is to build a modern data warehouse that consolidates sales-related information from multiple source systems into a unified analytical environment.

** The project focuses on four key areas:**

          1.Data Architecture: Implementing a layered data warehouse using the Medallion Architecture.
          
          2.ETL Development: Building SQL-based processes to extract, load, cleanse, and transform source data.
          
          3.Dimensional Modeling: Designing fact and dimension tables to support analytical workloads.
          
          4.Data Analytics: Developing SQL queries to investigate business performance, customer behavior, product performance, and sales trends.


**Skills Demonstrated**

          -SQL Server and T-SQL development
          
          -Data engineering and ETL workflows
          
          -Data cleansing and standardization
          
          -Data warehouse architecture
          
          -Dimensional modeling and star schemas
          
          -Data quality validation
          
          -SQL-based business analytics
          
          -Git and GitHub project management

---
# Technologies and Resources

The project uses the following tools and resources, with the core software tools available free of charge.



| Tool or Resource                       | Purpose                                                                  |
|----------------------------------------|--------------------------------------------------------------------------|
|SQL Server Express                      |	Database engine for storing and processing warehouse data               |
|SQL Server Management Studio (SSMS)     |	Interface for writing and executing SQL scripts                         |
|GitHub                                  |	Source control, version management, and project documentation           |
|Draw.io                                 |	Creating architecture diagrams, data flows, and data models             |
|Notion                                  |	Organizing project phases, tasks, and implementation notes              |
|Dataset                                 |ERP and CRM source files in CSV format, stored in the datasets directory  |
|Project Documentation                   |Reference for the project's implementation steps                          |

---

## 📂 Repository Structure
              ```
              Sql_Data_warehouse_project/
              │
              ├── datasets/
              │   ├── source_crm/                 # CRM source CSV files
              │   └── source_erp/                 # ERP source CSV files
              │
              ├── docs/                           # Project documentation
              │   ├── data_architecture.jpg       # Data warehouse architecture
              │   ├── data_flow.jpg               # Data flow diagrams
              │   ├── Integration_model.jpg       
              │   ├── star_schema.jpg             
              │   ├── first_project.drawio       #all diagrams draw using draw.io
              │  
              │
              ├── scripts/                        # SQL scripts
              │   ├── bronze/
              │   │   ├── ddl_bronze.sql          # Create Bronze tables
              │   │   └── proc_load_bronze.sql    # Load raw source data![Uploading image.png…]()
              |
              │   │
              │   ├── silver/
              │   │   ├── ddl_silver.sql          # Create Silver tables
              │   │   └── proc_load_silver.sql    # Clean and transform data
              │   │
              │   └── gold/
              │       └── ddl_gold.sql            # Create analytical data models
              │
              ├── test/                           # Data quality and validation scripts
              │
              |──data_catalog/                    # store catalog data of gold layer views
              |
              |──project_plan                     # store notion files which used for project plan
              |
              ├── README.md                       # Project overview and instructions
              ├── LICENSE                         # MIT Project license
              ```
---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

👩‍💻 About Me

Hi, I'm **Nadeeka Kiringoda**, a PhD researcher and Data Engineering professional with **7+ years of experience** in building reliable data pipelines, designing scalable data architectures, and developing data-driven solutions. I'm passionate about leveraging data engineering, analytics, and AI to solve real-world problems.
Thank you for visiting my repository! ⭐

### Let's stay in touch!:
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nadeeka-kiringoda)


