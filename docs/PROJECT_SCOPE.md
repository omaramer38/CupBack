# CupBack — Project Scope & Boundaries Specification

> **Platform:** CupBack Mobile Café Marketplace  
> **Document Type:** Architectural Scope & Boundary Definition  
> **Target Audience:** Product Owners, Solution Architects, DevSecOps, Gemini Implementation Agent  

---

## 1. Executive Summary

CupBack is a specialized two-sided marketplace designed to streamline ordering and customer retention for cafés across Egypt. The platform enables customers to discover local cafés, customize drinks and food items, place advance orders for pickup or dine-in, track preparation live, pay via online methods or cash, and participate in customized loyalty and promotional campaigns.

This document establishes the precise boundaries of the **Version 1 (V1) Minimum Viable Product (MVP)** and defines the non-negotiable architectural hooks required for future scalability.

---

## 2. In-Scope Functionality (Version 1 / MVP)

### 2.1 Customer Experience (Mobile Flutter App)
- **Account Registration & Authentication:**
  - Registration requiring Full Name, Mobile Phone Number, and Selected Current Area.
  - Password-based authentication (secure token lifecycle via Laravel Sanctum).
  - Ability to change active browsing Area dynamically without altering permanent identity or history.
- **Café Discovery & Exploration:**
  - Filter and list active, approved cafés located strictly within the customer's selected Area.
  - View café profile (operating hours, description, logo, hero banner, open/closed status).
  - Search cafés by name and filter by menu offerings.
- **Catalog & Product Customization:**
  - Browse categorised menus with rich imagery and descriptions.
  - Select Product Variants (e.g., Small, Medium, Large) with distinct base prices.
  - Select Modifiers / Add-ons from Modifier Groups (e.g., Milk Type, Sugar Level, Flavor Syrup, Extra Espresso Shot).
  - Enforcement of Modifier Group constraints: Required vs. Optional, Minimum and Maximum selection counts.
  - Real-time display of calculated item total based on selected options.
- **Cart & Order Submission:**
  - Strict enforcement of Single-Café Cart (adding item from another café prompts cart replacement warning).
  - Select Fulfillment Mode: **Pickup / Takeaway** or **Optional Dine-In**.
  - Optional Table Number input (specifically for Dine-In).
  - Choose Payment Method: **Online Payment** (Credit/Debit Card, E-Wallets) or **Cash at Counter**.
  - View real-time breakdown: Subtotal, Applied Discount, and Total Payable.
- **Loyalty & Promotions Integration:**
  - View café-specific loyalty progress (e.g., "Order 4 of 5 to unlock 20% discount").
  - View available and eligible promotional campaigns tailored to the customer segment.
  - Select eligible offer to apply discount at checkout (subject to stacking policy).
- **Order Tracking & Lifecycle:**
  - Real-time live status updates via WebSockets (Pending Confirmation → Confirmed / In Preparation → Ready for Pickup → Completed / Rejected).
  - Push notifications on status transitions and order completion.
  - Rejection visibility: view clear café rejection reason if rejected.
  - Order history with immutable itemized snapshots.
- **Profile & Restrictions:**
  - View order history and redemption receipts.
  - Clear, respectful notification if restricted/blocked by a specific café with contact/appeal instructions.

### 2.2 Café Management Experience (Role-Based Flutter App)
- **Operational Dashboard & Order Handling:**
  - Real-time live incoming order queue with audible alerts and visual priority flags.
  - Review order details: customer name, items, variants, modifiers, fulfillment type, table number (if dine-in), and payment status.
  - Action orders: **Accept** or **Reject** (mandatory selection/input of rejection reason).
  - Progress order fulfillment: Transition from Confirmed to "Preparing" and "Ready for Pickup".
  - **Cash Collection Confirmation:** Authorized staff manually confirms receipt of physical cash at counter, transitioning payment to "Paid".
- **Menu & Catalog Engineering:**
  - Full CRUD operations on Categories, Products, Variants, and Modifier Groups.
  - Configure modifier rules: minimum choices, maximum choices, required status, and pricing increments.
  - Toggle instant product availability (In Stock / Out of Stock).
- **Operating Hours & Schedule Management:**
  - Configure daily opening and closing hours.
  - Support for overnight schedules (e.g., 18:00 to 02:00 next day).
  - Flag regular closed days.
  - Manual emergency Open / Closed override toggle.
- **Café Customer Relationship Management (CRM):**
  - View café-specific customer directory (isolated strictly to customers who have ordered from this café).
  - Inspect customer history with this café: total completed orders, lifetime spend, first and last order timestamps.
  - Identify customer relationship status: New, Returning, Frequent.
- **Customer Blocking Workflow (Q18 Confirmed):**
  - Authorized staff (with explicit `block_customers` permission) can block a customer due to non-collection or abuse.
  - Mandatory input of blocking reason.
  - Comprehensive audit trail: logging actor, timestamp, customer ID, and justification.
  - Ability to manually unblock a customer.
  - Block applies strictly to this café and does not affect the customer's standing with other cafés.
- **Advanced Loyalty & Rewards Engine:**
  - Create and manage multiple concurrent reward programs.
  - Configure order count thresholds (e.g., every 5, 7, 10 completed orders).
  - Configure reward types: Percentage Discount, Fixed Amount Discount, Free Item, Free Order.
  - Configure reward scope: Entire Menu, Selected Categories, or Selected Products.
  - Cycle mechanics: reward unlocks for the subsequent order; redemption consumes the cycle; the redemption order does not count toward the next cycle.
- **Promotions & Offers Engine:**
  - Create targeted promotional campaigns.
  - Target customer segments: New Customers, Existing/Returning, Frequent (>5, >10, >20 orders), Specific Customers, Inactive Customers.
  - Configure scheduling: Day of week, time-of-day windows, date ranges, and timezone integrity.
  - Enforce campaign limits: maximum total redemptions, maximum redemptions per customer, minimum order value.

### 2.3 Platform Administration (Control Center within Flutter App)
- **Marketplace Governance:**
  - Area management: Create, update, and manage Egyptian cities and operational zones (Kafr El-Sheikh, Mansoura, Tanta, etc.).
  - Café onboarding and vetting: Review applications, approve, activate, suspend, or terminate café accounts.
  - Assign cafés to specific geographic Areas.
  - Manage café branches (V1 baseline: 1 branch per café, schema-ready for multi-branch).
- **User & Security Governance:**
  - Global user management across Customers, Café Staff, and Admins.
  - Granular Role-Based Access Control (RBAC) management and assignment.
  - Multi-Factor Authentication (MFA) enforcement for administrative credentials.
- **Operational Oversight & Auditing:**
  - Global order supervision and real-time operational metrics.
  - Payment auditing and reconciliation across online transactions and counter cash reports.
  - Dispute resolution tools and refund initiation workflow for failed or rejected online transactions.
  - Customer block oversight: Ability to review, mediate, and execute administrative overrides on café-level blocks.
  - Centralized, tamper-evident audit logging of all sensitive administrative and financial actions.
  - Broadcast notifications to specific cafés, all cafés, or targeted customer groups.

---

## 3. Out-of-Scope Functionality (Version 1 / Explicit Exclusions)

To protect delivery velocity, architectural focus, and operational stability, the following capabilities are explicitly excluded from V1:

| Excluded Feature | Architectural Rationale & Strategy |
|------------------|-----------------------------------|
| **Delivery Service & Fleet Management** | CupBack V1 focuses strictly on Takeaway and Dine-In. No driver accounts, routing algorithms, delivery fees, or geotracking fleet systems will be implemented. |
| **Web Ordering Portal (Website)** | The platform is mobile-first and mobile-only in V1. Flutter mobile app covers all user roles. No consumer web storefront is in scope. |
| **GPS / Geolocation Proximity Sorting** | Cafés are filtered by admin-managed static Areas. Dynamic GPS radius queries, polygon geofencing, and proximity math are deferred to V2. |
| **Commission Collection & Automated Billing** | Marketplace commission models and monthly subscription billing are deferred. System records raw transaction data; automated billing logic is out of V1. |
| **Phone Number OTP Verification** | Customer registration accepts valid mobile numbers without third-party SMS OTP gateways in initial V1 deployment to streamline onboarding. |
| **Multi-Branch Café Management** | While database schemas incorporate `cafe_branches`, V1 business logic restricts cafés to a single active branch entity. |
| **Automated Rejection Timeouts** | Automated expiration/rejection timers for orders are DEFERRED per Q6. Order acceptance/rejection remains an explicit manual staff action. |
| **Advanced Machine Learning & Cohort Analytics** | Advanced predictive customer churn, cohort retention heatmaps, and automated discount optimization are post-V1 roadmap items. |

---

## 4. Key Constraints & Operational Environment

1. **Client Deployment:** Single unified Flutter binary deployed across Google Play Store and Apple App Store, routing dynamically to Customer, Café Manager, or Administrator experiences based on authenticated RBAC claims.
2. **Target Region & Localization:** Initial rollout in Kafr El-Sheikh, Egypt. System must natively support Arabic (RTL, primary) and English (LTR), with currency represented in Egyptian Pounds (EGP / Piasters).
3. **Backend Stack:** Modern Laravel 11+ framework hosted on Linux containerized infrastructure, coupled with managed PostgreSQL and Redis instances.
4. **Network Resilience:** Mobile clients must gracefully handle volatile 3G/4G connectivity across Egyptian cellular providers (Vodafone, Orange, Etisalat, WE) with offline-aware error states and auto-reconnecting WebSockets.
5. **Scale Target:** The system architecture must comfortably sustain an initial benchmark of **30,000 concurrent active users** during peak rush hours (morning rush and evening cafe hours) without throughput degradation.
