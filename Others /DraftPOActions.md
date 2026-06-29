# Order Level Actions

```
OrderAction(orderId, actionName)
│
├── OrderApprove
│   ├── Preconditions
│   │   └── Order Status = Created
│   │
│   ├── Action
│   │   ├── Mark Order as Approved
│   │   └── Mark all Order Items as Approved
│   │
│   └── Result
│       └── Entire PO moves to Approved state
│
├── OrderCancel
│   ├── Preconditions
│   |__ShipmentRecepit is not created against that Order
│   └── Order is not Completed
│   │
│   ├── Action
│   │   ├── Mark Order as Cancelled
│   │   └── Mark all active Order Items as Cancelled
│   │
│   └── Result
│       └── No further actions allowed on the PO
│
├── OrderItemAdd      
│   │
│   ├── Preconditions
│   │   ├── Order Status != Completed
│   │   └── Order Status != Cancelled
│   │
│   ├── Action
│   │   └── Create a new Order Item under the Order
│   │
│   └── Result
│       └── New item is added to the existing PO
│
├── ReceiveAll
│   │
│   ├── Preconditions
│   │   ├── Order Status = Approved && !Created 
│   │   └── All items are expected to be fully received
│   │
│   ├── Action
│   │   ├── Set Quantity Accepted = Ordered Quantity
│   │   ├── Set Rejected Quantity = 0
│   │   ├── Set Missing Quantity = 0
│   │   └── Mark every Order Item as Received
│   │
│   └── Result
│       └── If all items are received, Order becomes Complete
│
└── CompleteOrder
    ├── Preconditions
    │   └── All Order Items are in  state
    │
    ├── Action
    │   └── Mark Order as Completed
    │
    └── Result
        └── PO becomes read-only and no further actions are allowed
```
