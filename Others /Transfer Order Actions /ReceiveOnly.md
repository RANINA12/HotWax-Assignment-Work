```
Receive Only Flow
│
├── Approve Order
│   ├── Required before any action
│   └── Applicable when
│       └── RECEIVE_BY_FULFILL = false
│
├── Receiving
│   ├── Receive from Receiving App
│   └── Open TO Detail Page
│
├── Order Level Actions
│   │
│   ├── Receive Bulk
│   │   ├── Remaining Ordered Quantity
│   │   └── Close Item with 0 Receipt
│   │
│   ├── Cancel Order
│   │
│   └── Add Item
│       └── Only before Order is Approved
│
└── Item Level Actions
    │
    ├── Edit Quantity
    │   └── Before Receiving
    │
    └── Remove Item
        └── Before Receiving
```
