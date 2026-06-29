# Experiment Report: Empirical Testing of Moqui's Entity Iterator Memory Behavior on MySQL

**Date:** June 26, 2026  
**Context:** Verification of read-path safety for the sim-routing cross-database sync engine.  
**Objective:** To empirically test whether Moqui's Entity Engine iterator (`ec.entity.find(...).iterator()`) streams rows from MySQL row-by-row, or whether it causes the driver to buffer the entire result set in the JVM heap, leading to memory exhaustion on large tables.

---

## 1. The Hypothesis Under Test
[--Hypothesis  ](https://github.com/hotwax/sim-routing/blob/main/docs/hypothesis-moqui-iterator-mysql-streaming.md)

---

## 2. Methodology & Baseline Measurements

To ensure accurate results, we bypassed Gradle (`./gradlew run`) and launched the compiled application directly using the `java` executable. This allowed strict control over the JVM arguments required for the Decisive Setup.

### 2.1 Establishing the constrained Memory Baseline
After applying constraints, we measured the server's default maximum memory capacity using a Groovy shell script:

```groovy
ec.logger.warn("Max Memory: " + (Runtime.getRuntime().maxMemory() >> 20));
Output: 15:15:55.064 WARN o.moqui.i.c.LoggerFacadeImpl Max Memory: 256
```

### 2.2 Data Generation & Table Sizing
We populated test_large_entity with over 8.3 million rows to ensure the table's physical size far exceeded our planned memory constraint.

```sql
SELECT table_name AS 'Table Name',
       ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'moqui_experiment'
  AND table_name = 'test_large_entity';
Output: test_large_entity | 566.00 MB
```

Observation: Setting a JVM heap limit of 256 MB would guarantee a crash if the framework attempted to buffer the 566 MB table.

---

## 3. Code-Verified Facts & Driver Documentation
Before executing the trap, we verified the underlying framework logic and primary source documentation:

**Cursor Type:** Confirmed in `EntityFindBase.groovy` that the default result set is `TYPE_FORWARD_ONLY` and `CONCUR_READ_ONLY`.

**Fetch Size Guard:** Confirmed in `EntityFindBuilder.java` that the engine forces a positive fetch size:

```java
if (fetchSize != null && fetchSize > 0) {
    ps.setFetchSize(fetchSize);
} else {
    ps.setFetchSize(100); 
}
```
---

## 4. The Experiment: Fair-Test Controls & Falsification

### 4.1 The Conditional Control Run (`useCursorFetch=true`)
We first booted the server using Moqui's actual default `mysql8` profile, which implicitly injects `useCursorFetch=true` into the connection string under the hood. We executed the MemoryTest service against the 8.3 million row table.

- **Time to Create Iterator:** 26108 ms
- **Time to First Row:** 77 ms
- **Heap Curve:** Memory Before: 70 MB | At First Row: 69 MB | At End: 69 MB

Observation: The system did not crash. MySQL utilized a server-side cursor, successfully feeding the data in manageable batches of 100, overriding the driver's default buffering behavior.

### 4.2 Strict Default Connection)
To test the actual hypothesis—which dictates testing the connection without the `useCursorFetch` crutch—we implemented an inline JDBC configuration in `MoquiDevConf.xml` to forcefully strip away the framework's hidden safety net.

```xml
<datasource group-name="transactional" database-conf-name="mysql8" schema-name="">
    <inline-jdbc jdbc-driver="com.mysql.cj.jdbc.Driver"
                 jdbc-uri="jdbc:mysql://127.0.0.1:3306/moqui_experiment?useCursorFetch=false&amp;useSSL=false&amp;allowPublicKeyRetrieval=true&amp;serverTimezone=UTC"
                 jdbc-username="root" jdbc-password="my_pass"/>
</datasource>
```

Here we need to explictily determine useCursorFetch=false . As in the ActualMoquiConf.xml the useCursorFetchProperties is set to true 

*Note on Framework Defaults:* The hypothesis premise assumes the framework's default connection lacks `useCursorFetch`. However,  auditing of the framework reveals Moqui's actual default `mysql8` profile explicitly injects `useCursorFetch=true` to prevent this exact crash.

**Result I got:**

```
org.moqui.impl.entity.EntitySqlException: Error finding list of TestLargeEntity by null [S1000]
Caused by: java.lang.OutOfMemoryError: Java heap space
    at com.mysql.cj.protocol.a.NativeProtocol.readAllResults(NativeProtocol.java:1713)
```

---

## 5. Final Verdict Conclusion

### Verdict: Hypothesis (H) is REFUTED
Under the explicitly defined scope (no `useCursorFetch`), Hypothesis H is REFUTED and Hypothesis A is CONFIRMED. When cursor-based safety is Explictily made false , the Moqui iterator does *not* stream row-by-row. Instead, the MySQL Connector/J ignores the positive fetch size (100) and buffers the entire result set into the JVM heap upfront, resulting in a catastrophic `OutOfMemoryError`.

### Business Impact & Boundaries
The assumption that we can iterate a huge table safely using standard Moqui tools is false for MySQL unless server-side cursors are explicitly enabled. However, this limitation is strictly regarding read execution (cursor orchestration and runtime memory management). It has nothing to do with SQL generation, meaning the `SELECT` text generated by the Entity Engine remains perfectly safe to use.

### Actionable Takeaways for the Sync Engine
The sim-routing sync engine cannot rely on Moqui's Entity Engine read paths for bulk cross-database loads. It must use raw JDBC connections configured with `setFetchSize(Integer.MIN_VALUE)` to safely stream large tables, drastically reducing the ~83,000 network round-trips caused by Moqui's 100-row batching guard.

---

Below are the Screenshots of our observation

<img width="1667" height="184" alt="Screenshot from 2026-06-26 14-52-01" src="https://github.com/user-attachments/assets/46c270a6-e09d-4a25-ae7f-9fed04a2638c" />

---

<img width="486" height="88" alt="Screenshot from 2026-06-26 14-54-56" src="https://github.com/user-attachments/assets/b7506162-f046-4665-b619-faf70b7b3b31" />

---

<img width="947" height="292" alt="Screenshot from 2026-06-26 14-58-10" src="https://github.com/user-attachments/assets/316b869e-bea0-49b3-83c4-3ed9bc15f072" />

---
