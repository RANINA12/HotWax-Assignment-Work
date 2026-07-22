System Message type  that consume the CSV after import 
sendServiceName :
Consume#InventoryCountImportCSv
 
 
 1. Preview Cycle Count (GET Requests)

When previewing the count, these four requests are fired to fetch the cycle count details, sessions, and review counts:

```http
GET /rest/s1/inventory-cycle-count/cycleCounts/workEfforts/M100109
GET /rest/s1/inventory-cycle-count/cycleCounts/workEfforts/M100109/sessions?workEffortId=M100109
GET /rest/s1/inventory-cycle-count/cycleCounts/workEfforts/M100109/reviews/count?workEffortId=M100109
GET /rest/s1/inventory-cycle-count/cycleCounts/workEfforts/M100109/reviews?workEffortId=M100109

```
## 2. Start Counting Sequence

### Step 1: Update the WorkEffort

Marks the cycle count as in progress.

```json
{
  "workEffortId": "M100109",
  "actualStartDate": 1783768379001,
  "statusId": "CYCLE_CNT_IN_PRGS"
}

```

### Step 2: Update InventoryCountImport (Assign Session)
```json
{
  "inventoryCountImportId": "M100113",
  "statusId": "SESSION_ASSIGNED"
}

```

### Step 3: Count and Resolve

Scans the items and resolves undirected/unmatched counts.

* **Endpoint:** `PUT /rest/s1/inventory-cycle-count/cycleCounts/sessions/M100113/items`

```json
{
  "items": [
    {
      "uuid": "01980edb-2631-47b5-a3a8-10cfee6b390a",
      "productId": "M101761",
      "productIdentifier": "MH03-S-Black",
      "countedByUserLoginId": "nikunj.bisani",
      "createdDate": 1783768956285,
      "isRequested": "Y",
      "lastScanAt": 1783768956285,
      "lastUpdatedAt": 1783769099188,
      "quantity": 1,
      "systemQuantityOnHand": 0
    }
  ]
}

```

---

## 3. Submit Session

Marks the individual counting session as submitted.

* **Endpoint:** `PUT /rest/s1/inventory-cycle-count/cycleCounts/sessions/M100113`

```json
{
  "inventoryCountImportId": "M100113",
  "statusId": "SESSION_SUBMITTED"
}

```

---

## 4. Release Lock

Releases the user's lock on the counting session.

* **Endpoint:** `PUT /rest/s1/inventory-cycle-count/cycleCounts/sessions/M100113/release`

```json
{
  "inventoryCountImportId": "M100113",
  "userId": "nikunj.bisani",
  "fromDate": 1783768379927,
  "thruDate": 1783769201299
}

```

---

## 5. Complete Cycle Count

Updates the parent WorkEffort to mark the entire cycle count as complete.

* **Endpoint:** `PUT /rest/s1/inventory-cycle-count/cycleCounts/workEfforts/M100109`

```json
{
  "workEffortId": "M100109",
  "statusId": "CYCLE_CNT_CMPLTD"
}

```

---

## 6. Accept / Apply Variances

If the count is accepted, this applies the variances to the inventory.

* **Endpoint:** `POST /rest/s1/inventory-cycle-count/cycleCounts/submit` *(assuming POST/PUT based on the action)*

```json
{
  "inventoryCountProductsList": [
    {
      "workEffortId": "M100109",
      "productId": "M101761",
      "facilityId": "Austin",
      "systemQuantity": 0,
      "countedQuantity": 1,
      "varianceQuantity": 1,
      "decisionOutcomeEnumId": "APPLIED",
      "decisionReasonEnumId": "PARTIAL_SCOPE_POST"
    }
  ]
}

```
