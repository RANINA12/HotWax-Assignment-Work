```
Cycle Count App
│
├── Bulk Upload Tab
│   │
│   ├── Upload CSV
│   │
│   ├── Required Fields
│   │   ├── Count Import Name
│   │   ├── Purpose Type
│   │   │   ├── Hard Count
│   │   │   └── Directed Count
│   │   ├── Product SKU
│   │
│   ├── Optional Fields
|   |   |--- Estimated Start Date
|   |   |--- Estimated Completion Date
│   │   └──  External Facility
│   │
│   └── Create Cycle Count
│
├── Assigned Tab
│   │
│   ├── View Assigned Cycle Counts
│   ├── Assign Facility (if not provided in CSV)
│   ├── Search
│   ├── Filter
│   │   ├── Status
│   │   │   ├── Created
│   │   │   └── In Progress
│   │   ├── Type
│   │   │   ├── Hard Count
│   │   │   └── Directed Count
│   │   └── Facility
│   │
│   └── Open Cycle Count
│       └── View Progress & Details
│
├── Pending Review
│   │
│   ├── Search
│   ├── Filter
│   │   ├── Type
│   │   ├── Facility
│   │   └── Compliance
│   │
│   ├── Sort
│   │   ├── Alphabetical
│   │   ├── Variance (Low → High)
│   │   └── Variance (High → Low)
│   │
│   └── Open Cycle Count
│       ├── Accept Count
│       └── Reject Count
│
└── Closed
    │
    ├── View Closed Cycle Counts
    ├── Export
    ├── Search
    ├── Filter
    │   ├── Status
    │   ├── Type
    │   ├── Facility
    │   ├── Created After / Before
    │   └── Completed After / Before
    │
    └── Open Cycle Count
        └── Review Previous Progress & Counts
```
