# CupBack — Data Integrity, Protection & Disaster Recovery Specification

> **Platform:** CupBack Mobile Café Marketplace  
> **Recovery Target:** RPO $\le 15\text{ minutes}$, RTO $\le 2\text{ hours}$  
> **Data Integrity Tier:** High-Assurance Financial & Transactional Integrity  
> **Audience:** Database Administrators, Site Reliability Engineers, DevSecOps, Gemini Implementation Agent  

---

## 1. Transaction Boundaries & ACID Guarantees

CupBack enforces strict ACID boundaries. No financial, order-state, loyalty, or inventory mutation may execute outside an explicit database transaction.

### 1.1 Atomic Mutation Matrix

| Business Operation | Encompassed Database Mutations | Isolation Level | Locking Strategy |
|--------------------|--------------------------------|-----------------|------------------|
| **Order Submission** | 1. Active order validation check.<br>2. Insert `orders` record.<br>3. Insert `order_items` (immutable snapshots).<br>4. Insert `order_item_modifiers` (snapshots).<br>5. Insert `payments` (initial pending record).<br>6. Insert `order_status_history`. | Read Committed | Pessimistic Lock on Customer Active Orders (`FOR UPDATE`) |
| **Cash Confirmation** | 1. Transition `payments.status` to `paid`.<br>2. Transition `orders.status` to `completed`.<br>3. Increment `cafe_customers.total_completed_orders` and `total_spent_piasters`.<br>4. Increment `customer_reward_progress` (if eligible).<br>5. Record `audit_logs` entry. | Read Committed | Pessimistic Lock on Order Row (`FOR UPDATE`) |
| **Loyalty Reward Redemption** | 1. Verify `reward_redemptions.status` is `available`.<br>2. Attach redemption to order.<br>3. Transition status to `consumed`.<br>4. Reset `customer_reward_progress.current_cycle_order_count` to 0.<br>5. Exclude current order from next cycle progress. | Repeatable Read | Row-level Lock on `reward_redemptions` (`FOR UPDATE`) |
| **Customer Disciplinary Block** | 1. Insert `cafe_customer_blocks` with mandatory reason.<br>2. Insert `audit_logs` entry with actor identity and timestamp.<br>3. Guarantee ongoing active orders remain unaffected. | Read Committed | Row-level Lock on `cafe_customers` |

---

## 2. Immutable Snapshots & Historical Auditability

A core vulnerability in e-commerce systems is changing prices or altering menu descriptions after an order is placed. CupBack completely prevents historical alteration through immutable data snapshots:

```mermaid
flowchart LR
    subgraph "Live Café Catalog (Mutable by Staff)"
        P["Product: Caffe Latte\nBase: 65.00 EGP"]
        M["Modifier: Oat Milk\nAdjustment: +20.00 EGP"]
    end

    subgraph "Order Placement Instant"
        Capture["📸 Capture Frozen Snapshot"]
    end

    subgraph "Order Record (Immutable Forever)"
        OI["order_items:\nproduct_name_ar: 'كافيه لاتيه'\nunit_price_piasters: 6500"]
        OIM["order_item_modifiers:\nmodifier_name_ar: 'حليب شوفان'\nprice_adjustment_piasters: 2000"]
    end

    P --> Capture
    M --> Capture
    Capture --> OI
    Capture --> OIM
```

Even if the café subsequently deletes "Caffe Latte" or raises its price to 85.00 EGP, the customer's historical order, receipt, accounting ledger, and tax records remain exactly 85.00 EGP (65.00 + 20.00 EGP).

---

## 3. Disaster Recovery Objectives & Backup Strategy

### 3.1 Recovery Objectives
- **Recovery Point Objective (RPO):** $\le 15\text{ minutes}$. Maximum acceptable data loss under total datacenter destruction. Achieved via continuous PostgreSQL Write-Ahead Log (WAL) archiving to off-site object storage.
- **Recovery Time Objective (RTO):** $\le 2\text{ hours}$. Total elapsed time between catastrophic failure and fully operational, verified service restoration.

### 3.2 Automated Backup Topology

| Backup Tier | Mechanism | Schedule | Retention | Storage Destination |
|-------------|-----------|----------|-----------|---------------------|
| **Continuous WAL Archiving** | `pg_receivewal` / WAL-G | Streaming Real-Time | 7 Days Rolling | Cloudflare R2 / AWS S3 (Separate Region) |
| **Daily Full Snapshot** | `pg_dump` (Compressed Custom) | Nightly at 03:00 UTC | 30 Days Rolling | Encrypted S3 Bucket with Immutable Object Lock |
| **Monthly Archive** | Encrypted Snapshot Archive | 1st of each month | 12 Months | Glacier / Deep Archive |
| **Redis Cache State** | RDB Snapshot | Hourly | 24 Hours | Local NVMe (Disposable Cache) |

---

## 4. Disaster Recovery & Restoration Runbook

In the event of a catastrophic database failure or cloud host compromise, SRE personnel must execute the following verified procedure:

```mermaid
sequenceDiagram
    autonumber
    actor SRE as On-Call SRE / Architect
    participant S3 as Encrypted Backup Storage
    participant NewDB as Fresh PostgreSQL Instance
    participant App as Laravel API Cluster
    participant Redis as Redis Cluster

    SRE->>S3: Download Latest Nightly Full Dump + WAL Stream
    SRE->>NewDB: Execute Point-in-Time Recovery (PITR)
    NewDB-->>SRE: Database Restored to Target Recovery Timestamp (e.g., T-5 min)
    SRE->>NewDB: Run Integrity Verification Suite (Check sum of balances, active orders)
    SRE->>Redis: Flush All Stale In-Memory Cache (FLUSHALL)
    SRE->>App: Update DATABASE_URL Connection Strings & Restart Pods
    App->>NewDB: Run Database Health Probe (SELECT 1)
    App-->>SRE: Health Probes Green (200 OK)
    SRE->>App: Enable Ingress Traffic (Route 53 DNS Failover)
```

### 4.1 Post-Restoration Verification Checklist
- [ ] Verify primary key sequences (`SELECT MAX(id) FROM orders`).
- [ ] Check active orders consistency (ensure no orphaned pending payment rows).
- [ ] Warm up critical caches: Areas, approved Cafés list, active operating hours.
- [ ] Confirm Laravel Horizon queue workers connect and consume cleanly.
- [ ] Transmit test transaction on staging environment prior to global DNS traffic switch.
