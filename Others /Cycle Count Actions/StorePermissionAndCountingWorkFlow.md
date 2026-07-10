## Counting and permission Workflow 

### Permissions

```
Store Permissions
│
├── Inventory Count Permissions
│   ├── Access Inventory Count
│   ├── View Quantity On Hand
│   ├── Preview Count
│   ├── Start Count
│   ├── Submit Cycle Count for Review
│   ├── Force Release
│   ├── Log Inventory Variance
│   └── Inventory Count Admin
│
├── Store View
│   └── Navigate to Tabs / Count
│
└── Count Setup
    │
    ├── Create Session
    │   └── Multiple sessions allow different users to count different locations
    │
    ├── Start Count
    │
    └── Preview Count
        ├── Counted Products
        ├── Remaining Products
        └── Estimate Counting Workload
```

### Counting WorkFlow

```
Counting Workflow
│
├── Navigate to Tabs / Count
│
├── Create Session
│   └── Multiple users can count different locations simultaneously
│
├── Start Count
│
├── Preview Count
│   ├── Counted Products
│   ├── Remaining Products
│   └── Displays current counting progress
│
├── Count Inventory
│   │
│   ├── Scan Product
│   │   │
│   │   ├── UNCOUNTED
│   │   │   └── Expected product that has not yet been counted
│   │   │
│   │   ├── UNDIRECTED
│   │   │   └── Product exists but is not part of the directed count
│   │   │
│   │   ├── UNMATCHED
│   │   │   └── SKU not found and requires resolution
│   │   │
│   │   └── COUNTED
│   │       └── Product successfully counted
│   │
│   └── Hand Count
│       ├── Enter SKU
│       └── Enter Quantity
│
├── Session Lifecycle
│   │
│   ├── Submit Session
│   │
│   ├── Reopen Session
│   │   └── Continue counting or make corrections
│   │
│   └── Submit Session
│
└── Submit Count for Review
    │
    ├── Required Conditions
    │   ├── Appropriate user permission
    │   ├── Count status is In Progress
    │   ├── All sessions are submitted
    │   └── All requested items are counted
    │
    └── Move to Pending Review
    
 ```
 
 ### variance Workflow
 
 ```
Variance Workflow
│
├── Navigate to Tabs / Variance
│
├── Log Variance
│   └── Select Variance Reason
│
├── Update Inventory
│   │
│   ├── Scanner
│   │   └── Scan Product
│   │
│   └── Manual Entry
│       ├── Enter SKU
│       └── Enter Quantity
│
└── Inventory Adjustment
    ├── Add Inventory
    └── Remove Inventory
```
