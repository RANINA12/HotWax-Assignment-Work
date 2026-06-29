# Order Item Level Actions

```text
OrderItemAction(orderId, orderItemSeqId[], actionName)
│
├── OrderItemEdit
│   │
│   ├── Edit Quantity
│   │   ├── Preconditions
│   │   │   ├── No ShipmentReceipt exists
│   │   │   ├── Order Item Status != Cancelled
│   │   │   ├── Order Item Status != Completed
│   │   │
│   │   └── Action
│   │       └── Update Ordered Quantity
│   │
│   ├── Edit Unit Price
│   │   ├── Preconditions
│   │   │   ├── No ShipmentReceipt exists
│   │   │   ├── Order Item Status != Cancelled
│   │   │   ├── Order Item Status != Completed
│   │   │
│   │   └── Action
│   │       └── Update Unit Price
│   │
│   └── Edit Arrival Date
│       ├── Preconditions
│       │   ├── No ShipmentReceipt exists
│       │   ├── Order Item Status != Cancelled
│       │   ├── Order Item Status != Completed
│       │
│       └── Action
│           └── Update Arrival Date
│
├── OrderItemCancel
│   ├── Preconditions
│   │   ├── Order Item Status = Created OR Approved
│   │   └── No ShipmentReceipt exists
│   │
│   └── Action
│       └── Mark Order Item as Cancelled
│
├── OrderItemCancelQuantity
│   │
│   ├── Preconditions
│   │   ├── Order Item Status != Cancelled
│   │   ├── Order Item Status != Completed
│   │
│   └── Action
│       └── Update Cancelled Quantity
│
├── OrderItemReceived
│   ├── Preconditions
│   │   ├── Order Item Status = Approved
│   │   ├── Quantity Accepted entered
│   │   ├── Quantity Rejected entered
│   │   └── Quantity Missing entered
│   │
│   ├── Validation
│   │   └── Accepted + Rejected + Missing = Ordered Quantity
│   │
│   └── Action
│       └── Mark Order Item as Received
│
└── OrderItemCompleted
    ├── Preconditions
    │   └── ShipmentReceipt exists
    │
    └── Action
        └── Mark Order Item as Completed
```
