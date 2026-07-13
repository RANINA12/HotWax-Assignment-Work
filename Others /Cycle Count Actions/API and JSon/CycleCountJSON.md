```
  {
    "_entity": "WorkEffort",
    "workEffortId": "CC-001",
    "workEffortTypeId": "CYCLE_COUNT_RUN",
    "statusId": "CYCLE_CNT_CREATED",
    "workEffortName": "Manual Count CC-001"
  }
  
```
  
```
  {
   "_entity" : "InventoryCountImport",
   "inventoryCountImportId" :"ICM-001",
   "workEffortId":"CC-001",
   "StatusId":"SESSION_CREATED",
   "UPLOADED_BY_USER_LOGIN":"123"
  }
```
  
```
  {
  "_entity" : "WorkEffort",
  "workEffortId":"CC-001",
  "statusId" :"CYCLE_CNT_IN_PRGS",
  "ActualStartDate" : ""
  }
```
  
```
  {
  "_entity" : "InventoryCountImport",
  "InventoryCountImportId" :"ICM-001",
  "StatusId" :"SESSION_ASSIGNED" 
  }
```
  
```
{
 "_entity" : "InventoryCountImportLock",
 "inventoryCountImportId" : "ICM-001",
 "fromDate" : 1783741182073,
 "userId" : "123",
 "deviceId" : "NikunjDevice"
}
```

```
{
 "_entity" : "InventoryCountImportItem",
 "inventoryCountImportId": "ICM-001",
 "importItemSeqId" : "0001",
 "quantity": 5,
 "productId" : "P1000",
 "isRequested" : "Y",
 "systemQuantityOnHand": 25
}

```

```
 {
 "_entity" : "InventoryCountImportLock" ,
 "inventoryCountImportId" : "ICM-001" ,
 "thruDate" : "1783741182073"
 }
```
 
```
 {
 "_entity" : "InventoryCountImport"
"InventoryItemCountId" : "ICM-001"
"StatusId" : "SESSION_APPROVED"
 }
```
```
 {
 "_entity" : "InventoryCountImport"
"InventoryItemCountId" : "ICM-001"
"StatusId" : "SESSION_SUBMITED"
 }
```
```
 {
 "_entity" : "WorkEffort",
 "WorkEfortId" : "CC-001" ,
 "StatusId" : "CYCLE_CNT_CMPLTD"
 }
```
 
// Data creation if Accept  and Variance Found
```
 {
 "_entity" : "PhysicalInventory" ,
 "PhysicalInventoryId" : "PI100",
 "PhysicalInventoryDate" : 1783741182074 ,
 "PartyId" :"123"
 }
 ```
 ```
 {
"_entity" : "InventoryItemVariance" ,
"inventoryItemId" : "I1000",
"physicalInventoryId" : "PI100",
"QuantityOnHandVar" : -20,
"AvailableToPromiseVar" : -20,
"ReasonEnumId":"CYCLE_COUNT"
 }
 ```
 
 ```
 {
 "_entity" : "InventoryItemDetail" ,
 "inventoryItemId" :"I1000",
 "inventoryItemSeqId" :"0003",
 "AvailableToPromiseDiff" :-20,
 "QuantityOnHandDiff" : -20 ,
 "PhysicalInventoryId" : "PI100",
 "ReasonEnumId" : "CYCLE_COUNT" 
 }
 ```
 ```
 {
 "_entity" :"InventoryVarDcsnRsn" ,
"workEffortId" : "CC-001" ,
"productId"  :"P1000",
"facilityId" :"MAPLEWOOD" ,
"CountedQuantity" : 5 ,
"SystemQuantity" : 25 ,
"VarianceQuantity": -20,
"DecisionEnumReasonId" : "PARTIAL_SCOPE_POST",
"DecisionOutcomeReasonId" : "APPLIED",
"inventoryItemId" : "I1000" ,
"physicalInventoryId" : "PI100",
"DecidedDatetime" : 1783741182075,
"DecidedByUserLohginId" : "123"
 }

 ```
 
 ```
 //Data creation if Accept and No Variance Found
 {
 "_entity" :"InventoryVarDcsnRsn" ,
"WorkEfforID" :"CC-001" ,
"facilityId" : "MAPLEWOOD" ,
"productId"  :"P1000",
"CountedQuantity" : "5" ,
"SystemQuantity" :"25" ,
"VarianceQuantity" : "-20" ,
"DecisionEnumReasonId" : "APPLIED" ,
"DecisionOutcomeReasonId" : "PARTIAL_SCOPE_POST" ,
"InventoryItemId: "I1000" ,
"PhysicalInventoryId" : "PI100" ,
"DecidedDatetime" : "" ,
"DecidedByUserLohginId" : "123"
 
 }
 ```
 
 ```
 //Data creation if Reject , Variance found or Not Found No matter 
 {
 "_entity" :"InventoryVarDcsnRsn" ,
"WorkEfforID" :"CC-001" ,
"ProductId"  :"P1000",
"FacilityId" : "MAPLEWOOD"
"CountedQuantity" : "5" ,
"SystemQuantity" :"25" ,
"VarianceQuantity" : "-20" ,
"DecisionReasonEnumId" : "PARTIAL_SCOPE_POST",
"DecisionOutcomeEnumId" : "SKIPPED" ,
"InventoryItemId: :"I1000" ,
"PhysicalInventoryId" : "PI100" ,
"DecidedDatetime" : "" ,
"DecidedByUserLohginId" : "123"
 }
 ```
 
 ```
{
"_entity" : "WorkEffort",
"WorkEffortID": "CC-001",
"StatusId" : "CYCLE_CNT_CLOSED"
}
