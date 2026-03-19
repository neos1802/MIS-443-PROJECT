-- A. Create the database and tables, import the data, and set up the views and keys with:
-- CREATE DATABASE "Adventureworks";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
DROP SCHEMA IF EXISTS Production CASCADE;
DROP DOMAIN IF EXISTS "Flag";
DROP DOMAIN IF EXISTS "Name";

-- B. Custom data types

CREATE DOMAIN "Flag" boolean NOT NULL;
CREATE DOMAIN "Name" varchar(50) NULL;

-- C. Schema Production
--CREATE SCHEMA Production

CREATE SCHEMA IF NOT EXISTS Production;

CREATE TABLE Production.ProductCategory(
    ProductCategoryID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductCategory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductCategory_ModifiedDate" DEFAULT (NOW())
  );
CREATE TABLE Production.ProductSubcategory(
    ProductSubcategoryID SERIAL NOT NULL, -- int
    ProductCategoryID INT NOT NULL,
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductSubcategory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductSubcategory_ModifiedDate" DEFAULT (NOW())
  );
CREATE TABLE Production.Product(
    ProductID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    ProductNumber varchar(25) NOT NULL,
    MakeFlag "Flag" NOT NULL CONSTRAINT "DF_Product_MakeFlag" DEFAULT (true),
    FinishedGoodsFlag "Flag" NOT NULL CONSTRAINT "DF_Product_FinishedGoodsFlag" DEFAULT (true),
    Color varchar(15) NULL,
    SafetyStockLevel smallint NOT NULL,
    ReorderPoint smallint NOT NULL,
    StandardCost numeric NOT NULL, -- money
    ListPrice numeric NOT NULL, -- money
    Size varchar(5) NULL,
    SizeUnitMeasureCode char(3) NULL,
    WeightUnitMeasureCode char(3) NULL,
    Weight decimal(8, 2) NULL,
    DaysToManufacture INT NOT NULL,
    ProductLine char(2) NULL,
    Class char(2) NULL,
    Style char(2) NULL,
    ProductSubcategoryID INT NULL,
    ProductModelID INT NULL,
    SellStartDate TIMESTAMP NOT NULL,
    SellEndDate TIMESTAMP NULL,
    DiscontinuedDate TIMESTAMP NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_Product_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Product_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Product_SafetyStockLevel" CHECK (SafetyStockLevel > 0),
    CONSTRAINT "CK_Product_ReorderPoint" CHECK (ReorderPoint > 0),
    CONSTRAINT "CK_Product_StandardCost" CHECK (StandardCost >= 0.00),
    CONSTRAINT "CK_Product_ListPrice" CHECK (ListPrice >= 0.00),
    CONSTRAINT "CK_Product_Weight" CHECK (Weight > 0.00),
    CONSTRAINT "CK_Product_DaysToManufacture" CHECK (DaysToManufacture >= 0),
    CONSTRAINT "CK_Product_ProductLine" CHECK (UPPER(ProductLine) IN ('S', 'T', 'M', 'R') OR ProductLine IS NULL),
    CONSTRAINT "CK_Product_Class" CHECK (UPPER(Class) IN ('L', 'M', 'H') OR Class IS NULL),
    CONSTRAINT "CK_Product_Style" CHECK (UPPER(Style) IN ('W', 'M', 'U') OR Style IS NULL),
    CONSTRAINT "CK_Product_SellEndDate" CHECK ((SellEndDate >= SellStartDate) OR (SellEndDate IS NULL))
  );
CREATE TABLE Production.Location(
    LocationID SERIAL NOT NULL, -- smallint
    Name "Name" NOT NULL,
    CostRate numeric NOT NULL CONSTRAINT "DF_Location_CostRate" DEFAULT (0.00), -- smallmoney -- money
    Availability decimal(8, 2) NOT NULL CONSTRAINT "DF_Location_Availability" DEFAULT (0.00),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Location_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Location_CostRate" CHECK (CostRate >= 0.00),
    CONSTRAINT "CK_Location_Availability" CHECK (Availability >= 0.00)
  );
CREATE TABLE Production.ProductInventory(
    ProductID INT NOT NULL,
    LocationID smallint NOT NULL,
    Shelf varchar(10) NOT NULL,
    Bin smallint NOT NULL, -- tinyint
    Quantity smallint NOT NULL CONSTRAINT "DF_ProductInventory_Quantity" DEFAULT (0),
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductInventory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductInventory_ModifiedDate" DEFAULT (NOW()),
--    CONSTRAINT "CK_ProductInventory_Shelf" CHECK ((Shelf LIKE 'AZa-z]') OR (Shelf = 'N/A')),
    CONSTRAINT "CK_ProductInventory_Bin" CHECK (Bin BETWEEN 0 AND 100)
  );
CREATE TABLE Production.ProductListPriceHistory(
    ProductID INT NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NULL,
    ListPrice numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductListPriceHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ProductListPriceHistory_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL)),
    CONSTRAINT "CK_ProductListPriceHistory_ListPrice" CHECK (ListPrice > 0.00)
  );
CREATE TABLE Production.UnitMeasure(
    UnitMeasureCode char(3) NOT NULL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_UnitMeasure_ModifiedDate" DEFAULT (NOW())
  );
  
-- D. import data (using PSQL Tool, change FROM by own path)

/*
SELECT 'Copying data into Production.ProductCategory';
\copy Production.ProductCategory FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/ProductCategory.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.ProductSubcategory';
\copy Production.ProductSubcategory FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/ProductSubcategory.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.Product';
\copy Production.Product FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/Product.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.Location';
\copy Production.Location FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/Location.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.ProductInventory';
\copy Production.ProductInventory FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/ProductInventory.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.ProductListPriceHistory';
\copy Production.ProductListPriceHistory FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/ProductListPriceHistory.csv' DELIMITER E'\t' CSV;

SELECT 'Copying data into Production.UnitMeasure';
\copy Production.UnitMeasure FROM 'C:/Users/neos/Downloads/MIS_443_Project/data_advwork/UnitMeasure.csv' DELIMITER E'\t' CSV;
*/

-- E. Comments
COMMENT ON TABLE Production.Product IS 'Products sold or used in the manfacturing of sold products.';
  COMMENT ON COLUMN Production.Product.ProductID IS 'Primary key for Product records.';
  COMMENT ON COLUMN Production.Product.Name IS 'Name of the product.';
  COMMENT ON COLUMN Production.Product.ProductNumber IS 'Unique product identification number.';
  COMMENT ON COLUMN Production.Product.MakeFlag IS '0 = Product is purchased, 1 = Product is manufactured in-house.';
  COMMENT ON COLUMN Production.Product.FinishedGoodsFlag IS '0 = Product is not a salable item. 1 = Product is salable.';
  COMMENT ON COLUMN Production.Product.Color IS 'Product color.';
  COMMENT ON COLUMN Production.Product.SafetyStockLevel IS 'Minimum inventory quantity.';
  COMMENT ON COLUMN Production.Product.ReorderPoint IS 'Inventory level that triggers a purchase order or work order.';
  COMMENT ON COLUMN Production.Product.StandardCost IS 'Standard cost of the product.';
  COMMENT ON COLUMN Production.Product.ListPrice IS 'Selling price.';
  COMMENT ON COLUMN Production.Product.Size IS 'Product size.';
  COMMENT ON COLUMN Production.Product.SizeUnitMeasureCode IS 'Unit of measure for Size column.';
  COMMENT ON COLUMN Production.Product.WeightUnitMeasureCode IS 'Unit of measure for Weight column.';
  COMMENT ON COLUMN Production.Product.Weight IS 'Product weight.';
  COMMENT ON COLUMN Production.Product.DaysToManufacture IS 'Number of days required to manufacture the product.';
  COMMENT ON COLUMN Production.Product.ProductLine IS 'R = Road, M = Mountain, T = Touring, S = Standard';
  COMMENT ON COLUMN Production.Product.Class IS 'H = High, M = Medium, L = Low';
  COMMENT ON COLUMN Production.Product.Style IS 'W = Womens, M = Mens, U = Universal';
  COMMENT ON COLUMN Production.Product.ProductSubcategoryID IS 'Product is a member of this product subcategory. Foreign key to ProductSubCategory.ProductSubCategoryID.';
  COMMENT ON COLUMN Production.Product.ProductModelID IS 'Product is a member of this product model. Foreign key to ProductModel.ProductModelID.';
  COMMENT ON COLUMN Production.Product.SellStartDate IS 'Date the product was available for sale.';
  COMMENT ON COLUMN Production.Product.SellEndDate IS 'Date the product was no longer available for sale.';
  COMMENT ON COLUMN Production.Product.DiscontinuedDate IS 'Date the product was discontinued.';

COMMENT ON TABLE Production.ProductCategory IS 'High-level product categorization.';
  COMMENT ON COLUMN Production.ProductCategory.ProductCategoryID IS 'Primary key for ProductCategory records.';
  COMMENT ON COLUMN Production.ProductCategory.Name IS 'Category description.';

COMMENT ON TABLE Production.ProductSubcategory IS 'Product subcategories. See ProductCategory table.';
  COMMENT ON COLUMN Production.ProductSubcategory.ProductSubcategoryID IS 'Primary key for ProductSubcategory records.';
  COMMENT ON COLUMN Production.ProductSubcategory.ProductCategoryID IS 'Product category identification number. Foreign key to ProductCategory.ProductCategoryID.';
  COMMENT ON COLUMN Production.ProductSubcategory.Name IS 'Subcategory description.';

COMMENT ON TABLE Production.ProductInventory IS 'Product inventory information.';
  COMMENT ON COLUMN Production.ProductInventory.ProductID IS 'Product identification number. Foreign key to Product.ProductID.';
  COMMENT ON COLUMN Production.ProductInventory.LocationID IS 'Inventory location identification number. Foreign key to Location.LocationID.';
  COMMENT ON COLUMN Production.ProductInventory.Shelf IS 'Storage compartment within an inventory location.';
  COMMENT ON COLUMN Production.ProductInventory.Bin IS 'Storage container on a shelf in an inventory location.';
  COMMENT ON COLUMN Production.ProductInventory.Quantity IS 'Quantity of products in the inventory location.';

COMMENT ON TABLE Production.ProductListPriceHistory IS 'Changes in the list price of a product over time.';
  COMMENT ON COLUMN Production.ProductListPriceHistory.ProductID IS 'Product identification number. Foreign key to Product.ProductID';
  COMMENT ON COLUMN Production.ProductListPriceHistory.StartDate IS 'List price start date.';
  COMMENT ON COLUMN Production.ProductListPriceHistory.EndDate IS 'List price end date';
  COMMENT ON COLUMN Production.ProductListPriceHistory.ListPrice IS 'Product list price.';

COMMENT ON TABLE Production.Location IS 'Product inventory and manufacturing locations.';
  COMMENT ON COLUMN Production.Location.LocationID IS 'Primary key for Location records.';
  COMMENT ON COLUMN Production.Location.Name IS 'Location description.';
  COMMENT ON COLUMN Production.Location.CostRate IS 'Standard hourly cost of the manufacturing location.';
  COMMENT ON COLUMN Production.Location.Availability IS 'Work capacity (in hours) of the manufacturing location.';

COMMENT ON TABLE Production.UnitMeasure IS 'Unit of measure lookup table.';
  COMMENT ON COLUMN Production.UnitMeasure.UnitMeasureCode IS 'Primary key.';
  COMMENT ON COLUMN Production.UnitMeasure.Name IS 'Unit of measure description.';

-- F. Primary keys

ALTER TABLE Production.ProductCategory ADD
    CONSTRAINT "PK_ProductCategory_ProductCategoryID" PRIMARY KEY
    (ProductCategoryID);

ALTER TABLE Production.ProductSubcategory ADD
    CONSTRAINT "PK_ProductSubcategory_ProductSubcategoryID" PRIMARY KEY
    (ProductSubcategoryID);

ALTER TABLE Production.Product ADD
    CONSTRAINT "PK_Product_ProductID" PRIMARY KEY
    (ProductID);

ALTER TABLE Production.Location ADD
    CONSTRAINT "PK_Location_LocationID" PRIMARY KEY
    (LocationID);

ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "PK_ProductInventory_ProductID_LocationID" PRIMARY KEY
    (ProductID, LocationID);

ALTER TABLE Production.ProductListPriceHistory ADD
    CONSTRAINT "PK_ProductListPriceHistory_ProductID_StartDate" PRIMARY KEY
    (ProductID, StartDate);

ALTER TABLE Production.UnitMeasure ADD
    CONSTRAINT "PK_UnitMeasure_UnitMeasureCode" PRIMARY KEY
    (UnitMeasureCode);

-- G. Foreign keys

ALTER TABLE Production.ProductSubcategory ADD
    CONSTRAINT "FK_ProductSubcategory_ProductCategory_ProductCategoryID" FOREIGN KEY
    (ProductCategoryID) REFERENCES Production.ProductCategory(ProductCategoryID);

ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_ProductSubcategory_ProductSubcategoryID" FOREIGN KEY
    (ProductSubcategoryID) REFERENCES Production.ProductSubcategory(ProductSubcategoryID);

ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_UnitMeasure_SizeUnitMeasureCode" FOREIGN KEY
    (SizeUnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);

ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_UnitMeasure_WeightUnitMeasureCode" FOREIGN KEY
    (WeightUnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);

ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "FK_ProductInventory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "FK_ProductInventory_Location_LocationID" FOREIGN KEY
    (LocationID) REFERENCES Production.Location(LocationID);

ALTER TABLE Production.ProductListPriceHistory ADD
    CONSTRAINT "FK_ProductListPriceHistory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

-- Next step:
-- Open Jupyter Notebook and run `MIS_443_Project.ipynb`
-- to load, inspect, clean, and export the data to the `cleaned` schema.