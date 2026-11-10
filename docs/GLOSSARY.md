# CupBack — System Glossary & Ubiquitous Language

> **Platform:** CupBack Mobile Café Marketplace  
> **Purpose:** Standardized domain terminology for engineering, product, QA, and implementation agents  

---

## 1. Domain Terminology (Alphabetical)

### Active Order
An order currently progressing through non-terminal operational states (`pending_payment`, `pending_confirmation`, `confirmed`, `preparing`, `ready`). Per business rule Q3, a customer with an active order is strictly prohibited from placing another order at ANY café on the platform until the active order reaches a terminal state.

### Add-on
An optional or required single customization option within a Modifier Group (e.g., "Oat Milk", "Caramel Drizzle", "Extra Espresso Shot"). Can carry an additional positive price adjustment or be offered free (0.00 EGP).

### Area
An administrative geographic zone created and maintained by the Platform Administrator (e.g., "Kafr El-Sheikh - Downtown", "Mansoura - University District"). Cafés are explicitly assigned to an Area. Customers select an active Area to browse and order from local cafés.

### Audit Log
An immutable, append-only record documenting sensitive platform actions, including actor identity, target resource, action type, previous state, new state, IP address, user agent, and timestamp. Never subject to soft deletion.

### Branch (`cafe_branch`)
A physical café location belonging to a café brand. In V1, each café operates exactly one branch. The database schema includes `cafe_branches` to support multi-branch operations in future phases without structural migration.

### Café (`cafe`)
A merchant entity registered on the CupBack marketplace. Owns its catalog, operating schedule, staff permissions, customer relationships, loyalty programs, and promotional campaigns.

### CaféCustomer (`cafe_customers`)
A pivotal domain relationship entity binding a global Customer to a specific Café. Stores isolated, café-specific relationship statistics such as lifetime completed order count, total revenue generated, first order timestamp, and last order timestamp.

### Customer Block (`cafe_customer_blocks`)
A disciplinary restriction placed by an authorized café staff member (possessing the `block_customers` permission) prohibiting a specific customer from placing new orders with that specific café. Does not prevent the customer from ordering at other cafés. Requires a mandatory textual reason and provides an audit trail.

### Dine-In
A fulfillment mode where the customer consumes their order physically inside the café premises. Allows the customer to optionally supply an in-store Table Number during checkout.

### Fulfillment Mode
The physical method by which the customer receives the prepared order. In CupBack V1, only two fulfillment modes are supported: **Pickup / Takeaway** and **Dine-In**. Delivery is explicitly out of scope.

### Idempotency Key
A unique client-generated or transaction-specific UUID attached to mutating HTTP requests (such as order submission or payment callbacks) to guarantee that duplicate transmissions (e.g., due to network retries or double clicks) execute business logic exactly once.

### Immutable Order Snapshot
A permanent, unalterable JSONB or relational snapshot captured on `order_items` and `order_item_modifiers` at the exact moment of order submission. Captures product name, variant title, modifier selections, and price points. Ensures that historical orders never alter if a café later edits or deletes catalog items.

### Inactive Customer
A customer segmentation criteria defining customers who have previously ordered from a specific café but have not completed an order within a configurable time window (e.g., 30 or 60 days). Used to trigger win-back promotions.

### Loyalty Cycle
A repeating progression mechanism where a customer completes a configurable number of qualifying orders (e.g., 5 orders) at a specific café to earn a single-use reward. Once redeemed on the subsequent order, the cycle resets, and the redemption order does not count toward the next cycle.

### Modifier Group
A categorised group of related customization choices associated with a product (e.g., "Milk Choice", "Sugar Level", "Syrup Flavors"). Configured with rules: `is_required` (true/false), `min_selections` (integer), and `max_selections` (integer).

### Non-Terminal State
Any interim state in the lifecycle of an order or payment where operational workflow is ongoing. Examples: `pending_confirmation`, `preparing`, `ready`.

### One Café Per Order Rule
The mandatory business constraint requiring every cart and order to be associated with exactly one café. Customers cannot aggregate items from multiple cafés in a single checkout.

### Payment State
An independent lifecycle state describing financial settlement (`pending`, `processing`, `paid`, `failed`, `cancelled`, `refund_pending`, `refunded`). Strictly separated from the operational fulfillment Order State.

### Piaster
The smallest monetary unit in Egypt (1 Egyptian Pound [EGP] = 100 Piasters). To prevent IEEE 754 floating-point rounding inaccuracies, all currency values, pricing, discounts, and totals are stored and calculated in the backend database as 64-bit integers representing Piasters.

### Pickup / Takeaway
The primary fulfillment mode where a customer places an advance order through the CupBack application and visits the café counter to collect the packaged order.

### Platform Administrator
The super-administrative role responsible for platform health, approving café onboarding, configuring operational areas, resolving customer-café disputes, managing audit logs, and overriding customer blocks.

### Product Variant
A distinct SKU or physical sizing variation of a parent product (e.g., "Single Espresso", "Double Espresso", "Small 250ml", "Large 450ml") with an independent base price.

### Promotion Campaign
A café-configured marketing offer targeted at specific customer segments or individual users, governed by start/end dates, weekly time windows, and usage caps (e.g., "20% off for new customers on Thursday afternoons").

### Rejection Reason
A mandatory explanation provided by café staff when declining an incoming order. Recorded in audit logs and displayed transparently and respectfully to the customer in the application.

### Reward Program
A café-configured loyalty scheme defining order thresholds, reward types (Percentage, Fixed Amount, Free Item, Free Order), and eligible menu scopes.

### Role-Based Access Control (RBAC)
A security model where permissions (`manage_menu`, `accept_orders`, `confirm_cash`, `block_customers`) are assigned to roles (`cafe_manager`, `cafe_cashier`), and roles are mapped to authenticated users.

### Server-Side Time
The verified, tamper-proof clock maintained by backend application servers (in UTC), used to validate campaign schedules, operating hours, order timeouts, and audit timestamps. Client device time is untrusted.

### Single Source of Truth (SSOT)
The principle designating the backend relational database as the sole authoritative record for all pricing, order states, payment statuses, and user entitlements. Redis and client caches are disposable replicas.

### Table Number
An optional alphanumeric identifier entered by a customer selecting Dine-In fulfillment, indicating their physical seating location within the café.

### Tenant Isolation
The architectural and logical separation ensuring that Café A cannot inspect, modify, or infer any data belonging to Café B, including orders, catalog items, financial figures, customer CRM records, and promotional configurations.

### Terminal State
A final, immutable state in a state machine from which no further transitions are permitted. For Orders: `completed`, `cancelled`, `rejected`. For Payments: `paid`, `refunded`, `failed`.

### User ID
A permanent, globally unique identifier (UUID v4) assigned to a customer or staff member upon registration. Remains unchanged regardless of geographical moves, device changes, or profile edits.

### Webhook
An automated, cryptographically signed HTTP callback sent from an external payment gateway (e.g., Paymob) to the CupBack backend to report asynchronous payment settlement events.
