# CupBack — Architecture Decision Records (ADR)

> **Platform:** CupBack Mobile Café Marketplace  
> **Repository:** `docs/ARCHITECTURE_DECISIONS.md`  
> **Status:** Active Decision Register  
> **Audience:** Principal Architects, Tech Leads, DevSecOps, Gemini Implementation Agent  

---

## Decision Index

| ADR ID | Title | Scope | Status |
|--------|-------|-------|--------|
| **ADR-001** | Mobile Client Framework Selection | Client Layer | ✅ APPROVED |
| **ADR-002** | Backend API Framework Selection | Server Layer | ✅ APPROVED |
| **ADR-003** | Single Flutter Application with Role-Based UI | Client Layer | ✅ APPROVED |
| **ADR-004** | In-Memory Caching and Transport via Redis | Caching Layer | ✅ APPROVED |
| **ADR-005** | Asynchronous Queue Processing Strategy | Worker Layer | ✅ APPROVED |
| **ADR-006** | Dual Payment Settlement: Online + Cash at Counter | Financial Layer | ✅ APPROVED |
| **ADR-007** | Fulfillment Scope: Pickup + Optional Dine-In (No Delivery) | Business Logic | ✅ APPROVED |
| **ADR-008** | Customer Order Cancellation Prohibited Post-Submission | Business Logic | ✅ APPROVED |
| **ADR-009** | Global Active Order Concurrency Limit (One Active Order) | Business Logic | ✅ APPROVED |
| **ADR-010** | Single-Branch Café Baseline with Multi-Branch Extensibility | Database / Domain | ✅ APPROVED |
| **ADR-011** | Manual Café Rejection with Deferred Automated Timeouts | Workflow | ✅ APPROVED |
| **ADR-012** | Customer Phone Registration without Third-Party SMS OTP in V1 | Auth Layer | ✅ APPROVED |
| **ADR-013** | Admin-Managed Geographic Areas Selection | Localization / Area | ✅ APPROVED |
| **ADR-014** | Comprehensive Product Variants, Modifiers & Add-ons in V1 | Catalog Layer | ✅ APPROVED |
| **ADR-015** | Per-Café Customer Disciplinary Blocking Workflow | Governance / CRM | ✅ APPROVED |
| **ADR-016** | Inclusion of Advanced Loyalty & Promotions Engines in V1 MVP | Marketing Engine | ✅ APPROVED |
| **ADR-017** | Deferral of Platform Commission Collection & Café Subscriptions | Billing Layer | ✅ APPROVED |
| **ADR-018** | Relational Database Engine Selection (PostgreSQL vs. MySQL) | Data Layer | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-019** | Backend Clean Layered Service-Repository Pattern | Architecture | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-020** | Multi-Tenancy Isolation Strategy (Shared DB + Scoping) | Tenancy Layer | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-021** | Authentication & Token Lifecycle Strategy (Sanctum vs Passport)| Security / Auth | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-022** | Payment Gateway Selection for Egyptian Market (Paymob) | Integration | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-023** | Real-Time Engine Selection (Laravel Reverb vs Pusher/Soketi) | Real-Time Layer | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-024** | Push Notification Service Provider (FCM vs OneSignal) | Messaging Layer | ⏳ PROPOSED — AWAITING APPROVAL |
| **ADR-025** | Offer Stacking Policy (Single Offer Per Order Constraint) | Promotion Engine | ⏳ PROPOSED — AWAITING APPROVAL |

---

## Approved Architectural Decisions

### ADR-001: Mobile Client Framework Selection
- **Status:** ✅ APPROVED
- **Context:** CupBack requires high-performance, pixel-perfect rendering across Android and iOS with native-feeling Arabic (RTL) typography, complex modifier animations, and real-time state synchronization.
- **Decision:** Flutter (Dart) is selected as the exclusive client framework.
- **Consequences:** Unified codebase for both major mobile platforms, direct compilation to ARM machine code, robust internationalization (intl package), and high UI responsiveness.

### ADR-002: Backend API Framework Selection
- **Status:** ✅ APPROVED
- **Context:** Rapid domain modeling, enterprise-grade validation, native queue orchestration, and mature database migrations are essential.
- **Decision:** Laravel (PHP 8.3+) is approved for the core REST API backend.
- **Consequences:** Leverages Laravel’s mature ecosystem (Eloquent ORM, Horizon queue manager, Sanctum authentication, Reverb WebSockets, robust testing primitives).

### ADR-003: Single Flutter Application with Role-Based UI
- **Status:** ✅ APPROVED
- **Context:** Multiple stakeholders (Customers, Café Managers, Cashiers, Platform Admins) interact with CupBack. Publishing separate apps increases store overhead, maintenance, and deployment complexity.
- **Decision:** Build a single Flutter application where user identity and RBAC claims dynamically determine the interface shell (Customer Home, Café Dashboard, or Admin Control Center).
- **Consequences:** Single release pipeline. Strict route guards and backend authorization are mandatory to prevent unauthorized access.

### ADR-004: In-Memory Caching and Transport via Redis
- **Status:** ✅ APPROVED
- **Context:** Mitigating database load during peak rush hours (30K concurrent users) and providing microsecond pub/sub messaging.
- **Decision:** Redis is mandatory for API caching, rate-limiting counters, and queue transport.
- **Consequences:** In-memory caching offloads read-heavy menu queries. Critical constraint: Redis is NEVER the persistent source of truth for financial or order records.

### ADR-005: Asynchronous Queue Processing Strategy
- **Status:** ✅ APPROVED
- **Context:** Push notifications, transactional emails, payment webhooks, and analytics aggregation must not block synchronous HTTP request cycles.
- **Decision:** All asynchronous and non-blocking tasks must be dispatched through Redis-backed Laravel Queues monitored via Laravel Horizon.
- **Consequences:** Predictable sub-200ms API response times. Requires worker autoscaling and dead-letter queue (DLQ) retry strategies.

### ADR-006: Dual Payment Settlement: Online + Cash at Counter
- **Status:** ✅ APPROVED
- **Context:** The Egyptian market relies heavily on cash-on-hand while card/e-wallet payments are accelerating.
- **Decision:** Support both Online Payment (Cards/Wallets) and Cash at Counter.
- **Consequences:** Payment state and order fulfillment state must be strictly separated. Cash orders require explicit manual staff confirmation before being marked `paid`.

### ADR-007: Fulfillment Scope: Pickup + Optional Dine-In (No Delivery)
- **Status:** ✅ APPROVED
- **Context:** Food/beverage delivery logistics introduce driver fleet overhead, complex routing, and insurance liabilities that distract from the core café marketplace in V1.
- **Decision:** Restrict fulfillment in V1 to **Pickup / Takeaway** and **Optional Dine-In** (with optional Table Number).
- **Consequences:** Drastically simplifies order workflows, cuts development timelines, and ensures higher fulfillment reliability.

### ADR-008: Customer Order Cancellation Prohibited Post-Submission
- **Status:** ✅ APPROVED
- **Context:** Food and specialty beverages have immediate preparation times. Allowing post-submission customer cancellation creates stock wastage and disputes with café owners.
- **Decision:** Customers cannot cancel orders once submitted via the mobile application.
- **Consequences:** Simplifies order state machine and prevents refund abuse. Rejections can only be initiated by café staff.

### ADR-009: Global Active Order Concurrency Limit (One Active Order)
- **Status:** ✅ APPROVED — Q3 Confirmed
- **Context:** Prevents customers from placing multiple concurrent orders across different cafés, ensuring prompt collection and operational predictability.
- **Decision:** A customer with an order in any non-terminal state (`pending_payment`, `pending_confirmation`, `confirmed`, `preparing`, `ready`) is blocked from placing any subsequent order on the platform until the active order completes or terminates.
- **Consequences:** Enforced in backend transaction with row-level locks. Prevents abandoned orders and cart confusion.

### ADR-010: Single-Branch Café Baseline with Multi-Branch Extensibility
- **Status:** ✅ APPROVED — Q4 Confirmed
- **Context:** Most initial café partners operate a single physical location. However, enterprise brands will expand into multi-branch chains.
- **Decision:** Database models incorporate `cafe_branches`, but V1 business logic restricts cafés to a single active branch entity.
- **Consequences:** Eliminates future disruptive schema migrations while keeping V1 UI/UX streamlined.

### ADR-011: Manual Café Rejection with Deferred Automated Timeouts
- **Status:** ✅ APPROVED — Q6 Confirmed
- **Context:** Hardcoded automatic cancellation timeouts can prematurely terminate orders in busy cafés experiencing momentary counter surges.
- **Decision:** Defer automated rejection timeouts in V1. Café staff explicitly accept or reject orders manually. Rejections require a mandatory reason.
- **Consequences:** Preserves operational flexibility. Order queue alerts ensure staff attention.

### ADR-012: Customer Phone Registration without Third-Party SMS OTP in V1
- **Status:** ✅ APPROVED — Q10 Confirmed
- **Context:** SMS gateway aggregators in Egypt present recurring per-message costs, delivery delays, and integration friction during early-stage customer acquisition.
- **Decision:** Customer registration captures Full Name, Phone Number, and Area with password authentication, omitting mandatory SMS OTP verification in V1.
- **Consequences:** Zero third-party SMS friction on onboarding. Phone numbers are stored with unique constraints and format validation.

### ADR-013: Admin-Managed Geographic Areas Selection
- **Status:** ✅ APPROVED — Q19 Confirmed
- **Context:** City-by-city rollout in Egypt (Kafr El-Sheikh first, followed by Mansoura and Tanta) requires reliable regional filtering without GPS battery drain or map API licensing costs.
- **Decision:** Platform Administrators manage static geographic Areas. Cafés are assigned to an Area; customers select an active Area to browse local offerings.
- **Consequences:** Reliable discovery, zero location-spoofing issues, and straightforward expansion.

### ADR-014: Comprehensive Product Variants, Modifiers & Add-ons in V1
- **Status:** ✅ APPROVED — Q20 Confirmed
- **Context:** Specialty coffee and beverage ordering depends on precise sizing, milk choices, sweetness customization, and extra shots.
- **Decision:** Full support for independent Product Variants, required/optional Modifier Groups, min/max selection bounds, and price adjustments in V1.
- **Consequences:** Meets authentic café requirements. Requires server-side calculation and immutable order item snapshots.

### ADR-015: Per-Café Customer Disciplinary Blocking Workflow
- **Status:** ✅ APPROVED — Q18 Confirmed
- **Context:** Customers who repeatedly place cash orders and abandon pickup cause financial losses for cafés.
- **Decision:** Authorized café staff can block a customer at the café level with a mandatory justification. Platform Admin can review and override.
- **Consequences:** Protects café margins while preventing cross-platform over-blocking. Full audit logging maintained.

### ADR-016: Inclusion of Advanced Loyalty & Promotions Engines in V1 MVP
- **Status:** ✅ APPROVED
- **Context:** Retention and frequency of ordering are the primary commercial drivers for coffee marketplace survival.
- **Decision:** Deliver a fully configurable order-count loyalty cycle engine and segmented promotional campaign system in the initial V1 release.
- **Consequences:** Differentiates CupBack from generic food delivery clones. Demands robust concurrency controls to prevent duplicate redemptions.

### ADR-017: Deferral of Platform Commission Collection & Café Subscriptions
- **Status:** ✅ APPROVED
- **Context:** Monetization during market launch focuses on café onboarding and liquidity rather than financial toll-taking.
- **Decision:** Defer automated commission deduction, invoicing, and subscription billing to post-V1 phases.
- **Consequences:** Greatly simplifies V1 payment gateway integration while retaining historical transaction ledgers for future reporting.

---

## Proposed Architectural Decisions (Awaiting Approval)

### ADR-018: Relational Database Engine Selection (PostgreSQL vs. MySQL)
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** CupBack handles strict transactional order updates, immutable JSONB order snapshots, complex promotion segment evaluations, and multi-tenant scoping.
- **Alternatives Considered:**
  1. *MySQL 8.0+:* High familiarity, but lacks partial indexes, advanced JSONB indexing, and transactional DDL.
  2. *PostgreSQL 16+:* First-class JSONB querying, robust concurrency control (MVCC), partial indexes for active orders, and strict ACID compliance.
- **Recommendation:** **PostgreSQL 16+**.
- **Justification:** Superior JSONB performance for modifier snapshots, partial indexes (`WHERE status NOT IN ('completed','cancelled','rejected')`), and clean support for advanced temporal queries in promotions.

### ADR-019: Backend Clean Layered Service-Repository Pattern
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** CupBack’s business logic encompasses intricate pricing calculations, multi-program loyalty cycles, and promotional segmentation that must not bloat HTTP Controllers.
- **Alternatives Considered:**
  1. *Standard MVC (Fat Models / Fat Controllers):* Rapid initial setup, but degrades quickly into unmaintainable spaghetti code.
  2. *Domain-Driven Design (Hexagonal / Clean):* Maximum isolation, but introduces excessive boilerplate for a monolith.
  3. *Service-Repository Layered Pattern:* Controllers handle HTTP transport; Form Requests validate payloads; Services encapsulate business workflows; Repositories manage Eloquent query scoping.
- **Recommendation:** **Service-Repository Layered Architecture**.
- **Justification:** Ideal balance between rapid delivery and strict separation of concerns.

### ADR-020: Multi-Tenancy Isolation Strategy
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** Multiple cafés operate on the platform and must never access or view each other’s catalog, orders, CRM, or promotions.
- **Alternatives Considered:**
  1. *Database-per-tenant:* Impractical operational overhead and excessive cloud cost for hundreds of cafés.
  2. *Schema-per-tenant:* Migration complexity and pooling challenges in PostgreSQL.
  3. *Shared Database, Shared Tables with `cafe_id` Tenant Scoping:* Single schema where every café-owned table includes a foreign key `cafe_id`, enforced via Eloquent Global Scopes, authorization policies, and integration tests.
- **Recommendation:** **Shared Database & Tables with Enforced Eloquent Global Scopes**.
- **Justification:** Cost-effective, simple backups, supports marketplace-wide administrative queries, and easily hardened with global scoping middleware.

### ADR-021: Authentication & Token Lifecycle Strategy
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** Secure token issuance for mobile devices with token rotation, revocation, and low latency.
- **Alternatives Considered:**
  1. *Laravel Passport (OAuth2 server):* Heavyweight, requires complex cryptographic keys and multiple database lookups.
  2. *Laravel Sanctum:* Lightweight bearer token management, stored in database with token abilities (scopes), instant revocation, and sub-millisecond verification with Redis caching.
- **Recommendation:** **Laravel Sanctum**.
- **Justification:** Lightweight, rock-solid security, native role ability checks, and ideal for first-party mobile clients.

### ADR-022: Payment Gateway Selection for Egyptian Market
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** Must support Visa, Mastercard, Meeza national cards, and local mobile e-wallets (Vodafone Cash, Orange Money, etc.) with reliable server webhooks and refund APIs.
- **Alternatives Considered:**
  1. *FawryPay:* Dominant in cash-kiosk payments, but slower modern card/wallet mobile integration.
  2. *Kashier:* Good developer API, but smaller e-wallet coverage.
  3. *Paymob (Accept):* Industry standard in Egypt for unified cards, mobile wallets, and Meeza, with rich webhook notifications, test sandboxes, and automated refund endpoints.
- **Recommendation:** **Paymob**.
- **Justification:** Superior mobile SDK support, high acceptance rates in Egypt, and comprehensive local wallet support.

### ADR-023: Real-Time Engine Selection
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** Instant delivery of incoming order alerts to cafés and live status updates to customers.
- **Alternatives Considered:**
  1. *Pusher:* Hosted SaaS, but monthly costs escalate steeply with 30K concurrent connections.
  2. *Soketi:* Open-source Node.js Pusher-compatible server, but requires a separate operational runtime.
  3. *Laravel Reverb:* First-party, high-speed asynchronous WebSocket server for Laravel 11+, natively integrated with Redis pub/sub.
- **Recommendation:** **Laravel Reverb**.
- **Justification:** Built directly into the Laravel ecosystem, scales to tens of thousands of concurrent connections on low server footprints, zero recurring SaaS costs.

### ADR-024: Push Notification Service Provider
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL
- **Context:** Background alerts when the Flutter app is closed or backgrounded.
- **Alternatives Considered:**
  1. *OneSignal:* Easy UI, but introduces vendor lock-in and paid tier costs at scale.
  2. *Firebase Cloud Messaging (FCM):* Free, industry-standard Google infrastructure with native Flutter bindings (`firebase_messaging`) and direct APNs / FCM delivery.
- **Recommendation:** **Firebase Cloud Messaging (FCM)**.
- **Justification:** Zero recurring cost, native cross-platform support, rock-solid delivery across Android and iOS in Egypt.

### ADR-025: Offer Stacking Policy
- **Status:** ⏳ PROPOSED — AWAITING APPROVAL — Q11
- **Context:** Prevent compounding discounts from destroying café operating margins when a customer qualifies for both a loyalty reward and an active promotional campaign.
- **Alternatives Considered:**
  1. *Option A (Single Offer Per Order):* Customer may apply either ONE promotion OR ONE loyalty reward per checkout.
  2. *Option B (Additive Stacking):* Allow one promotion and one reward, summing discount percentages (e.g., 20% + 15% = 35%).
  3. *Option C (Sequential Stacking):* Apply one discount, then apply second discount to the remainder.
- **Recommendation:** **Option A (Single Offer Per Order)** for Version 1.
- **Justification:** Simplest UX, zero ambiguity for customers and cashiers, eliminates risk of unintended deep discounts, and produces clean audit ledgers.
