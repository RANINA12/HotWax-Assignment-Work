```
Fulfill Only Flow
│
├── Approve Order
│   └── Required before any action
│
├── Fulfillment
│   └── Process from Fulfillment App
│
├── Order Level Actions
│   │
│   ├── Add Item
│   │   └── Only in Created Status
│   │
│   ├── Cancel Order
│   │
│   └── Close Fulfillment
│       │
│       ├── Enabled after Shipment is Created
│       ├── Used when remaining items should not be fulfilled
│       ├── If multiple shipments exist, closes only the remaining fulfillment
│       └── Results in Item Shipped / Under Shipped status
│
└── Item Level Actions
    │
    ├── Edit Quantity
    │   └── Before Shipment is Shipped
    │
    ├── Remove Item
    │   └── Before Shipment is Shipped
    │
    └── Close Fulfillment
        │
        ├── Can close fulfillment for a specific item
        └── Shipment for that item must be created
```
