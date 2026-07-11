## Transfer Order APIs

---

## 1. Create Transfer Order

**POST** `rest/s1/oms/transferOrders`

### Payload

```json
{
  "currencyUom": "USD",
  "customerId": "COMPANY",
  "entryDate": "2026-07-10 23:39:42.072",
  "grandTotal": 0,
  "orderDate": "2026-07-10 23:39:42.072",
  "orderName": "to#6",
  "orderTypeId": "TRANSFER_ORDER",
  "org.apache.ofbiz.order.order.OrderStatus": {
    "statusId": "ORDER_CREATED",
    "statusDatetime": 1783741182073,
    "statusUserLogin": "nikunj.bisani"
  },
  "originFacilityId": "MAPLEWOOD",
  "productStoreId": "STORE",
  "statusFlowId": "TO_Fulfill_And_Receive",
  "statusId": "ORDER_CREATED",
  "shipGroups": [
    {
      "shipGroupSeqId": "00001",
      "facilityId": "MAPLEWOOD",
      "orderFacilityId": "Austin",
      "carrierPartyId": "USPS",
      "estimatedDeliveryDate": "",
      "estimatedShipDate": "",
      "shipmentMethodTypeId": "NEXT_DAY",
      "shipFrom": {
        "postalAddress": {
          "id": "10051"
        }
      },
      "shipTo": {
        "postalAddress": {
          "id": "10011"
        }
      },
      "items": [
        {
          "orderItemTypeId": "PRODUCT_ORDER_ITEM",
          "productId": "10013",
          "sku": "0231-0026012",
          "quantity": 25,
          "statusId": "ITEM_CREATED",
          "unitPrice": 0
        }
      ]
    }
  ]
}
```

---

## 2. Approve Transfer Order

**POST** `rest/s1/oms/transferOrders/${orderId}/approve`

**Payload:** None

**Response:** None

---

# User Actions

## 1. Cancel Transfer Order

**POST** `rest/s1/oms/transferOrder/${orderId}/cancel`

**Payload:** None

**Response:** None

---

## 2. Edit Item Quantity

**PUT** `rest/s1/oms/transferOrder/orderItem`

### Payload

```json
{
  "orderId": "M102731",
  "orderItemSeqId": "01",
  "quantity": 50,
  "unitPrice": 0
}
```

### Response

```json
{}
```

---

## 3. Add Item

**POST** `rest/s1/oms/transferOrder/orderItem`

### Payload

```json
{
  "orderId": "M102731",
  "productId": "M103633",
  "quantity": 25,
  "shipGroupSeqId": "00001",
  "unitPrice": 0,
  "orderItemTypeId": "PRODUCT_ORDER_ITEM"
}
```

### Response

```json
{
  "orderId": "M102731",
  "orderItemSeqId": "02"
}
```

---

## 4. Remove Item (Order in Created Status)

**PUT** `rest/s1/oms/transferOrder/${orderId}/items/${orderItemSeqId}/status`

Only updates the item status using Order Services.

---

## 5. Remove Item (Order in Approved Status)

Calls **closeFulfillment**.

### Payload

```json
{
  "orderId": "M100224",
  "items": [
    {
      "orderItemSeqId": "01"
    }
  ]
}
```

---

# Shipment Flow

## 1. Create Shipment

**POST** `rest/s1/poorti/transfershipments`

### Payload

```json
{
  "payload": {
    "orderId": "M102721",
    "packages": [
      {
        "items": [
          {
            "orderItemSeqId": "01",
            "productId": "M103588",
            "quantity": 20,
            "shipGroupSeqId": "00001"
          }
        ]
      }
    ]
  }
}
```

---

## 2. Ship Shipment

**POST** `rest/s1/poorti/transfershipments/${orderId}/ship`

### Payload

```json
{
  "carrierPartyId": "USPS",
  "shipmentId": "M100518",
  "shipmentMethodTypeId": "NEXT_DAY",
  "shipmentRouteSegmentId": "01",
  "trackingIdNumber": "1234"
}
```

---

# Receiving Flow

## 1. Save & Progress Receipt

**POST** `rest/s1/poorti/transferOrder/${orderId}/receipts`

### Payload

```json
{
  "facilityId": "MAPLEWOOD",
  "receivedDateTime": 1783766498665,
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "M103633",
      "quantityAccepted": "5",
      "statusId": "ITEM_PENDING_RECEIPT"
    }
  ]
}
```

---

## 2. Complete Receipt

**POST** `rest/s1/transferOrders/${orderId}/receipts`

### Payload

```json
{
  "facilityId": "MAPLEWOOD",
  "receivedDateTime": 1783766498665,
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "M103633",
      "quantityAccepted": "5",
      "statusId": "ITEM_COMPLETED"
    }
  ]
}
```

