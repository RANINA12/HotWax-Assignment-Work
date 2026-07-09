```
Order Page
│
├── Search
│   └── Global Product Search
│
├── Filters
│   ├── Ordered Date
│   │   ├── After
│   │   └── Before
│   │
│   └── Promised Date
│       ├── After
│       └── Before
│
└── Order Items
    │
    ├── Select Single Item
    │   │
    │   └── Item Actions (Kebab Menu)
    │       ├── Cancel Item
    │       ├── Add Promise Date
    │       ├── Release
    │       ├── Release to Warehouse
    │       └── Behavior
    │           └── Executes Immediately
    └── Select Multiple Items
        │
        └── Item Actions (Queued)
            ├── Cancel Item(s)
            ├── Add Promise Date
            ├── Release
            ├── Release to Warehouse
            └── Behavior
                ├── User selects one or more Order Items
                ├── Chooses an action from the page toolbar
                ├── Action is added to a processing queue
                └── Background worker executes the queued action(s)

```
