# SQL Queries Reference

---

## Query 1 — New Customers Acquired in June 2023

Business Problem:
The marketing team ran a campaign in June 2023 and wants to see how many new customers signed up during that period.

```sql
SELECT
    p.party_id,
    pp.first_name,
    pp.last_name,
    cm.info_String,
    tn.contact_number
FROM party p
LEFT JOIN party_role pr ON p.party_id = pr.party_id
LEFT JOIN person pp ON pp.party_id = pr.party_id
LEFT JOIN Party_Contact_mech pcm ON pcm.party_id = pp.party_id
LEFT JOIN contact_mech cm ON pcm.contact_mech_id = cm.contact_mech_id
LEFT JOIN telecom_number tn ON cm.contact_mech_id = tn.contact_mech_id
WHERE pr.role_type_id = "CUSTOMER"
  AND p.created_stamp BETWEEN "2023-06-01" AND "2023-07-01";
```
(cost=12.6 rows=3.03) (actual time=0.395..0.395 rows=0 loops=1)

---

## Query 2 — List All Active Physical Products

Business Problem:
Merchandising teams often need a list of all physical products to manage logistics, warehousing, and shipping.

```sql
SELECT
    product_id,
    product_type_id,
    internal_name
FROM product
WHERE (SALES_DISCONTINUATION_DATE IS NULL OR SALES_DISCONTINUATION_DATE > NOW())
  AND product_type_id NOT IN (
      SELECT product_type_id
      FROM product_type
      WHERE is_physical = "N"
  );
```
(cost=11.8 rows=84.8) (actual time=8.61..11.2 rows=91 loops=1)
Here If I gonna use IN method , then Cost increase to 21.8

---

## Query 3 — Products Missing NetSuite ID

Business Problem:
A product cannot sync to NetSuite unless it has a valid NetSuite ID. The OMS needs a list of all products that still need to be created or updated in NetSuite.

```sql
SELECT
    p.product_id,
    p.Internal_name,
    p.product_type_id,
    gi.good_identification_type_id
FROM good_identification gi
RIGHT JOIN product p 
    ON p.product_id = gi.product_id
    AND gi.good_identification_type_id = 'ERP_ID'
WHERE p.product_type_id = 'FINISHED_GOOD'
  AND gi.id_value IS NULL;
```
(cost=127 rows=91) (actual time=0.121..0.814 rows=91 loops=1
---

## Query 4 — Product IDs Across Systems

Business Problem:
To sync an order or product across multiple systems (e.g., Shopify, HotWax, ERP/NetSuite), the OMS needs to know each system’s unique identifier for that product. This query retrieves the Shopify ID, HotWax ID, and ERP ID (NetSuite ID) for all products.

```sql
SELECT
    p.product_id,
    CASE WHEN GI.good_Identification_type_id = "ERP_ID"
         THEN GI.good_Identification_type_id ELSE NULL END AS NS_id,
    CASE WHEN GI.good_Identification_type_id = "HS_CODE"
         THEN GI.good_Identification_type_id ELSE NULL END AS HS_id,
    CASE WHEN GI.good_Identification_type_id = "SHOPIFY_PROD_ID"
         THEN GI.good_Identification_type_id ELSE NULL END AS Shopify_id
FROM product p
LEFT JOIN good_Identification GI ON GI.product_id = p.product_id
WHERE product_type_id = "FINISHED_GOOD";
```
(cost=41.8 rows=92.8) (actual time=0.0695..0.533 rows=91 loops=1)

---

## Query 5 — Completed Orders in August 2023

Business Problem:
After running similar reports for a previous month, you now need all completed orders in August 2023 for analysis.


```sql
SELECT  
    p.PRODUCT_ID, 
    psc.PRODUCT_STORE_ID,
    p.INTERNAL_NAME,
    p.PRODUCT_TYPE_ID, 
    ohis.ORDER_HISTORY_ID,
    OI.QUANTITY,
    f.FACILITY_ID, 
    OI.EXTERNAL_ID,
    f.FACILITY_TYPE_ID,
    OI.ORDER_ID,
    OI.ORDER_ITEM_SEQ_ID, 
    OI.SHIP_GROUP_SEQ_ID 
FROM 
    ORDER_ITEM OI 
JOIN 
    PRODUCT p 
    ON p.PRODUCT_ID = OI.PRODUCT_ID 
JOIN 
    ORDER_ITEM_SHIP_GROUP oisg  
    ON OI.ORDER_ID = oisg.ORDER_ID 
    AND OI.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
JOIN 
    FACILITY f 
    ON f.FACILITY_ID = oisg.FACILITY_ID 
    AND oisg.FACILITY_ID <> '_NA_'
JOIN 
    PRODUCT_STORE_CATALOG psc 
    ON OI.PROD_CATALOG_ID = psc.PROD_CATALOG_ID
JOIN 
    ORDER_HISTORY ohis 
    ON ohis.ORDER_ID = OI.ORDER_ID 
    AND ohis.ORDER_ITEM_SEQ_ID = OI.ORDER_ITEM_SEQ_ID 
JOIN 
    ORDER_STATUS os 
    ON os.ORDER_ID = OI.ORDER_ID 
    AND os.ORDER_ITEM_SEQ_ID = OI.ORDER_ITEM_SEQ_ID 
WHERE 
    os.STATUS_ID = 'ORDER_COMPLETED' 
    AND os.STATUS_DATETIME >= '2023-08-01' 
    AND os.STATUS_DATETIME <= '2023-09-01';
```
With left Join  (cost=1.66 rows=0.111) (actual time=0.434..0.434 rows=0 loops=1)
Without left Join  (cost=0.526 rows=0.00123) (actual time=0.0633..0.0633 rows=0 loops=1)

---

## Query 6 — Newly Created Sales Orders and Payment Methods

Business Problem:
Finance teams need to see new orders and their payment methods for reconciliation and fraud checks.


```sql
SELECT
    OPP.Payment_Method_Type_Id,
    OPP.order_id,
    OPP.MAX_Amount,
    OH.External_iD
FROM ORDER_HEADER OH 
JOIN ORDER_PAYMENT_PREFERENCE OPP 
ON OH.ORDER_ID = OPP.ORDER_ID
ORDER BY OPP.ORDER_ID;
```

---

## Query 7 — Payment Captured but Not Shipped

Business Problem:
Finance teams want to ensure revenue is recognized properly. If payment is captured but no shipment has occurred, it warrants further review.

```sql
SELECT
    OH.ORDER_ID,
    OH.STATUS_ID AS ORDER_STATUS,
    OPP.STATUS_ID AS PAYMENT_STATUS,
    "NO_SHIPMENT_YET" AS SHIPMENT_STATUS
FROM ORDER_PAYMENT_PREFERENCE OPP
JOIN ORDER_HEADER OH ON OH.ORDER_ID = OPP.ORDER_ID
LEFT JOIN SHIPMENT S ON S.PRIMARY_ORDER_ID = OPP.ORDER_ID
WHERE OPP.STATUS_ID = "PAYMENT_SETTLED"
  AND S.SHIPMENT_ID IS NULL;
```

---

## Query 8 — Orders Completed Hourly

Business Problem:
Operations teams may want to see how orders complete across the day to schedule staffing.


```sql
SELECT
    HOUR(ENTRY_DATE) AS hour,
    COUNT(ORDER_ID) AS total_orders
FROM ORDER_HEADER
WHERE STATUS_ID = 'ORDER_COMPLETED'
  AND ENTRY_DATE BETWEEN DATE_SUB(NOW(), INTERVAL 1 MONTH) AND NOW()
GROUP BY HOUR(ENTRY_DATE)
ORDER BY hour;
```

--- 

## Query 9 — BOPIS Orders Revenue (Last Year)

Business Problem:
BOPIS (Buy Online, Pickup In Store) is a key retail strategy. Finance wants to know the revenue from BOPIS orders for the previous year.

```sql
SELECT 
COUNT(OA.ORDER_ID)  ORDER_COUNT ,
SUM(IFNULL(OH.GRAND_TOTAL, 0) - IFNULL(OA.OTHER_CHARGES, 0)) AS REVENUE 
FROM ORDER_HEADER OH
JOIN 
(SELECT  
AD.ORDER_ID , 
SUM(IFNULL(AD.AMOUNT , 0))OTHER_CHARGES 
FROM ORDER_HEADER OH
JOIN ORDER_ITEM_SHIP_GROUP OISG
ON OISG.ORDER_ID = OH.ORDER_ID AND SHIPMENT_METHOD_TYPE_ID = "STOREPICKUP"
LEFT JOIN ORDER_ADJUSTMENT AD
ON AD.ORDER_ID = OH.ORDER_ID 
GROUP BY ORDER_ID ) OA
ON OA.ORDER_ID = OH.ORDER_ID
JOIN ORDER_STATUS OS
    ON OS.ORDER_ID = OH.ORDER_ID 
    WHERE 
    OS.STATUS_ID = 'ITEM_COMPLETED' 
    AND OS.STATUS_DATETIME >= '2025-01-01' 
    AND OS.STATUS_DATETIME <= '2026-06-01';

```
(cost=1.28 rows=0) (actual time=0.0468..0.0468 rows=0 loops=1)

---

## Query 10 — Canceled Orders (Last Month)

Business Problem:
The merchandising team needs to know how many orders were canceled in the previous month and their reasons.

```sql
SELECT
    COUNT(IFNULL(ORDER_ID, 0)) AS ORDER_ITEM_CANCEL,
    CHANGE_REASON
FROM ORDER_STATUS
WHERE STATUS_ID = "ITEM_CANCELLED"
    AND STATUS_DATETIME >= '2026-05-01' 
    AND STATUS_DATETIME <= '2026-06-01'
GROUP BY Change_Reason;

```
(cost=0.261 rows=0.111) (actual time=0.0262..0.0262 rows=0 loops=1)

---

## Query 11 — Product Threshold Value

Business Problem The retailer has set a threshold value for products that are sold online, in order to avoid over selling.

```sql
SELECT
    product_id,
    SUM(IFNULL(minimum_stock, 0)) AS total_minimum_stock
FROM product_facility
GROUP BY product_id;
```
(cost=1.2 rows=2) (actual time=9.31..9.31 rows=2 loops=1)
---
