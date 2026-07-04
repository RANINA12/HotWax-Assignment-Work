## Query 22 — Completed Sales Orders (Physical Items)

Business Problem:
Merchants need to track only physical items (requiring shipping and fulfillment) for logistics and shipping-cost analysis.

```sql
SELECT
    oi.ORDER_ID,
    oi.ORDER_ITEM_SEQ_ID,
    p.PRODUCT_ID,
    p.PRODUCT_TYPE_ID,
    oh.SALES_CHANNEL_ENUM_ID,
    oh.ORDER_DATE,
    oh.ENTRY_DATE,
    oh.STATUS_ID,
    oh.ORDER_TYPE_ID,
    oh.PRODUCT_STORE_ID,
    os.STATUS_DATETIME
FROM ORDER_HEADER oh
JOIN ORDER_ITEM oi 
ON oh.ORDER_ID = oi.ORDER_ID
JOIN PRODUCT p 
ON p.PRODUCT_ID = oi.PRODUCT_ID
JOIN ORDER_STATUS os 
ON os.ORDER_ID = oi.ORDER_ID
WHERE p.product_type_id IN (
    SELECT product_type_id
    FROM product_type
    WHERE is_physical = "y"
)
AND oi.status_id = "ORDER_COMPLETED";
```
(cost=2.73 rows=0.291) (actual time=0.0372..0.0372 rows=0 loops=1)

---

## Query 23 — Completed Return Items

Business Problem:
Customer service and finance often need insights into returned items to manage refunds, replacements, and inventory restocking.

```sql
SELECT 
    RI.RETURN_ID ,
    OH.ORDER_ID,
    OH.PRODUCT_STORE_ID,
    RS.STATUS_DATETIME,
    RH.FROM_PARTY_ID,
    RH.RETURN_DATE,
    RH.ENTRY_DATE,
    RH.RETURN_CHANNEL_ENUM_ID
FROM RETURN_ITEM RI 
JOIN RETURN_HEADER RH
ON RI.RETURN_ID = RH.RETURN_ID
JOIN RETURN_STATUS RS 
ON RS.RETURN_ID = RI.RETURN_ID AND RS.RETURN_ITEM_SEQ_ID = RI.RETURN_ITEM_SEQ_ID
JOIN ORDER_HEADER OH 
ON OH.ORDER_ID = RI.ORDER_ID
WHERE RS.STATUS_ID = "RETURN_COMPLETED";
```
(cost=1.75 rows=1) (actual time=0.122..0.13 rows=1 loops=1)

---

## Query 24 — Single-Return Orders (Last Month)

Business Problem:
The mechandising team needs a list of orders that only have one return.

```sql
SELECT
    p.party_id,
    RI.order_id,
    p.First_name,
    p.last_name
FROM Return_Header RH
JOIN (
    SELECT
        Return_id,
        order_id
    FROM return_item
    GROUP BY order_id , Return_id
    HAVING COUNT(order_id) = 1
) RI ON RI.return_id = RH.return_id
LEFT JOIN Person p ON p.party_id = RH.from_party_id;
```
(cost=2.05 rows=1) (actual time=0.143..0.148 rows=1 loops=1)

---

## Query 25 — Returns and Appeasements

Business Problem:
The retailer needs the total amount of items, were returned as well as how many appeasements were issued.

```sql
SELECT
    COUNT(RI.return_id) AS total_return,
    COUNT(RA.RETURN_TYPE_ID)
    AS appeasement_count
FROM RETURN_ITEM RI
LEFT JOIN RETURN_ADJUSTMENT RA ON RI.return_id = RA.return_id and RA.RETURN_TYPE_ID="Appeasement"
```
(cost=2.3 rows=1) (actual time=4.69..4.69 rows=1 loops=1)

---

## Query 26 —  Detailed Return Information

Business Problem:
Certain teams need granular return data (reason, date, refund amount) for analyzing return rates, identifying recurring issues, or updating policies.

```sql
SELECT
    RH.RETURN_ID,
    OH.ENTRY_DATE,
    RA.RETURN_ADJUSTMENT_TYPE_ID,
    RA.AMOUNT,
    COMMENTS,
    OH.ORDER_ID,
    OH.ORDER_DATE,
    RH.RETURN_DATE,
    OH.PRODUCT_STORE_ID
FROM RETURN_HEADER RH
JOIN RETURN_ITEM RI ON RH.RETURN_ID = RI.RETURN_ID
JOIN ORDER_HEADER OH ON RI.ORDER_ID = OH.ORDER_ID
LEFT JOIN RETURN_ADJUSTMENT RA ON RA.RETURN_ID = RI.RETURN_ID;
```
(cost=2.15 rows=1) (actual time=0.101..0.108 rows=1 loops=1)

---

## Query 27 — Orders with Multiple Returns

Business Problem:
Analyzing orders with multiple returns can identify potential fraud, chronic issues with certain items, or inconsistent shipping processes.

```sql
SELECT DISTINCT
    RI.ORDER_ID,
    RI.RETURN_ID,
    RH.RETURN_DATE,
    RI.RETURN_REASON_ID,
    RI.RETURN_QUANTITY
FROM RETURN_ITEM RI
JOIN (
    SELECT ORDER_ID
    FROM RETURN_ITEM
    GROUP BY ORDER_ID
    HAVING COUNT(DISTINCT RETURN_ID) >= 2
) AS FO ON FO.ORDER_ID = RI.ORDER_ID
JOIN RETURN_HEADER RH ON RH.RETURN_ID = RI.RETURN_ID;
```
(cost=3.91..3.91 rows=1) (actual time=0.167..0.167 rows=0 loops=1)

---

## Query 28 — Store with Most One-Day Shipped Orders (Last Month)

Business Problem:
Identify which facility (store) handled the highest volume of “one-day shipping” orders in the previous month, useful for operational benchmarking

```sql
SELECT
    OIS.FACILITY_ID,
    F.FACILITY_NAME,
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS REPORTING_PERIOD,
    COUNT(OI.ORDER_ID) AS TOTAL_ORDER_ITEM
FROM ORDER_ITEM OI
JOIN ORDER_ITEM_SHIP_GROUP OIS
    ON OIS.ORDER_ID = OI.ORDER_ID
    AND OIS.SHIP_GROUP_SEQ_ID = OI.SHIP_GROUP_SEQ_ID
LEFT JOIN FACILITY F ON OIS.FACILITY_ID = F.FACILITY_ID
JOIN ORDER_STATUS OS
    ON OS.ORDER_ID = OI.ORDER_ID
    AND OS.STATUS_ID = 'ITEM_COMPLETED'
WHERE OIS.SHIPMENT_METHOD_TYPE_ID = 'NEXT_DAY'
  AND F.FACILITY_TYPE_ID NOT IN (
      SELECT FACILITY_TYPE_ID
      FROM FACILITY_TYPE
      WHERE PARENT_TYPE_ID = 'VIRTUAL_FACILITY'
  )
  AND OI.STATUS_ID = 'ITEM_COMPLETED'
  AND OS.STATUS_DATETIME >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
GROUP BY OIS.FACILITY_ID, F.FACILITY_NAME;
```
(cost=1.71 rows=0.0025) (actual time=0.0278..0.0278 rows=0 loops=1)

---

## Query 29 — List of Warehouse Pickers

Business Problem:
Warehouse managers need a list of employees responsible for picking and packing orders to manage shifts, productivity, and training needs.

```sql
SELECT
    P.PARTY_ID,
    CONCAT(PER.FIRST_NAME, ' ', PER.LAST_NAME) AS NAME,
    P.STATUS_ID,
    FP.FACILITY_ID
FROM PARTY P
LEFT JOIN PERSON PER ON P.PARTY_ID = PER.PARTY_ID
JOIN PARTY_ROLE PR
    ON P.PARTY_ID = PR.PARTY_ID
    AND PR.ROLE_TYPE_ID = 'WAREHOUSE_PICKER'
LEFT JOIN FACILITY_PARTY FP
    ON FP.PARTY_ID = P.PARTY_ID
    AND FP.ROLE_TYPE_ID = 'WAREHOUSE_PICKER';
```
(cost=2.9 rows=1) (actual time=0.0371..0.0371 rows=0 loops=1)

---

## Query 30 — Total Facilities That Sell the Product

Business Problem:
Retailers want to see how many (and which) facilities (stores, warehouses, virtual sites) currently offer a product for sale.

```sql
SELECT
    P.PRODUCT_ID,
    P.INTERNAL_NAME,
    COALESCE(COUNT(DISTINCT PF.FACILITY_ID), 0) AS FACILITY_COUNT
FROM PRODUCT P
JOIN PRODUCT_PRICE PP
    ON PP.PRODUCT_ID = P.PRODUCT_ID
    AND PP.PRODUCT_PRICE_TYPE_ID = 'LIST_PRICE'
JOIN PRODUCT_FACILITY PF ON PF.PRODUCT_ID = P.PRODUCT_ID
GROUP BY PF.PRODUCT_ID;
```
(cost=2.36 rows=2) (actual time=0.0333..0.0333 rows=0 loops=1)

---

## Query 31 — Total Items in Various Virtual Facilities

Business Problem:
Retailers need to study the relation of inventory levels of products to the type of facility it's stored at. Retrieve all inventory levels for products at locations and include the facility type Id. Do not retrieve facilities that are of type Virtual.

```sql
SELECT
    PF.PRODUCT_ID,
    PF.FACILITY_ID,
    F.FACILITY_TYPE_ID,
    II.QUANTITY_ON_HAND_TOTAL AS QOH,
    II.AVAILABLE_TO_PROMISE_TOTAL AS ATP
FROM PRODUCT_FACILITY PF
LEFT JOIN INVENTORY_ITEM II
    ON II.PRODUCT_ID = PF.PRODUCT_ID
    AND II.FACILITY_ID = PF.FACILITY_ID
JOIN FACILITY F ON F.FACILITY_ID = PF.FACILITY_ID
WHERE F.FACILITY_TYPE_ID NOT IN (
    SELECT FACILITY_TYPE_ID
    FROM FACILITY_TYPE
    WHERE PARENT_TYPE_ID = 'VIRTUAL_FACILITY'
);
```
(cost=0.626 rows=2) (actual time=8.55..8.58 rows=2 loops=1)

---

## Query 32 — Transfer Orders Without Inventory Reservation

Business Problem:
When transferring stock between facilities, the system should reserve inventory. If it isn’t reserved, the transfer may fail or oversell.

```sql
SELECT
    OH.ORDER_ID AS TRANSFER_ORDER_ID,
    OH.ORIGIN_FACILITY_ID AS FROM_FACILITY_ID,
    OIS.FACILITY_ID AS TO_FACILITY_ID,
    OI.PRODUCT_ID,
    OI.QUANTITY AS REQUESTED_QUANTITY,
    0 AS RESERVED_QUANTITY,
    DATE(OH.ORDER_DATE) AS TRANSFER_DATE,
    OH.STATUS_ID AS STATUS
FROM ORDER_HEADER OH
JOIN ORDER_ITEM OI ON OI.ORDER_ID = OH.ORDER_ID
JOIN ORDER_ITEM_SHIP_GROUP OIS ON OIS.ORDER_ID = OH.ORDER_ID
LEFT JOIN ORDER_ITEM_SHIP_GRP_INV_RES OTSHIR
    ON OTSHIR.ORDER_ID = OIS.ORDER_ID
    AND OTSHIR.SHIP_GROUP_SEQ_ID = OIS.SHIP_GROUP_SEQ_ID
    AND OTSHIR.ORDER_ITEM_SEQ_ID = OI.ORDER_ITEM_SEQ_ID
WHERE OH.ORDER_TYPE_ID = 'TRANSFER_ORDER'
  AND OTSHIR.RESERVED_DATETIME IS NULL
  AND OH.STATUS_ID = 'ORDER_APPROVED'
ORDER BY OH.ORDER_ID;
```
(cost=0.63 rows=2.13) (actual time=0.341..0.352 rows=1 loops=1)

---

## Query 33 — Orders Without Picklist

Business Problem:
A picklist is necessary for warehouse staff to gather items. Orders missing a picklist might be delayed and need attention.

```sql
SELECT DISTINCT
    OH.ORDER_ID,
    DATE(OH.ORDER_DATE) AS ORDER_DATE,
    OH.STATUS_ID AS ORDER_STATUS,
    OIS.FACILITY_ID,
    DATEDIFF(NOW(), OIS.CREATED_STAMP) AS DURATION_IN_DAYS
FROM ORDER_HEADER OH
JOIN ORDER_ITEM_SHIP_GROUP OIS ON OH.ORDER_ID = OIS.ORDER_ID
LEFT JOIN SHIPMENT S ON OIS.ORDER_ID = S.PRIMARY_ORDER_ID
LEFT JOIN FACILITY F ON F.FACILITY_ID = OIS.FACILITY_ID
WHERE S.SHIPMENT_ID IS NULL
  AND OH.STATUS_ID = 'ORDER_APPROVED'
  AND F.FACILITY_TYPE_ID NOT IN (
      SELECT FACILITY_TYPE_ID
      FROM FACILITY_TYPE
      WHERE PARENT_TYPE_ID = 'VIRTUAL_FACILITY'
  )
ORDER BY DURATION_IN_DAYS DESC;
```
cost=5.82..7.18 rows=2.18) (actual time=0.933..0.933 rows=1 loops=1)
