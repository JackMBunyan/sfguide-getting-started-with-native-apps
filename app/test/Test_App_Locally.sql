-- #########################################
-- DB SETUP
-- #########################################

CREATE OR REPLACE DATABASE NATIVE_APP_SUMMIT_DB;
USE DATABASE NATIVE_APP_SUMMIT_DB;

CREATE OR REPLACE SCHEMA NATIVE_APP_SUMMIT_SCHEMA;
USE SCHEMA NATIVE_APP_SUMMIT_SCHEMA;

CREATE OR REPLACE STAGE NATIVE_APP_SUMMIT_STAGE;

CREATE OR REPLACE TABLE MFG_ORDERS (
  order_id NUMBER(38,0), 
  material_name VARCHAR(60),
  supplier_name VARCHAR(60),
  quantity NUMBER(38,0),
  cost FLOAT,
  process_supply_day NUMBER(38,0)
);

-- Load app/data/orders_data.csv using Snowsight

CREATE OR REPLACE TABLE MFG_SHIPPING (
  order_id NUMBER(38,0), 
  ship_order_id NUMBER(38,0),
  status VARCHAR(60),
  lat FLOAT,
  lon FLOAT,
  duration NUMBER(38,0)
);

-- Load app/data/shipping_data.csv using Snowsight

CREATE OR REPLACE TABLE MFG_SITE_RECOVERY (
  event_id NUMBER(38,0), 
  recovery_weeks NUMBER(38,0),
  lat FLOAT,
  lon FLOAT
);

-- Load app/data/site_recovery_data.csv using Snowsight

################################################################
Create application package
################################################################


################################################################
Create SHARED_CONTENT_SCHEMA to share in the application package
################################################################
use database HELLO_SNOWFLAKE_PACKAGE;
create schema shared_content_schema;

use schema shared_content_schema;
create or replace view MFG_SHIPPING as select * from NATIVE_APP_SUMMIT_DB.NATIVE_APP_SUMMIT_SCHEMA.MFG_SHIPPING;

grant usage on schema shared_content_schema to share in application package HELLO_SNOWFLAKE_PACKAGE;
grant reference_usage on database NATIVE_APP_SUMMIT_DB to share in application package HELLO_SNOWFLAKE_PACKAGE;
grant select on view MFG_SHIPPING to share in application package HELLO_SNOWFLAKE_PACKAGE;

-- ################################################################
-- TEST APP LOCALLY
-- ################################################################

USE DATABASE NATIVE_APP_SUMMIT_DB;
USE SCHEMA NATIVE_APP_SUMMIT_SCHEMA;

-- This executes "setup.sql" linked in the manifest.yml; This is also what gets executed when installing the app
CREATE APPLICATION NATIVE_APP_SUMMIT_APP FROM application package HELLO_SNOWFLAKE_PACKAGE using version 1 patch 0;
-- For example, CREATE APPLICATION LEAD_TIME_OPTIMIZER_APP FROM application package LEAD_TIME_OPTIMIZER_PKG using version V1 patch 0;

-- At this point you should see and run the app NATIVE_APP_SUMMIT_APP listed under Apps
SHOW APPLICATION PACKAGES;