CREATE TABLE ProductType (
    productTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),
    isPhysical CHAR(1),
    isDigital CHAR(1),
    CONSTRAINT fk_producttype_parent
        FOREIGN KEY (parentTypeId)
        REFERENCES ProductType(productTypeId)
);

CREATE TABLE Product (
    productId VARCHAR(20) PRIMARY KEY,
    productTypeId VARCHAR(20),
    supportDiscontinuationDate DATETIME,
    salesDiscontinuationDate DATETIME,
    isVariant CHAR(1),
    isVirtual CHAR(1),
    internalName VARCHAR(255),
    productName VARCHAR(255),
    CONSTRAINT fk_product_type
        FOREIGN KEY (productTypeId)
        REFERENCES ProductType(productTypeId)
);

CREATE TABLE ProductPriceType (
    productPriceTypeId VARCHAR(20) PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE ProductPricePurpose (
    productPricePurposeId VARCHAR(20) PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE ProductPrice (
    productId VARCHAR(20),
    productPriceTypeId VARCHAR(20),
    productPricePurposeId VARCHAR(20),
    currencyUomId VARCHAR(20),
    productStoreGroupId VARCHAR(20),
    fromDate DATETIME,
    thruDate DATETIME,
    price DECIMAL(18,2),

    PRIMARY KEY (
        productId,
        productPriceTypeId,
        productPricePurposeId,
        currencyUomId,
        productStoreGroupId,
        fromDate
    ),

    FOREIGN KEY (productId)
        REFERENCES Product(productId),

    FOREIGN KEY (productPriceTypeId)
        REFERENCES ProductPriceType(productPriceTypeId),

    FOREIGN KEY (productPricePurposeId)
        REFERENCES ProductPricePurpose(productPricePurposeId)
);

CREATE TABLE ProductFeatureType (
    productFeatureTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),
    FOREIGN KEY (parentTypeId)
        REFERENCES ProductFeatureType(productFeatureTypeId)
);

CREATE TABLE ProductFeatureCategory (
    productFeatureCategoryId VARCHAR(20) PRIMARY KEY,
    parentCategoryId VARCHAR(20),
    description VARCHAR(255),
    FOREIGN KEY (parentCategoryId)
        REFERENCES ProductFeatureCategory(productFeatureCategoryId)
);

CREATE TABLE ProductFeature (
    productFeatureId VARCHAR(20) PRIMARY KEY,
    productFeatureTypeId VARCHAR(20),
    productFeatureCategoryId VARCHAR(20),
    description VARCHAR(255),

    FOREIGN KEY (productFeatureTypeId)
        REFERENCES ProductFeatureType(productFeatureTypeId),

    FOREIGN KEY (productFeatureCategoryId)
        REFERENCES ProductFeatureCategory(productFeatureCategoryId)
);

CREATE TABLE ProductFeatureApplType (
    productFeatureApplTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),

    FOREIGN KEY (parentTypeId)
        REFERENCES ProductFeatureApplType(productFeatureApplTypeId)
);

CREATE TABLE ProductFeatureAppl (
    productId VARCHAR(20),
    productFeatureId VARCHAR(20),
    productFeatureApplTypeId VARCHAR(20),
    fromDate DATETIME,
    thruDate DATETIME,
    sequenceNum INT,

    PRIMARY KEY (
        productId,
        productFeatureId,
        fromDate
    ),

    FOREIGN KEY (productId)
        REFERENCES Product(productId),

    FOREIGN KEY (productFeatureId)
        REFERENCES ProductFeature(productFeatureId),

    FOREIGN KEY (productFeatureApplTypeId)
        REFERENCES ProductFeatureApplType(productFeatureApplTypeId)
);

CREATE TABLE ProdCatalog (
    prodCatalogId VARCHAR(20) PRIMARY KEY,
    catalogName VARCHAR(255),
    styleSheet VARCHAR(255),
    useQuickAdd CHAR(1)
);

CREATE TABLE ProductCategoryType (
    productCategoryTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),

    FOREIGN KEY (parentTypeId)
        REFERENCES ProductCategoryType(productCategoryTypeId)
);

CREATE TABLE ProductCategory (
    productCategoryId VARCHAR(20) PRIMARY KEY,
    productCategoryTypeId VARCHAR(20),
    categoryName VARCHAR(255),
    description VARCHAR(255),

    FOREIGN KEY (productCategoryTypeId)
        REFERENCES ProductCategoryType(productCategoryTypeId)
);

CREATE TABLE ProdCatalogCategoryType (
    prodCatalogCategoryTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),

    FOREIGN KEY (parentTypeId)
        REFERENCES ProdCatalogCategoryType(prodCatalogCategoryTypeId)
);

CREATE TABLE ProdCatalogCategory (
    prodCatalogId VARCHAR(20),
    productCategoryId VARCHAR(20),
    prodCatalogCategoryTypeId VARCHAR(20),
    fromDate DATETIME,
    thruDate DATETIME,
    sequenceNum INT,

    PRIMARY KEY (
        prodCatalogId,
        productCategoryId,
        prodCatalogCategoryTypeId,
        fromDate
    ),

    FOREIGN KEY (prodCatalogId)
        REFERENCES ProdCatalog(prodCatalogId),

    FOREIGN KEY (productCategoryId)
        REFERENCES ProductCategory(productCategoryId),

    FOREIGN KEY (prodCatalogCategoryTypeId)
        REFERENCES ProdCatalogCategoryType(prodCatalogCategoryTypeId)
);

CREATE TABLE ProductCategoryRollup (
    productCategoryId VARCHAR(20),
    parentProductCategoryId VARCHAR(20),
    fromDate DATETIME,
    thruDate DATETIME,
    sequenceNum INT,

    PRIMARY KEY (
        productCategoryId,
        parentProductCategoryId,
        fromDate
    ),

    FOREIGN KEY (productCategoryId)
        REFERENCES ProductCategory(productCategoryId),

    FOREIGN KEY (parentProductCategoryId)
        REFERENCES ProductCategory(productCategoryId)
);

CREATE TABLE ProductCategoryMember (
    productCategoryId VARCHAR(20),
    productId VARCHAR(20),
    fromDate DATETIME,
    thruDate DATETIME,
    sequenceNum INT,

    PRIMARY KEY (
        productCategoryId,
        productId,
        fromDate
    ),

    FOREIGN KEY (productCategoryId)
        REFERENCES ProductCategory(productCategoryId),

    FOREIGN KEY (productId)
        REFERENCES Product(productId)
);

CREATE TABLE GoodIdentificationType (
    goodIdentificationTypeId VARCHAR(20) PRIMARY KEY,
    parentTypeId VARCHAR(20),
    hasTable CHAR(1),
    description VARCHAR(255),

    CONSTRAINT fk_goodidenttype_parent
        FOREIGN KEY (parentTypeId)
        REFERENCES GoodIdentificationType(goodIdentificationTypeId)
);	

CREATE TABLE GoodIdentification (
    goodIdentificationTypeId VARCHAR(20),
    productId VARCHAR(20),
    value VARCHAR(255),
    fromDate DATETIME,
    thruDate DATETIME,

    PRIMARY KEY (
        goodIdentificationTypeId,
        productId,
        fromDate
    ),

    CONSTRAINT fk_goodident_type
        FOREIGN KEY (goodIdentificationTypeId)
        REFERENCES GoodIdentificationType(goodIdentificationTypeId),

    CONSTRAINT fk_goodident_product
        FOREIGN KEY (productId)
        REFERENCES Product(productId)
);
