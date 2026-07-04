## Query 12 — Shipping Addresses for October 2023 Orders

Business Problem:
Customer Service might need to verify addresses for orders placed or completed in October 2023. This helps ensure shipments are delivered correctly and prevents address-related issues.

```sql
SELECT
    OH.ORDER_ID,
    P.PARTY_ID,
    P.FIRST_NAME,
    P.LAST_NAME,
    PA.ADDRESS1,
    PA.CITY,
    PA.STATE_PROVINCE_GEO_ID,
    PA.COUNTRY_GEO_ID,
    OH.STATUS_ID,
    OH.ORDER_DATE
FROM ORDER_HEADER OH
JOIN ORDER_ROLE ORR
    ON OH.ORDER_ID = ORR.ORDER_ID
    AND ORR.ROLE_TYPE_ID = 'SHIP_TO_CUSTOMER'
JOIN ORDER_CONTACT_MECH OCM
    ON OH.ORDER_ID = OCM.ORDER_ID
    AND OCM.CONTACT_MECH_PURPOSE_TYPE_ID = 'SHIPPING_LOCATION'
JOIN POSTAL_ADDRESS PA ON PA.CONTACT_MECH_ID = OCM.CONTACT_MECH_ID
LEFT JOIN PERSON P ON P.PARTY_ID = ORR.PARTY_ID
WHERE (
    OH.ORDER_DATE >= '2023-10-01'
    AND OH.ORDER_DATE < '2023-11-01'
)
```
(cost=16.2 rows=3) (actual time=0.0899..0.0899 rows=0 loops=1)

---

## Query 13 — Orders from New York

Business Problem:
Companies often want region-specific analysis to plan local marketing, staffing, or promotions in certain areas—here, specifically, New York.

```sql
SELECT
    OH.ORDER_ID,
    P.FIRST_NAME,
    P.LAST_NAME,
    OH.GRAND_TOTAL,
    PA.ADDRESS1,
    PA.CITY,
    PA.STATE_PROVINCE_GEO_ID,
    PA.COUNTRY_GEO_ID,
    OH.STATUS_ID,
    OH.ORDER_DATE
FROM ORDER_HEADER OH
JOIN ORDER_ROLE ORR
    ON OH.ORDER_ID = ORR.ORDER_ID
    AND ORR.ROLE_TYPE_ID = 'SHIP_TO_CUSTOMER'
JOIN ORDER_CONTACT_MECH OCM
    ON OH.ORDER_ID = OCM.ORDER_ID
    AND OCM.CONTACT_MECH_PURPOSE_TYPE_ID = 'SHIPPING_LOCATION'
JOIN POSTAL_ADDRESS PA ON PA.CONTACT_MECH_ID = OCM.CONTACT_MECH_ID
JOIN PERSON P ON P.PARTY_ID = ORR.PARTY_ID
WHERE OH.STATUS_ID = 'ORDER_COMPLETED'
  AND PA.STATE_PROVINCE_GEO_ID = 'NY';
```
(cost=1.57 rows=0.784) (actual time=0.0826..0.0826 rows=0 loops=1)

---

## Query 14 — Top-Selling Product in New York

Business Problem:
Merchandising teams need to identify the best-selling product(s) in a specific region (New York) for targeted restocking or promotions.

```sql
WITH product_sales AS (
    SELECT
        OI.PRODUCT_ID,
        PA.CITY,
        P.INTERNAL_NAME,
        PA.STATE_PROVINCE_GEO_ID,
        SUM(OI.QUANTITY) AS quantity,
        SUM(OI.QUANTITY * OI.UNIT_PRICE) AS revenue
    FROM ORDER_HEADER OH
    JOIN ORDER_ITEM OI ON OH.ORDER_ID = OI.ORDER_ID
    JOIN PRODUCT P ON P.PRODUCT_ID = OI.PRODUCT_ID
    JOIN ORDER_ROLE ORR
        ON OH.ORDER_ID = ORR.ORDER_ID
        AND ORR.ROLE_TYPE_ID = 'SHIP_TO_CUSTOMER'
    LEFT JOIN ORDER_CONTACT_MECH OCM
        ON OH.ORDER_ID = OCM.ORDER_ID
        AND OCM.CONTACT_MECH_PURPOSE_TYPE_ID = 'SHIPPING_LOCATION'
    LEFT JOIN POSTAL_ADDRESS PA ON PA.CONTACT_MECH_ID = OCM.CONTACT_MECH_ID
    WHERE PA.STATE_PROVINCE_GEO_ID = 'NY'
    GROUP BY OI.PRODUCT_ID, PA.CITY, PA.STATE_PROVINCE_GEO_ID
)
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CITY
               ORDER BY quantity DESC
           ) AS rn
    FROM product_sales
) t
WHERE rn = 1;

```
(cost=0.35..0.35 rows=1) (actual time=1.41..1.41 rows=3 loops=1)

---

## Query 15 — Store-Specific (Facility-Wise) Revenue

Business Problem:
Different physical or online stores (facilities) may have varying levels of performance. The business wants to compare revenue across facilities for sales planning and budgeting.

```sql
SELECT
    F.FACILITY_ID,
    F.FACILITY_NAME,
    COUNT(DISTINCT OI.ORDER_ID) AS TOTAL_ORDERS,
    SUM(OI.QUANTITY * OI.UNIT_PRICE) AS TOTAL_REVENUE,
    CONCAT(
        MIN(DATE(OI.CREATED_STAMP)),
        ' - ',
        MAX(DATE(OI.CREATED_STAMP))
    ) AS DATE_RANGE
FROM ORDER_ITEM OI
JOIN PRODUCT_FACILITY PF ON PF.PRODUCT_ID = OI.PRODUCT_ID
JOIN FACILITY F ON F.FACILITY_ID = PF.FACILITY_ID
GROUP BY PF.FACILITY_ID;
```
(cost=7.76 rows=6.07) (actual time=2.83..2.89 rows=4 loops=1)
---

## Query 16 — Lost and Damaged Inventory

Business Problem:
Warehouse managers need to track “shrinkage” such as lost or damaged inventory to reconcile physical vs. system counts.

```sql
SELECT
    II.PRODUCT_ID,
    II.FACILITY_ID,
    SUM(IID.QUANTITY_ON_HAND_DIFF),
    IID.REASON_ENUM_ID
FROM INVENTORY_ITEM_DETAIL IID
JOIN INVENTORY_ITEM II ON II.INVENTORY_ITEM_ID = IID.INVENTORY_ITEM_ID
GROUP BY IID.INVENTORY_ITEM_ID, IID.REASON_ENUM_ID
HAVING IID.Reason_Enum_Id = "VAR_DAMAGED"
    OR IID.REASON_ENUM_ID = "VAR_LOST";
```
(cost=2.7 rows=6) (actual time=15.2..15.2 rows=6 loops=1)
---

## Query 17 — Low Stock or Out of Stock Items Report

Business Problem: Avoiding out-of-stock situations is critical. This report flags items that have fallen below a certain reorder threshold or have zero available stock.

```sql
SELECT
    PF.PRODUCT_ID,
    P.PRODUCT_NAME,
    PF.FACILITY_ID,
    COALESCE(II.QUANTITY_ON_HAND_TOTAL, 0) AS QOH,
    COALESCE(II.AVAILABLE_TO_PROMISE, 0) AS ATP,
    COALESCE(PF.MINIMUM_STOCK, 0) AS REORDER_THRESHOLD,
    CURRENT_TIMESTAMP AS DATE_CHECKED
FROM PRODUCT_FACILITY PF
JOIN PRODUCT P 
    ON PF.PRODUCT_ID = P.PRODUCT_ID
JOIN INVENTORY_ITEM II
    ON II.PRODUCT_ID = PF.PRODUCT_ID
    AND II.FACILITY_ID = PF.FACILITY_ID
WHERE COALESCE(II.AVAILABLE_TO_PROMISE, 0) < COALESCE(PF.MINIMUM_STOCK, 0)
   OR COALESCE(II.AVAILABLE_TO_PROMISE, 0) <= 0;
```
(cost=1.5 rows=1) (actual time=0.0926..0.0977 rows=1 loops=1)
---

## Query 18 — Retrieve the Current Facility (Physical or Virtual) of Open Orders

Business Problem:
The business wants to know where open orders are currently assigned, whether in a physical store or a virtual facility (e.g., a distribution center or online fulfillment location).

```sql
SELECT DISTINCT
    F.FACILITY_NAME,
    F.FACILITY_TYPE_ID,
    F.FACILITY_ID,
    OH.STATUS_ID AS ORDER_STATUS,
    OH.ORDER_ID
FROM ORDER_HEADER OH
JOIN ORDER_ITEM OI ON OH.ORDER_ID = OI.ORDER_ID
JOIN ORDER_ITEM_SHIP_GROUP OISG
    ON OISG.ORDER_ID = OI.ORDER_ID
    AND OISG.SHIP_GROUP_SEQ_ID = OI.SHIP_GROUP_SEQ_ID
JOIN FACILITY F ON OISG.FACILITY_ID = F.FACILITY_ID
WHERE OH.STATUS_ID <> "ORDER_COMPLETED"
  AND OH.STATUS_ID <> "ORDER_CANCELLED";
```
(cost=35.7..38 rows=9.58) (actual time=1.13..1.14 rows=44 loops=1)
---

## Query 19 — Items Where QOH and ATP Differ

Business Problem:
Sometimes the Quantity on Hand (QOH) doesn’t match the Available to Promise (ATP) due to pending orders, reservations, or data discrepancies. This needs review for accurate fulfillment planning.

```sql
SELECT
    product_id,
    facility_id,
    Quantity_on_Hand_Total,
    Available_to_promise_total,
    Quantity_on_Hand_Total - Available_to_promise_total AS Difference
FROM Inventory_Item;
```
(cost=0.35 rows=1) (actual time=0.0379..0.0435 rows=1 loops=1)
---

## Query 20 — Order Item Current Status Changed Date-Time
Business Problem:
Operations teams need to audit when an order item’s status (e.g., from “Pending” to “Shipped”) was last changed, for shipment tracking or dispute resolution.

```sql
SELECT
    OS1.Order_id,
    OS2.order_item_seq_id,
    OS2.Status_id,
    OS2.STATUS_USER_LOGIN,
    OS2.STATUS_DATETIME
FROM Order_Status OS1
JOIN order_status OS2
    ON OS1.order_id = OS2.order_id
    AND OS1.order_item_seq_id = OS2.order_item_seq_id
WHERE OS1.STATUS_ID = "ITEM_APPROVED"
  AND OS2.STATUS_ID = "ITEM_COMPLETED";
```
(cost=2.2 rows=0.05) (actual time=0.0249..0.0249 rows=0 loops=1)
---

## Query 21 — Total Orders by Sales Channel
Business Problem:
Marketing and sales teams want to see how many orders come from each channel (e.g., web, mobile app, in-store POS, marketplace) to allocate resources effectively.

```sql
SELECT
    SUM(COALESCE(OH.grand_total, 0) - COALESCE(Ad.Adjustments, 0)) AS totalRevenue,
    OH.sales_channel_enum_id,
    COUNT(OH.order_id) AS totalOrder,
    CONCAT(MIN(DATE(OH.Entry_date)), '--', MAX(DATE(OH.Entry_date))) AS PERIOD
FROM ORDER_HEADER OH
LEFT JOIN (
    SELECT
        order_id,
        SUM(Amount) AS Adjustments
    FROM ORDER_ADJUSTMENT
    GROUP BY order_id
) Ad ON Ad.order_id = OH.order_id
WHERE OH.status_id = "Order_completed"
GROUP BY OH.sales_channel_enum_id;
```
(cost=2.25 rows=14) (actual time=0.434..0.436 rows=1 loops=1)
---
