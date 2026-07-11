```
  {
    "_entity": "OrderHeader",
    "orderId": "M0112",
    "currencyUom": "USD",
    "customerId": "COMPANY",
    "entryDate": "2026-07-10 23:39:42.072",
    "grandTotal": 0,
    "orderDate": "2026-07-10 23:39:42.072",
    "orderName": "to#6",
    "orderTypeId": "TRANSFER_ORDER",
    "originFacilityId": "MAPLEWOOD",
    "productStoreId": "STORE",
    "statusFlowId": "TO_Fulfill_And_Receive",
    "statusId": "ORDER_CREATED"
  }
  
 ```
 
 ```
  {
    "_entity": "OrderItemShipGroup",
    "orderId": "M0112",
    "shipGroupSeqId": "00001",
    "facilityId": "MAPLEWOOD",
    "orderFacilityId": "Austin",
    "carrierPartyId": "USPS",
    "shipmentMethodTypeId": "NEXT_DAY"
  }
  
  ```
  
  ```
  
  {
    "_entity": "OrderItem",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "orderItemTypeId": "PRODUCT_ORDER_ITEM",
    "productId": "P1000",
    "sku": "0231-0026012",
    "quantity": 25,
    "statusId": "ITEM_CREATED",
    "unitPrice": 0
  }
  
  ```
  
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "statusId": "ORDER_CREATED",
    "statusDatetime": 1783741182073,
    "statusUserLogin": "nikunj.bisani"
  }
  
  ```
  
  ```
  
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_CREATED",
    "statusDatetime": 1783741182073,
    "statusUserLogin": "nikunj.bisani"
  }
  
  ```
  
  ```
  
  {
    "_entity": "OrderHeader",
    "orderId": "M0112",
    "statusId": "ORDER_APPROVED"
  }
  
  ```
  
  ```
  {
    "_entity": "OrderItem",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_PENDING_FULFILL"
  }  
  
  ```
  
  ```
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "statusId": "ORDER_APPROVED",
    "statusDatetime": 1783741183000,
    "statusUserLogin": "nikunj.bisani"
  }
  
    ```
  
  ```
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_PENDING_FULFILL",
    "statusDatetime": 1783741183000,
    "statusUserLogin": "nikunj.bisani"
  }
  
    ```
  
  ```
  
  {
    "_entity": "OrderItemShipGrpInvRes",
    "orderId": "M0112",
    "shipGroupSeqId": "00001",
    "orderItemSeqId": "00001",
    "inventoryItemId": "I1000",
    "quantity": 25,
    "reservedDatetime": 1783741184000
  }
  
    ```
  
  ```
  
  {
    "_entity": "InventoryItemDetail",
    "inventoryItemId": "I1000",
    "inventoryItemDetailSeqId": "0001",
    "availableToPromiseDiff": -25,
    "orderId": "M0112",
    "orderItemSeqId": "00001"
  }
  
    ```
  
  ```
  
  {
    "_entity": "Shipment",
    "shipmentId": "S1000",
    "shipmentTypeId": "TRANSFER",
    "statusId": "SHIPMENT_PACKED",
    "primaryOrderId": "M0112",
    "primaryShipGroupSeqId": "00001",
    "estimatedShipDate": 1783741185000,
    "estimatedArrivalDate": 1783741190000,
    "originFacilityId": "MAPLEWOOD",
    "destinationFacilityId": "Austin",
    "originContactMechId": "10051",
    "destinationContactMechId": "10011"
  }
  
    ```
  
  ```
  
  {
    "_entity": "ShipmentItem",
    "shipmentId": "S1000",
    "shipmentItemSeqId": "00001",
    "productId": "P1000",
    "quantity": 25
  }
  
    ```
  
  ```
  
  {
    "_entity": "ShipmentPackage",
    "shipmentId": "S1000",
    "shipmentPackageSeqId": "00001",
    "shipmentBoxTypeId": "STANDARD_BOX",
    "dateCreated": 1783741186000,
    "boxLength": 12,
    "boxHeight": 12,
    "boxWidth": 12,
    "dimensionUomId": "LEN_in",
    "weight": 5,
    "weightUomId": "WT_lb"
  }
  
    ```
  
  ```
  {
    "_entity": "ShipmentPackageRouteSeg",
    "shipmentId": "S1000",
    "shipmentPackageSeqId": "00001",
    "shipmentRouteSegmentId": "00001",
    "trackingId": "1233456"
  }
  
    ```
  
  ```
  
  {
    "_entity": "ShipmentRouteSegment",
    "shipmentId": "S1000",
    "shipmentRouteSegmentId": "00001",
    "originFacilityId": "MAPLEWOOD",
    "destFacilityId": "Austin",
    "originContactMechId": "10051",
    "destContactMechId": "10011",
    "carrierPartyId": "USPS",
    "shipmentMethodTypeId": "NEXT_DAY",
    "carrierServiceStatusId": "SHRSCS_ACCEPTED",
    "trackingId": "1233456"
  }
    ```
  
  ```
  {
    "_entity": "Shipment",
    "shipmentId": "S1000",
    "statusId": "SHIPMENT_SHIPPED"
  }
    ```
  
  ```
  {
    "_entity": "OrderItem",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_PENDING_RECEIPT"
  }
  
 ```
  
  ```
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_PENDING_RECEIPT",
    "statusDatetime": 1783741188000
  }
    ```
  
  ```
  {
    "_entity": "InventoryItemDetail",
    "inventoryItemId": "I1000",
    "inventoryItemDetailSeqId": "0002",
    "quantityOnHandDiff": -25,
    "orderId": "M0112",
    "orderItemSeqId": "00001"
  }
    ```
  
  ```
  {
    "_entity": "ItemIssuance",
    "itemIssuanceId": "ISSUE_001",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "shipGroupSeqId": "00001",
    "inventoryItemId": "I1000",
    "shipmentId": "S1000",
    "shipmentItemSeqId": "00001",
    "issuedDateTime": 1783741190000
  }
  
    ```
  
  ```
  
  {
    "_entity": "ShipmentReceipt",
    "receiptId": "REC_001",
    "inventoryItemId": "I1000",
    "productId": "P1000",
    "shipmentId": "S1000",
    "shipmentItemSeqId": "00001",
    "shipmentPackageSeqId": "00001",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "datetimeReceived": 1783741191000,
    "itemDescription": "Transfer Fulfillment",
    "quantityAccepted": 25,
    "quantityRejected": 0
  }
  
    ```
  
  ```
  
  {
    "_entity": "OrderItem",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_COMPLETED"
  }
  
    ```
  
  ```
  
  {
    "_entity": "OrderHeader",
    "orderId": "M0112",
    "statusId": "ORDER_COMPLETED"
  }
  
    ```
  
  ```
  
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "statusId": "ORDER_COMPLETED",
    "statusDatetime": 1783741192000
  }
  
    ```
  
  ```
  
  {
    "_entity": "OrderStatus",
    "orderId": "M0112",
    "orderItemSeqId": "00001",
    "statusId": "ITEM_COMPLETED",
    "statusDatetime": 1783741192000
  }
  ```
 
