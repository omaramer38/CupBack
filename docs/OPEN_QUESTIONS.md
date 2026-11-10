# CupBack — Open Questions & Decision Register

> **Platform:** CupBack Mobile Café Marketplace  
> **Status:** Active Decision Register  
> **Purpose:** Transparent ledger of finalized decisions, proposed recommendations awaiting human sign-off, and deferred roadmap items.  

---

## 1. Status Labels Definition

- `✅ CONFIRMED / APPROVED`: Decision has received explicit human approval. Embedded as non-negotiable architectural law.
- `⏳ PROPOSED — AWAITING APPROVAL`: Vetted engineering recommendation formulated with technical, financial, and operational justification. Ready for human sign-off.
- `⏸️ DEFERRED`: Explicitly postponed to post-V1 phases by human direction.

---

## 2. Business Decisions Register

### 2.1 Finalized Business Decisions

| Decision ID | Domain | Finalized Choice | Status |
|-------------|--------|------------------|--------|
| **Q1** | Fulfillment Mode | **Pickup / Takeaway + Optional Dine-In (No Delivery).** Table number is optional for dine-in. | ✅ CONFIRMED |
| **Q2** | Cash Settlement | **Physical counter confirmation by authorized staff only.** Never auto-marked as paid. | ✅ CONFIRMED |
| **Q3** | Order Concurrency | **Strictly ONE active order across the entire platform.** Any non-terminal order blocks new orders. | ✅ CONFIRMED |
| **Q4** | Café Branches | **Single branch baseline in V1.** Database schema includes `cafe_branches` for multi-branch readiness. | ✅ CONFIRMED |
| **Q5** | Customer Cancellation | **Prohibited post-submission.** No cancellation control in application. | ✅ CONFIRMED |
| **Q7** | Operating Hours | **Café-managed schedule with overnight support + manual emergency override.** System-enforced. | ✅ CONFIRMED |
| **Q8** | Loyalty Engine Scope | **Full advanced engine in V1 MVP.** Configurable order-count cycles and multiple programs. | ✅ CONFIRMED |
| **Q9** | Monetization / Billing | **Deferred.** Commission collection and monthly subscriptions are post-V1 roadmap items. | ✅ CONFIRMED |
| **Q10** | Registration & Onboarding | **Phone number + Name + Area without SMS OTP in V1.** Café accounts require Admin approval. | ✅ CONFIRMED |
| **Q18** | Customer Disciplinary Block | **Per-café isolation, authorized staff, mandatory reason, audit logs, and admin override.** | ✅ CONFIRMED |
| **Q19** | Geographic Discovery | **Admin-managed static Area list in V1.** GPS proximity sorting deferred to V2. | ✅ CONFIRMED |
| **Q20** | Product Customization | **Full Variants, Modifier Groups (Req/Opt), Add-ons, server-side pricing, and snapshots in V1.** | ✅ CONFIRMED |

---

### 2.2 Business Proposals Awaiting Approval (Q11–Q17)

#### Q11. Offer Stacking & Combination Policy
- **The Issue:** A customer may qualify for both a loyalty reward (e.g., 20% off) and a promotional campaign (e.g., 15% off). Should they be allowed to combine them?
- **Alternatives:**
  - *Option A (Recommended):* **Single Offer Per Order.** Customer chooses either ONE promotion OR ONE loyalty reward per checkout.
  - *Option B:* Allow 1 promotion + 1 loyalty reward with additive discount percentages.
  - *Option C:* Allow compounding discounts applied sequentially.
- **Engineering Recommendation:** **Option A**. Simplest UX, eliminates risk of unintended deep discounts, produces transparent audit trails, and protects café margins.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q12. Reward-Redeemed Order Counting Across Programs
- **The Issue:** If a customer redeems a reward for Program A on Order 6, does Order 6 count toward Program B?
- **Alternatives:**
  - *Option A:* Order 6 is excluded from ALL programs at that café.
  - *Option B (Recommended):* Order 6 is excluded ONLY from Program A's next cycle. It counts toward Program B if eligible.
- **Engineering Recommendation:** **Option B**. Programs remain independent and customer engagement is not penalized.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q13. Minimum Order Value for Loyalty Progression
- **The Issue:** Does every completed order count toward loyalty, regardless of spend?
- **Alternatives:**
  - *Option A:* Any completed order counts, even a single bottled water.
  - *Option B (Recommended):* Cafés can optionally configure a minimum order value (e.g., 50 EGP) to qualify toward cycle progression.
- **Engineering Recommendation:** **Option B**. Prevents gaming the system with micro-orders.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q14. Loyalty Program Modification Mid-Cycle
- **The Issue:** What happens if a café changes an active program's threshold from 5 to 7 orders?
- **Alternatives:**
  - *Option A:* Existing in-flight customer progress is altered retroactively.
  - *Option B:* Two versions of the program run concurrently for different users.
  - *Option C (Recommended):* Rules of active programs are immutable. To change rules, the café must deactivate the old program (freezing progress) and launch a new one.
- **Engineering Recommendation:** **Option C**. Prevents customer disputes, guarantees data consistency, and preserves trust.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q15. Reward Expiration Policy
- **The Issue:** Do unlocked loyalty rewards remain valid indefinitely?
- **Alternatives:**
  - *Option A:* Rewards never expire.
  - *Option B (Recommended):* Cafés can optionally configure an expiration period (e.g., 30 days). Expired rewards are archived, and customers receive a push alert 3 days prior.
- **Engineering Recommendation:** **Option B**. Encourages repeat visits while giving cafés control.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q16. Inactive Customer Segment in Version 1
- **The Issue:** Should win-back campaigns targeting customers with no orders in 30/60 days be in V1?
- **Alternatives:**
  - *Option A:* Defer to Version 2.
  - *Option B (Recommended):* Include in Version 1.
- **Engineering Recommendation:** **Option B**. Extremely low implementation cost (single date comparison against `cafe_customers.last_order_at`) with high commercial value.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

#### Q17. Promotion Management Features Prioritization
- **The Issue:** Which campaign controls are mandatory for V1 MVP?
- **Engineering Recommendation:** Include in V1: Maximum total campaign redemptions, maximum redemptions per customer, minimum order value, and campaign status workflow (draft, scheduled, active, paused, expired). Defer complex cohort retention analytics to V2.
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL

---

### 2.3 Deferred Business Decisions

| Decision ID | Domain | Deferred Scope | Status |
|-------------|--------|----------------|--------|
| **Q6** | Rejection Timeout | Automated order rejection/cancellation timer is deferred per user direction. In V1, café staff manually accept or reject orders. | ⏸️ DEFERRED |

---

## 3. Technology Stack Proposals Awaiting Approval

| ID | Technology Area | Proposed Recommendation | Rationale | Status |
|----|-----------------|-------------------------|-----------|--------|
| **TD-A** | Database Engine | **PostgreSQL 16+** | Superior JSONB indexing for immutable modifier snapshots, partial indexes for active order checks, rock-solid ACID transactions. | ⏳ PROPOSED |
| **TD-B** | Backend Architecture | **Clean Layered Service-Repository** | Decouples complex pricing, loyalty math, and promotion eligibility from HTTP controllers. | ⏳ PROPOSED |
| **TD-C** | Multi-Tenancy Strategy | **Shared Database & Tables with Scoping** | Maximum cost efficiency, simple backups, enforced via Eloquent Global Scopes. | ⏳ PROPOSED |
| **TD-D** | API Authentication | **Laravel Sanctum** | Lightweight, high-performance bearer token lifecycle with token abilities and instant revocation. | ⏳ PROPOSED |
| **TD-E** | Payment Gateway | **Paymob Unified (Egypt)** | Industry standard in Egypt for Cards, Meeza, and Mobile E-Wallets with automated webhook refunds. | ⏳ PROPOSED |
| **TD-F** | Real-Time Engine | **Laravel Reverb** | First-party asynchronous WebSockets, zero recurring SaaS costs, scales to 30K+ persistent connections. | ⏳ PROPOSED |
| **TD-G** | Push Notifications | **Firebase Cloud Messaging (FCM)** | Free, native Google/Apple APNs delivery, direct Flutter integration. | ⏳ PROPOSED |
| **TD-H** | Cloud Infrastructure | **Linux Instances on AWS / Hetzner** | Stateless containerized API nodes behind Load Balancer, managed PostgreSQL & Redis. | ⏳ PROPOSED |
| **TD-I** | API Versioning | **URI Prefix (`/api/v1/`)** | Predictable routing and clean backward compatibility for mobile clients. | ⏳ PROPOSED |
| **TD-J** | Media Storage | **AWS S3 / Cloudflare R2 + CDN** | High-speed global asset delivery, image resizing pipelines, cost-effective storage. | ⏳ PROPOSED |
| **TD-K** | Observability | **Prometheus + Grafana + Sentry** | Real-time latency tracking, slow-query monitoring, and error tracing with correlation IDs. | ⏳ PROPOSED |
