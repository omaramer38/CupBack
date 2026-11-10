# CupBack — Mobile Café Marketplace Platform — Technical Documentation Package

> **CupBack** — A high-performance, secure mobile café marketplace platform connecting customers with local cafés in Egypt.

---

## 1. Project Overview

**CupBack** is a commercial mobile marketplace platform connecting customers with multiple cafés. Customers can discover nearby cafés within their selected area, explore rich digital menus, customize orders with variants and modifiers, place orders for pickup or optional dine-in, make payments (online card/wallet or cash at counter), track order fulfillment in real time, earn café-specific loyalty rewards, and redeem targeted promotional offers.

The platform provides role-based interfaces in a single Flutter application:
- **Customer Experience:** Menu browsing, variant/modifier customization, cart, order submission, real-time tracking, loyalty progress, and personalized promotions.
- **Café Manager / Staff:** Real-time incoming orders, fulfillment status updates, physical cash collection confirmation, menu/variant/modifier catalog management, customer relationship insights, per-cafe customer blocking, independent loyalty reward programs, and segmented promotional campaigns.
- **Platform Administrator:** Marketplace control center, area management, café vetting and onboarding approvals, user governance, audit logging, order oversight, block overrides, dispute/refund mediation, and operational analytics.

### Market & Expansion Strategy
- **Initial Launch:** Kafr El-Sheikh, Egypt.
- **Geographic Expansion:** Designed to scale seamlessly across Egyptian governorates and cities (e.g., Mansoura, Tanta, Alexandria, Cairo) without architectural redesign.

---

## 2. Confirmed Technology Decisions

| Component | Confirmed Decision | Status |
|-----------|--------------------|--------|
| **Mobile Framework** | Flutter (Dart) | ✅ APPROVED |
| **Backend Framework** | Laravel (PHP) | ✅ APPROVED |
| **Cache Layer** | Redis (Mandatory) | ✅ APPROVED |
| **Background Processing** | Asynchronous Queue System (Mandatory) | ✅ APPROVED |
| **Client Application** | Single Flutter Codebase with Role-Based UI | ✅ APPROVED |
| **Payment Methods** | Dual Mode: Online (Card/Wallet) + Cash at Counter | ✅ APPROVED |
| **Real-Time Layer** | Live WebSocket Updates + Push Notifications | ✅ APPROVED |
| **Security Standard** | High Security (OWASP Top 10 API, ASVS, MASVS) | ✅ APPROVED |
| **Fulfillment Scope** | Pickup / Takeaway + Optional Dine-In (NO Delivery in V1) | ✅ APPROVED |
| **Order Concurrency** | Exactly ONE active order per customer across all cafés | ✅ APPROVED |
| **Order Scoping** | Exactly ONE café per order (no multi-café carts) | ✅ APPROVED |
| **Order Confirmation** | Mandatory café acceptance before preparation starts | ✅ APPROVED |
| **Cash Confirmation** | Physical confirmation by authorized café staff only | ✅ APPROVED |
| **Customer Cancellation** | Prohibited via application after submission | ✅ APPROVED |
| **Customer Registration** | Full Name, Phone Number, Selected Area (No OTP in V1) | ✅ APPROVED |
| **Product Customization** | Full Variants, Modifier Groups (Req/Opt), Add-ons in V1 | ✅ APPROVED |
| **Customer Blocking** | Per-café isolation with mandatory audit and admin override | ✅ APPROVED |
| **Loyalty & Promotions** | Full advanced configurable engines in V1 MVP | ✅ APPROVED |
| **Initial Concurrency Target** | 30,000 concurrent users stress-test milestone | ✅ APPROVED |

### Technology Decisions Requiring Formal Approval (Proposed)

| ID | Area | Proposed Recommendation | Status |
|----|------|-------------------------|--------|
| TD-A | Database Engine | **PostgreSQL 16+** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-B | Backend Architectural Pattern | **Service-Repository / Clean Layered Architecture** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-C | Multi-Tenancy Strategy | **Shared Database, Shared Tables with `cafe_id` Scoping & Global Scopes** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-D | Authentication & Token Lifecycle | **Laravel Sanctum with Secure Token Expiry & Rotation** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-E | Payment Gateway (Egypt) | **Paymob Unified Payments Gateway** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-F | Real-Time Engine | **Laravel Reverb (First-party WebSockets)** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-G | Push Notification Provider | **Firebase Cloud Messaging (FCM)** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-H | Cloud Infrastructure | **AWS (or DigitalOcean/Hetzner) with Managed DB & Redis** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-I | API Versioning | **URI Prefix (`/api/v1/`)** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-J | Media Storage | **AWS S3 / Cloudflare R2 with CloudFront CDN** | ⏳ PROPOSED — AWAITING APPROVAL |
| TD-K | Observability & Monitoring | **OpenTelemetry / Prometheus + Grafana + Sentry** | ⏳ PROPOSED — AWAITING APPROVAL |

---

## 3. Documentation Package Navigation

This documentation suite serves as the definitive **Single Source of Truth** for the CupBack platform.

| Document | Primary Focus & Contents |
|----------|--------------------------|
| [PROJECT_SCOPE.md](PROJECT_SCOPE.md) | In-scope vs. out-of-scope boundaries, actors, constraints, and release goals |
| [REQUIREMENTS.md](REQUIREMENTS.md) | Functional, non-functional requirements, user journeys, and acceptance criteria |
| [BUSINESS_RULES.md](BUSINESS_RULES.md) | Inviolable business rules, order/payment boundaries, blocking, and catalog rules |
| [GLOSSARY.md](GLOSSARY.md) | Comprehensive dictionary of domain terms, states, and architectural concepts |
| [SYSTEM_ARCHITECTURE.md](SYSTEM_ARCHITECTURE.md) | High-level topology, component diagrams, caching, queues, and data flows |
| [ARCHITECTURE_DECISIONS.md](ARCHITECTURE_DECISIONS.md) | Formal Architecture Decision Records (ADRs) with trade-offs and approvals |
| [DATABASE_DESIGN.md](DATABASE_DESIGN.md) | Complete PostgreSQL relational schema, indexes, constraints, ERD, and snapshots |
| [API_DOCUMENTATION.md](API_DOCUMENTATION.md) | Exhaustive REST API specification, headers, schemas, validation, and status codes |
| [ORDER_AND_PAYMENT_FLOWS.md](ORDER_AND_PAYMENT_FLOWS.md) | Dual state machines, sequence diagrams, race condition handling, and failure modes |
| [LOYALTY_AND_PROMOTIONS_SPECIFICATION.md](LOYALTY_AND_PROMOTIONS_SPECIFICATION.md) | Configurable loyalty cycles, customer segmentation, promotion scheduling, and eligibility engine |
| [SECURITY.md](SECURITY.md) | STRIDE threat model, RBAC matrix, tenant isolation, encryption, and OWASP compliance |
| [DATA_PROTECTION_AND_RECOVERY.md](DATA_PROTECTION_AND_RECOVERY.md) | ACID boundaries, PITR backup strategy, RPO/RTO specifications, and audit trails |
| [SCALABILITY_AND_PERFORMANCE.md](SCALABILITY_AND_PERFORMANCE.md) | 30K concurrent user scaling blueprint, caching tiers, worker scaling, and load test scripts |
| [REALTIME_AND_NOTIFICATIONS.md](REALTIME_AND_NOTIFICATIONS.md) | WebSocket private channels, presence, FCM background delivery, and resilience |
| [FLUTTER_ARCHITECTURE.md](FLUTTER_ARCHITECTURE.md) | BLoC state management, Clean Architecture folder structure, RTL, and role routing |
| [UI_UX_GUIDELINES.md](UI_UX_GUIDELINES.md) | Official CupBack brand palette (#4B2E1F, #C87C43, #F2E9DC), Skellige/Palestine display typography, Cairo/Jakarta body text, selected middle app icon, and 56-screen inventory |
| [TESTING_STRATEGY.md](TESTING_STRATEGY.md) | Testing pyramid, tenant isolation verification, concurrency/race tests, and quality gates |
| [IMPLEMENTATION_ROADMAP.md](IMPLEMENTATION_ROADMAP.md) | 9-phase sequential execution roadmap for implementation agent (Gemini) |
| [GEMINI_HANDOFF.md](GEMINI_HANDOFF.md) | Execution protocols, coding standards, verification gates, and boundaries for Gemini |
| [OPEN_QUESTIONS.md](OPEN_QUESTIONS.md) | Unresolved questions, proposed options, impact analysis, and decision register |

---

## 4. Instructions for the Implementation Agent (Gemini)

1. **Role Discipline:** You are the implementation engineer. You must NOT alter architecture, change business rules, or introduce unapproved shortcuts.
2. **Reading Order:** Read `README.md`, `GEMINI_HANDOFF.md`, `BUSINESS_RULES.md`, `DATABASE_DESIGN.md`, and `API_DOCUMENTATION.md` before writing any code.
3. **Phase-by-Phase Execution:** Implement strictly according to `IMPLEMENTATION_ROADMAP.md`. Do not leap ahead to UI before core data layers and APIs pass verification.
4. **Validation Integrity:** All pricing, discount calculation, eligibility, and authorization MUST execute server-side. Never rely on client-supplied calculations.
5. **Report & Stop on Blockers:** If a task touches an item marked `PROPOSED — AWAITING APPROVAL` or an open question, halt and request human sign-off.
