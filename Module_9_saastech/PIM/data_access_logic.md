# Pseudo-code for Product CRUD Operations

## 1. Write pseudo-code for creating a new product record. This should include validating input data and handling potential errors (e.g., duplicate SKUs).

```
Input:
    Product Details
    Product Type
    Product Identifiers (SKU, UPC, etc.)
    Features
    Categories
    Catalog
    Prices

1. Validate mandatory fields.
    IF Product Name is empty
        Return "Product Name is required"

2. Validate Product Type.
    IF ProductType does not exist
        Return "Invalid Product Type"

3. Validate Good Identifications.
    FOR each identification
        Check whether active value already exists.
        IF exists
            Return "Duplicate SKU/Identifier"

4. Generate new ProductId.

5. Insert Product record.

6. Insert GoodIdentification records.

7. FOR each Feature
        Search ProductFeature.
        IF feature exists
            Use existing ProductFeatureId.
        ELSE
            Create new ProductFeature.

        Create ProductFeatureAppl mapping.

8. Validate Category.
    IF Category exists
        Create ProductCategoryMember.

9. Validate Catalog.
    IF Catalog exists
        Create ProdCatalogCategory if required.

10. Insert ProductPrice records.

Return Success

ON ERROR
    Return Error
```

---

## 2. Write pseudo-code for retrieving a product record based on its unique identifier (e.g., SKU or product ID).

```
Input:
    SKU OR ProductId

IF input is SKU

    Search GoodIdentification using Value.

    IF not found
        Return "Product Not Found"

    Get ProductId.

ELSE
    ProductId = Input

Fetch Product.
Fetch Product Features using ProductFeatureAppl.
Fetch Product Categories using ProductCategoryMember.
Fetch Catalog using
ProductCategory
→ ProdCatalogCategory
→ ProdCatalog.
Fetch Product Prices.
Fetch all Good Identifications.
Return Complete Product Details.
```

---

## 3. Write pseudo-code for updating an existing product record. This should include handling changes to product variations, pricing, and other attributes.

```
Input:
    ProductId
    Updated Product Details

1. Verify Product exists.
2. Update Product information.
3. IF Product Type changes
        Validate new Product Type.
        Update Product.
4. Update Identifiers.
    FOR each Identifier
        Check duplicate value.
        IF duplicate
            Return Error
        IF Identifier exists
            Update Value
        ELSE
            Insert new GoodIdentification

5. Update Features.
    FOR each Feature
        Search ProductFeature.
        IF not found
            Create ProductFeature.
        IF Product already linked
            Continue
        ELSE
            thruDate old ProductFeatureAppl if replacing.
            Create new ProductFeatureAppl.

6. Update Categories.
    Add new cateogry and then will add and link the product.

7. Update Prices.
    IF price changes

        Set thruDate on existing ProductPrice.
        Insert new ProductPrice with new fromDate.

8. Update Catalog mapping if required.

```

---

## 4. Write pseudo-code for handling product deletions (consider implications and alternatives like "soft deletes" or archiving).

```
Input:
    ProductId

1. Verify Product exists.
2. Set SalesDiscontinuationDate in Product.
3. Set SupportDiscontinuationDate if applicable.
4. set thruDate to  every GoodIdentification.
5. set thruDate to every ProductCategoryMember.
6. set thruDate to every ProductFeatureAppl.
7. set thruDate to all ProductPrice related to that product.

If success - If have soft deleted the product 
Else - The Transaction to be roll back 
```
