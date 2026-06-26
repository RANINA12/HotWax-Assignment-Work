# Shopify Product Import Pseudo-code

## 1. Retrieve Product Data from Shopify Product API

```text
Input:
    Shopify Product ID
Read Shopify Store URL.
Read Shopify Access Token.
Construct GraphQL Query.
Send HTTP POST request to Shopify GraphQL API.
IF API returns an error
    Log Error.
    Return Failure.
Parse JSON Response.
Extract Product information:
    Product ID
    Title
    Handle
    Product Type
    Tags
    Product Options
    Featured Media
Return Parsed Product Object.
```

---

## 2. Transform Shopify Product into UDM Format

```text
Input:
    Shopify Product JSON
Create empty UDM Product object.
Map Product fields.
    Product.productName = Shopify.title
    Product.internalName = Shopify.handle
    Product.productType = Shopify.productType
Create GoodIdentification.
    Type = SHOPIFY_PRODUCT_ID
    Value = Shopify.id
FOR each Product Option
    Check whether ProductFeature exists.
    IF exists
        Use existing ProductFeatureId.
    ELSE
        Create new ProductFeature.
    END IF
    Create ProductFeatureAppl.
END FOR
FOR each Tag
    Convert Tag into Product Category
    OR
    Store as Product Feature depending on business rule.
END FOR
IF Featured Media exists
    Store Image URL.
Return UDM Product Object.
```

---

## Conflict Handling

* Validate Product Type before insertion.
* Use `GoodIdentification (SHOPIFY_PRODUCT_ID)` as the unique identifier to detect existing products.
* Reuse existing `ProductFeature` records instead of creating duplicates.
* Reuse existing `ProductCategory` records.
* Prevent duplicate `ProductFeatureAppl` mappings.
* Use UPSERT for `ProductPrice`.
* Roll back the transaction if any insert or update fails.
* Log API errors, validation errors, and database exceptions for troubleshooting.
