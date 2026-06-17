# Product Manager Component

## Overview
This project is an assignment-based Apache OFBiz component focused on Product Catalog and Store management.

The objective of this assignment was to understand the OFBiz entity model, screen widget system, form configurations, and seed data initialization by building a custom product architecture component from scratch.

## Features Implemented

### Product Management
Implemented core entities and relational logic for managing physical and virtual products, including:
- Product creation (Virtual, Variant, and Physical items)
- Product Pricing management (List price, Default price, Wholesale, etc.)
- Product Associations (Variants, Accessories, Upgrades)
- Product Feature application (Colors, Sizes, Warranties)

### Catalog & Category Management
Implemented structured catalog hierarchies, including:
- Product Catalog creation
- Product Category management (Tax, Best Sellers, Promotions)
- Parent/Child Category rollups
- Adding Products as members to Categories
- Catalog to Category mappings

### Store Management
Implemented storefront configuration structures, including:
- Product Store creation
- Product Store Group management

## Data Configuration
Created required data files to initialize the product domain, including:
- Seed data for structural types (Product Types, Feature Types, Association Types)
- Minimal default store and catalog initialization data

## UI Implementation
Designed completely custom OFBiz UI components, bypassing standard search flows for direct-to-create navigation, including:
- Screens (`ProductScreens.xml`, `StoreScreens.xml`, `FeatureScreens.xml`, `CatalogScreens.xml`, `CategoryScreens.xml`)
- Forms (`ProductForms.xml`, `StoreForms.xml`, etc.)
- Menus (`Menus.xml` featuring a direct-create two-tier navigation structure)
- UI Labels configuration
- Controller routing and HTTP request/view mappings
