Requirement Analysis 
# Requirement Analysis for Product Information Management (PIM)

## Objective

The goal is to design a Product Information Management (PIM) system that stores, organizes, and manages product data in a normalized manner while supporting integration with external systems and efficient product browsing.

## Requirements

### 1. Product Management

The system should have a `Product` table to store the basic information of every product, such as:

* Product ID
* Product Name
* Product Type
* Internal Name
* Product Status
* Other basic product attributes

This table serves as the central entity of the PIM.

---

### 2. Product Features

Many products share common attributes such as Color, Size, Material, Brand, etc. Storing these values repeatedly for every product leads to data redundancy.

To avoid duplication, the system should maintain:

* `ProductFeature` – stores feature values (e.g., Red, Blue, Large, Cotton).
* `ProductFeatureType` – defines the type of feature (Color, Size, Material).
* `ProductFeatureCategory` – groups similar features.
* `ProductFeatureAppl` – maps products to their applicable features.

This design keeps the database normalized and allows features to be reused across multiple products.

---

### 3. Product Identification

Since the PIM will integrate with external systems such as ERPs, marketplaces, and suppliers, a product may have multiple identifiers like:

* SKU
* UPC
* EAN
* ISBN
* Supplier Product Code

To support this, the following tables are required:

* `GoodIdentificationType` – defines the type of identification.
* `GoodIdentification` – stores the identification value for each product.

A product can therefore have multiple identifiers without modifying the Product table.

---

### 4. Catalog and Category Management

Products need to be displayed in different catalogs and categories on the UI. A product may belong to multiple categories, and categories may have a hierarchical structure.

The following entities are required:

* `ProdCatalog` – Defines all available catalogs.
* `ProductCategory` – Defines all available categories.
* `ProductCategoryRollup` – Maintains parent-child relationships between categories.
* `ProdCatalogCategory` – Maps categories to catalogs.
* `ProductCategoryMember` – Maps products to categories.

This structure enables:

* Multiple catalogs
* Nested categories
* Products belonging to multiple categories
* Efficient navigation and product browsing

---

### 5. Product Pricing

A product can have multiple prices depending on business requirements, such as:

* List Price
* Default Price
* Sale Price
* Promotional Price
* Wholesale Price

Prices may also vary by:

* Store Group
* Currency
* Effective Date

To support this, the following tables are required:

* `ProductPriceType` – Defines different price types.
* `ProductPricePurpose` – Defines the purpose of a price.
* `ProductPrice` – Stores the actual price along with validity dates.

This allows the system to maintain multiple time-effective prices for the same product.

---

## Database Entities Required

### Core Product

* Product
* ProductType

### Product Features

* ProductFeature
* ProductFeatureType
* ProductFeatureCategory
* ProductFeatureAppl
* ProductFeatureApplType

### Product Identification

* GoodIdentification
* GoodIdentificationType

### Catalog & Category

* ProdCatalog
* ProductCategory
* ProductCategoryType
* ProductCategoryRollup
* ProdCatalogCategory
* ProdCatalogCategoryType
* ProductCategoryMember

### Product Pricing

* ProductPrice
* ProductPriceType
* ProductPricePurpose

## Summary

The proposed database design follows normalization principles, minimizes data duplication, supports multiple external product identifiers, enables hierarchical catalog and category management, allows reusable product features, and supports multiple time-effective pricing strategies. This provides a scalable and extensible foundation for the Product Information Management (PIM) system.




