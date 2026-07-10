```
Fulfill & Receive Flow
│
├── Approve Order
│   └── Required before any action
│
├── Fulfillment
│   └── Process from Fulfillment App 
│
├── Receiving
│   ├── Receive in Bulk
│   │   ├── Remaining Shipped Quantity
│   │   ├── Remaining Ordered Quantity
│   │   └── Close Item with 0 Receipt
│   │
│   └── Receive from Receiving App
│
├── Order Level Actions
│   │
│   ├── Add Item
│   │   └── Only in Created Status
│   │
│   ├── Cancel Order
│   │   └── Allowed until no item reaches Pending Receipt
│   │
│   ├── Close Fulfillment
│   │   └── Same behavior as Fulfill Only Flow
│   │
│   └── Receive Bulk
│       └── Shows warning if 0 items are available for receipt
│
└── Item Level Actions
    │
    ├── Edit Quantity
    │
    ├── Remove Item
    │
    └── Close Fulfillment
        └── Same behavior as Fulfill Only Flow
```
