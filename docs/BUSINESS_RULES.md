# CupBack — Business Rules & Logic Specification

> **Platform:** CupBack Mobile Café Marketplace  
> **Status:** Authoritative Business Logic Specification  
> **Audience:** Solution Architects, Backend Engineers, QA Engineers, Gemini Implementation Agent  

---

## 1. Core Ordering & Fulfillment Rules

### BR-ORD-001: Exactly One Café Per Order (APPROVED)
- **Statement:** An order must contain products belonging exclusively to a single café. Aggregating products from multiple cafés into a single cart or checkout is strictly prohibited.
- **Enforcement:** Enforced at Flutter UI (cart replacement prompt), Backend Form Request validation, and Database constraints (`orders.cafe_id` foreign key).
- **Edge Cases:** If a customer attempts to add an item from Café B while their cart holds items from Café A, the Flutter app must present an explicit warning dialog: *"Your cart contains items from [Café A]. Do you want to clear your cart and start a new order with [Café B]?"*

### BR-ORD-002: Active Order Constraint (APPROVED — Q3)
- **Statement:** A customer may have strictly **ONE active order** across the entire platform at any given time. A customer who has an order in any non-terminal state (`pending_payment`, `pending_confirmation`, `confirmed`, `preparing`, `ready`) is blocked from placing any new order at ANY café on the platform.
- **Enforcement:** Backend database query wrapped in a transaction with `SELECT COUNT(*) FROM orders WHERE customer_id = ? AND status NOT IN ('completed', 'cancelled', 'rejected') FOR UPDATE`. If count $> 0$, the request is rejected with `HTTP 409 Conflict`.
- **Allowed:** Once the active order transitions to `completed`, `cancelled`, or `rejected`, the customer is immediately eligible to place an order at any café.

### BR-ORD-003: Customer Order Cancellation Prohibited (APPROVED)
- **Statement:** Customers cannot cancel an order through the application after submission under any circumstances.
- **Enforcement:** No cancellation endpoint or UI control exists for the customer role. Orders can only be terminated by café rejection (`rejected`) or automated payment failure cleanup (`cancelled`).

### BR-ORD-004: Mandatory Café Confirmation (APPROVED)
- **Statement:** An order cannot enter the preparation phase without explicit affirmative confirmation (`accept`) by authorized café staff.
- **Enforcement:** Orders placed by customers transition to `pending_confirmation` (or `pending_payment` if paying online). Preparation cannot begin until staff executes an explicit API call to transition the state to `confirmed`.

### BR-ORD-005: Fulfillment Scope (APPROVED)
- **Statement:** The platform supports only two fulfillment modes: **Pickup / Takeaway** and **Optional Dine-In**. Delivery services are explicitly excluded in Version 1.
- **Enforcement:** Checkout validation mandates selection of `fulfillment_type` as either `pickup` or `dine_in`. If `dine_in` is selected, `table_number` is optional.

---

## 2. Payment Lifecycle & Settlement Rules

### BR-PAY-001: Separation of Payment and Order State Machines (APPROVED)
- **Statement:** Order fulfillment status and payment financial status are decoupled and tracked via separate state machines.
- **Rationale:** An order may be physically "Ready" while cash collection remains "Pending", or an order may be "Rejected" while an online payment requires a "Refund".

### BR-PAY-002: Physical Cash Collection Confirmation (APPROVED)
- **Statement:** Orders selected for cash payment must NEVER be marked as `paid` upon order placement or café acceptance. Payment status transitions to `paid` ONLY after authorized café staff physically confirms cash collection at the counter.
- **Enforcement:** Handled via `PUT /api/v1/cafe-management/orders/{id}/confirm-cash`. Requires the `confirm_cash` permission. Full audit logging tracks the confirming staff member.

### BR-PAY-003: Server-Side Online Payment Verification (APPROVED)
- **Statement:** Client-side signals of online payment success are strictly untrusted. An online order is eligible for café confirmation ONLY after verified server-to-server webhook confirmation or server-side API polling against the payment gateway (Paymob).
- **Enforcement:** Webhook signature is validated using the gateway HMAC secret. The transaction amount and currency are verified against the order record before the order status transitions to `pending_confirmation`.

### BR-PAY-004: Online Payment Rejection & Refund Trigger (APPROVED)
- **Statement:** If an order paid online is subsequently rejected by the café, the backend must automatically initiate a refund workflow.
- **Enforcement:** Payment status transitions to `refund_pending`, a refund record is generated, and a high-priority background job dispatches the refund request to the payment gateway.

---

## 3. Product Catalog & Customization Rules

### BR-CAT-001: Server-Side Authoritative Pricing (APPROVED — Q20)
- **Statement:** Client applications must never submit prices, discounts, or line totals. The backend calculates item and order totals independently based on verified catalog records.
- **Calculation Formula:**
  $$\text{Item Total} = \left(\text{Base Variant Price} + \sum \text{Modifier Prices}\right) \times \text{Quantity}$$
  $$\text{Order Subtotal} = \sum \text{Item Totals}$$
  $$\text{Final Total} = \text{Order Subtotal} - \text{Validated Discount Amount}$$
- **Data Type:** All calculations and database columns utilize 64-bit unsigned integers representing Egyptian Piasters ($1\text{ EGP} = 100\text{ Piasters}$).

### BR-CAT-002: Modifier Group Constraint Enforcement (APPROVED — Q20)
- **Statement:** Customization choices must strictly satisfy the rules configured on `modifier_groups`:
  - If `is_required` is `true`, selections $\ge \max(1, \text{min\_selections})$.
  - Selections count must satisfy $\text{min\_selections} \le \text{count} \le \text{max\_selections}$.
  - Every selected modifier must belong to the associated modifier group.

### BR-CAT-003: Immutable Historical Order Snapshots (APPROVED — Q20)
- **Statement:** Modifying or deleting categories, products, variants, or modifiers must never alter completed or historical orders.
- **Enforcement:** `order_items` and `order_item_modifiers` store immutable copies of product titles, variant names, modifier names, and unit prices captured at the instant of order creation.

---

## 4. Customer Blocking & Disciplinary Rules (Q18 CONFIRMED)

### BR-BLK-001: Authorization & Initiation
- **Statement:** Only Café Managers or staff members explicitly granted the `block_customers` permission may block a customer. This permission is not granted to cashier staff by default.

### BR-BLK-002: Immediate Café-Level Effect
- **Statement:** A block takes effect immediately upon submission. No prior platform administrator approval is required.

### BR-BLK-003: Mandatory Reason & Audit Trail
- **Statement:** A customer block request must include a non-empty textual justification (e.g., "Customer failed to collect 3 orders on 2026-11-09"). The system must record: `cafe_id`, `customer_id`, `blocked_by_user_id`, `reason`, and `created_at`.

### BR-BLK-004: Tenant Isolation of Blocks
- **Statement:** A block placed by Café A restricts the customer from ordering at Café A ONLY. The customer remains fully active and entitled to order at Café B, Café C, and all other cafés on the platform.

### BR-BLK-005: Protection of Active Orders
- **Statement:** Placing a block on a customer must NEVER cancel, alter, or discard an existing active order currently in progress.

### BR-BLK-006: Unblocking & Administrative Override
- **Statement:** 
  1. The issuing café may manually unblock the customer at any time.
  2. The customer may submit an appeal or complaint to Platform Support.
  3. Platform Administrators possess the explicit authority to administratively review, override, and remove any café-level customer block.
  4. There is no automated expiration or automated unblocking.

### BR-BLK-007: Customer Privacy & Respectful Messaging
- **Statement:** When a blocked customer views the restricted café, the app displays: *"This café has restricted new orders for your account. Please contact the café for details or reach out to platform support."* Internal staff notes, private comments, and administrative memos must NEVER be exposed to the customer.

---

## 5. Loyalty & Rewards Engine Rules

### BR-LOY-001: Café-Specific Isolation (APPROVED)
- **Statement:** Loyalty programs, progress, and rewards are strictly isolated to the café that issued them. Orders placed at Café A never contribute to loyalty progress at Café B.

### BR-LOY-002: Cycle Progression & Reset Mechanics (APPROVED)
- **Statement:** In an $N$-order cycle:
  1. Customer completes orders $1$ through $N$ (e.g., 5 orders).
  2. Upon completion of order $N$, a single-use reward record is generated.
  3. The reward becomes available for redemption on order $N+1$.
  4. When the customer redeems the reward on order $N+1$, the reward is marked `consumed`.
  5. **Crucial Rule:** Order $N+1$ (the reward order) does NOT count as order 1 of the subsequent cycle. The new cycle begins with order $N+2$.

### BR-LOY-003: Transactional Single-Use Redemption (APPROVED)
- **Statement:** A reward can only be redeemed once. The redemption check and consumption must execute inside an ACID transaction with pessimistic row locking (`SELECT FOR UPDATE`) to prevent race conditions or duplicate redemptions.

---

## 6. Promotions & Segmentation Rules

### BR-PRM-001: Server-Side Schedule & Timezone Enforcement (APPROVED)
- **Statement:** Promotional campaign validity is evaluated strictly against the application server's verified clock in the café's configured timezone (`Africa/Cairo`). Client device timestamps are completely ignored.
- **Overnight Support:** Schedules crossing midnight (e.g., Friday 20:00 to Saturday 02:00) must be evaluated correctly across day transitions.

### BR-PRM-002: Segment Eligibility Evaluation (APPROVED)
- **Statement:** Eligibility for customer segments (New Customers, Existing, Frequent, Specific Customers, Inactive Customers) is evaluated server-side at the time of cart inspection and re-verified at the instant of order placement.

---

## 7. Proposed Rules Awaiting Approval (Q11–Q17)

| Rule ID | Domain | Proposed Rule Statement | Status |
|---------|--------|-------------------------|--------|
| **PR-STK-001** | Offer Stacking (Q11) | **One Offer Per Order:** A customer may apply at most ONE discount offer per order — either one promotion OR one loyalty reward. Offers cannot be stacked or combined. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-LOY-004** | Multi-Program Count (Q12) | **Independent Program Counting:** When a customer redeems a reward for Program A, that order skips counting for Program A only. It counts normally toward Program B if eligible. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-LOY-005** | Minimum Order Value (Q13) | **Configurable Minimum:** Cafés may optionally configure a minimum order value (e.g., 50 EGP) for an order to qualify toward loyalty cycle counts. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-LOY-006** | Rule Modification (Q14) | **Immutable In-Flight Cycles:** A café cannot alter thresholds of an active program. Modifying rules requires deactivating the old program and launching a new one. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-LOY-007** | Reward Expiration (Q15) | **Optional Expiration:** Cafés may configure reward validity (e.g., 30 days). Expired rewards are archived, and customers are notified 3 days prior. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-PRM-003** | Inactive Segment (Q16) | **Win-Back Campaigns in V1:** Include "Inactive Customers" ($>30$ or $>60$ days since last order) in V1 segmentation filters. | ⏳ PROPOSED — AWAITING APPROVAL |
| **PR-PRM-004** | Promotion Limits (Q17) | **V1 Limits Baseline:** Support maximum total redemptions, maximum redemptions per customer, and minimum order values in V1. | ⏳ PROPOSED — AWAITING APPROVAL |
