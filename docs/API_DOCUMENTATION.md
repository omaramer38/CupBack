# CupBack — REST API Specification & Contract Reference

> **Platform:** CupBack Mobile Café Marketplace  
> **Base URL:** `https://api.cupback.app/api/v1`  
> **Protocol:** HTTPS / TLS 1.3  
> **Data Format:** JSON (`application/json`)  
> **Authentication:** Bearer Token via Laravel Sanctum  
> **Audience:** Backend Engineers, Flutter Mobile Engineers, QA Engineers, Gemini Implementation Agent  

---

## 1. Global API Conventions & Standards

### 1.1 HTTP Headers
- `Accept: application/json` (Mandatory)
- `Content-Type: application/json` (Mandatory on POST, PUT, PATCH)
- `Authorization: Bearer <token>` (Required for all authenticated endpoints)
- `X-Idempotency-Key: <UUIDv4>` (Mandatory on `/orders`, `/confirm-cash`, and payments)
- `X-App-Locale: ar | en` (Optional, defaults to user account preference or `ar`)

### 1.2 Standard Success Response Envelope
```json
{
  "success": true,
  "message": "Resource retrieved successfully.",
  "data": {},
  "meta": null
}
```

### 1.3 Standard Cursor-Based Pagination Envelope
```json
{
  "success": true,
  "message": "Cafés retrieved successfully.",
  "data": [],
  "meta": {
    "per_page": 20,
    "next_cursor": "eyJpZCI6ImFiYzEyMyJ9",
    "prev_cursor": null,
    "has_more": true
  }
}
```

### 1.4 Standard Error Response Envelope
```json
{
  "success": false,
  "message": "Validation failed on the submitted payload.",
  "error_code": "VALIDATION_ERROR",
  "errors": {
    "phone_number": [
      "The phone number field is required."
    ]
  }
}
```

### 1.5 Common Error Codes
| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| **400** | `BAD_REQUEST` | Malformed request syntax or unprocessable parameters. |
| **401** | `UNAUTHENTICATED` | Missing, expired, or revoked Bearer token. |
| **403** | `FORBIDDEN` | Authenticated user lacks permission or is blocked by the café. |
| **404** | `RESOURCE_NOT_FOUND` | Targeted entity does not exist or belongs to another tenant. |
| **409** | `ACTIVE_ORDER_EXISTS` | Customer already has an ongoing active order (Rule Q3). |
| **409** | `REWARD_ALREADY_REDEEMED` | Concurrency check: loyalty reward was already consumed. |
| **422** | `VALIDATION_ERROR` | Schema validation or business rule validation failed. |
| **429** | `RATE_LIMIT_EXCEEDED` | Request threshold breached for current client window. |
| **500** | `INTERNAL_SERVER_ERROR`| Unhandled server exception (logged with Correlation ID). |

---

## 2. Authentication & Profile Endpoints

### `POST /auth/register`
- **Purpose:** Register a new customer.
- **Auth:** Public.
- **Rate Limit:** 5 requests / min.
- **Request Body:**
```json
{
  "full_name": "أحمد محمود",
  "phone_number": "01012345678",
  "password": "SecurePassword123!",
  "current_area_id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d"
}
```
- **Response (201 Created):**
```json
{
  "success": true,
  "message": "Registration successful.",
  "data": {
    "user": {
      "id": "u1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
      "full_name": "أحمد محمود",
      "phone_number": "01012345678",
      "current_area_id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
      "role": "customer"
    },
    "token": "1|sanctum_token_string_here..."
  }
}
```

### `POST /auth/login`
- **Purpose:** Authenticate via phone and password.
- **Auth:** Public.
- **Request Body:**
```json
{
  "phone_number": "01012345678",
  "password": "SecurePassword123!"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Authenticated successfully.",
  "data": {
    "user": {
      "id": "u1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
      "full_name": "أحمد محمود",
      "role": "customer"
    },
    "token": "2|sanctum_token_string_here..."
  }
}
```

### `PUT /customer/profile/area`
- **Purpose:** Switch active browsing area.
- **Auth:** Required (`customer`).
- **Request Body:**
```json
{
  "area_id": "b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Browsing area updated successfully.",
  "data": {
    "current_area_id": "b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e"
  }
}
```

---

## 3. Areas & Public Café Discovery

### `GET /areas`
- **Purpose:** Fetch list of active administrative areas.
- **Auth:** Public.
- **Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
      "name_ar": "وسط البلد - كفر الشيخ",
      "name_en": "Downtown - Kafr El-Sheikh",
      "city_name_ar": "كفر الشيخ",
      "city_name_en": "Kafr El-Sheikh"
    }
  ]
}
```

### `GET /cafes`
- **Purpose:** Browse approved, active cafés in customer's selected area.
- **Auth:** Required (`customer`).
- **Query Params:** `?area_id=<uuid>&search=<string>&cursor=<token>`
- **Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "c1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
      "name_ar": "كافيه أروما",
      "name_en": "Aroma Cafe",
      "slug": "aroma-cafe",
      "logo_url": "https://cdn.cupback.app/cafes/aroma_logo.webp",
      "banner_url": "https://cdn.cupback.app/cafes/aroma_banner.webp",
      "is_currently_open": true,
      "today_hours": {
        "opening_time": "08:00",
        "closing_time": "01:00"
      }
    }
  ]
}
```

### `GET /cafes/{id}/menu`
- **Purpose:** Fetch full menu catalog with variants and modifiers.
- **Auth:** Required (`customer`).
- **Cache Header:** `ETag` enabled.
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "cafe_id": "c1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
    "categories": [
      {
        "id": "cat-001",
        "name_ar": "قهوة مختصة",
        "name_en": "Specialty Coffee",
        "products": [
          {
            "id": "prod-001",
            "name_ar": "كافيه لاتيه",
            "name_en": "Caffe Latte",
            "image_url": "https://cdn.cupback.app/products/latte.webp",
            "is_available": true,
            "variants": [
              {
                "id": "var-001",
                "name_ar": "صغير (250 مل)",
                "name_en": "Small (250ml)",
                "price_piasters": 6500,
                "is_default": true,
                "is_available": true
              },
              {
                "id": "var-002",
                "name_ar": "كبير (400 مل)",
                "name_en": "Large (400ml)",
                "price_piasters": 8500,
                "is_default": false,
                "is_available": true
              }
            ],
            "modifier_groups": [
              {
                "id": "mg-001",
                "name_ar": "نوع الحليب",
                "name_en": "Milk Choice",
                "is_required": true,
                "min_selections": 1,
                "max_selections": 1,
                "modifiers": [
                  {
                    "id": "mod-001",
                    "name_ar": "حليب بقري كامل الدسم",
                    "name_en": "Full Cream Whole Milk",
                    "price_adjustment_piasters": 0,
                    "is_available": true
                  },
                  {
                    "id": "mod-002",
                    "name_ar": "حليب شوفان عضوي",
                    "name_en": "Organic Oat Milk",
                    "price_adjustment_piasters": 2000,
                    "is_available": true
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
```

---

## 4. Cart & Order Execution

### `POST /orders`
- **Purpose:** Place an order (Pickup or Dine-in).
- **Auth:** Required (`customer`).
- **Headers:** `X-Idempotency-Key: <uuid>`
- **Request Body:**
```json
{
  "cafe_id": "c1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
  "fulfillment_type": "pickup",
  "table_number": null,
  "payment_method": "cash",
  "applied_offer": {
    "type": "promotion",
    "reference_id": "promo-uuid-99"
  },
  "items": [
    {
      "product_id": "prod-001",
      "product_variant_id": "var-001",
      "quantity": 2,
      "modifier_ids": [
        "mod-002"
      ]
    }
  ]
}
```
- **Backend Validations Performed:**
  1. Active Order Check: Customer must NOT have any non-terminal orders across platform.
  2. Block Check: Customer must NOT be blocked by `cafe_id`.
  3. Operating Hours: Café must be currently open.
  4. Availability Check: All items, variants, and modifiers must be in stock.
  5. Modifier Group Rules: Min/max selections verified.
  6. Server-Side Price Calculation: Line totals and subtotal computed authoritatively.
  7. Offer Validation: If `applied_offer` supplied, verify eligibility and compute discount.
- **Response (201 Created):**
```json
{
  "success": true,
  "message": "Order placed successfully. Waiting for café confirmation.",
  "data": {
    "order": {
      "id": "ord-uuid-555",
      "order_number": 1042,
      "cafe_id": "c1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
      "status": "pending_confirmation",
      "payment_method": "cash",
      "payment_status": "pending",
      "subtotal_piasters": 17000,
      "discount_piasters": 3400,
      "total_piasters": 13600,
      "created_at": "2026-11-09T17:30:00Z"
    }
  }
}
```

### `GET /orders/active`
- **Purpose:** Fetch customer's current non-terminal order (if one exists).
- **Auth:** Required (`customer`).
- **Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "has_active_order": true,
    "order": {
      "id": "ord-uuid-555",
      "order_number": 1042,
      "cafe_name_ar": "كافيه أروما",
      "status": "confirmed",
      "payment_status": "pending"
    }
  }
}
```

---

## 5. Café Operational Endpoints

### `GET /cafe-management/orders/incoming`
- **Purpose:** Stream newly received orders requiring confirmation.
- **Auth:** Required (`cafe_manager`, `cafe_staff`).
- **Response (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "order_id": "ord-uuid-555",
      "order_number": 1042,
      "customer_name": "أحمد محمود",
      "fulfillment_type": "pickup",
      "payment_method": "cash",
      "payment_status": "pending",
      "total_piasters": 13600,
      "items_summary": "2x كافيه لاتيه (صغير, حليب شوفان)",
      "created_at": "2026-11-09T17:30:00Z"
    }
  ]
}
```

### `PUT /cafe-management/orders/{id}/accept`
- **Purpose:** Accept order and commence preparation.
- **Auth:** Required (`cafe_manager`, `cafe_staff`).
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Order accepted and moved to preparation.",
  "data": {
    "order_id": "ord-uuid-555",
    "status": "confirmed"
  }
}
```

### `PUT /cafe-management/orders/{id}/reject`
- **Purpose:** Reject order with a mandatory reason.
- **Auth:** Required (`cafe_manager`, `cafe_staff`).
- **Request Body:**
```json
{
  "rejection_reason": "نفاد حليب الشوفان المطلوب مؤقتاً، نعتذر بشدة."
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Order rejected.",
  "data": {
    "order_id": "ord-uuid-555",
    "status": "rejected",
    "rejection_reason": "نفاد حليب الشوفان المطلوب مؤقتاً، نعتذر بشدة."
  }
}
```

### `PUT /cafe-management/orders/{id}/ready`
- **Purpose:** Notify customer that order is prepared and ready at the counter.
- **Auth:** Required (`cafe_manager`, `cafe_staff`).
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Order marked ready for pickup.",
  "data": {
    "order_id": "ord-uuid-555",
    "status": "ready"
  }
}
```

### `PUT /cafe-management/orders/{id}/confirm-cash`
- **Purpose:** Confirm physical receipt of cash at counter.
- **Auth:** Required (`confirm_cash` permission).
- **Headers:** `X-Idempotency-Key: <uuid>`
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Cash collection confirmed. Order completed.",
  "data": {
    "order_id": "ord-uuid-555",
    "payment_status": "paid",
    "order_status": "completed",
    "cash_confirmed_at": "2026-11-09T17:45:00Z"
  }
}
```

---

## 6. Disciplinary Blocking & CRM Endpoints (Q18 Confirmed)

### `POST /cafe-management/customers/{customer_id}/block`
- **Purpose:** Block customer from placing orders with this café.
- **Auth:** Required (`block_customers` permission).
- **Request Body:**
```json
{
  "reason": "Customer placed 2 cash orders on 2026-11-09 and failed to arrive for collection."
}
```
- **Response (201 Created):**
```json
{
  "success": true,
  "message": "Customer blocked successfully at this café.",
  "data": {
    "block_id": "blk-uuid-123",
    "customer_id": "u1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
    "cafe_id": "c1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c",
    "is_active": true,
    "created_at": "2026-11-09T18:00:00Z"
  }
}
```

### `DELETE /cafe-management/customers/{customer_id}/block`
- **Purpose:** Manually remove a customer block.
- **Auth:** Required (`block_customers` permission).
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Customer restriction lifted."
}
```

### `PUT /admin/customers/{cafe_id}/{customer_id}/unblock`
- **Purpose:** Administrative override of café-level block.
- **Auth:** Required (`platform_admin`).
- **Request Body:**
```json
{
  "override_comment": "Customer submitted proof of hospital emergency. Block resolved upon mediation."
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Administrative override executed successfully. Block deactivated."
}
```

---

## 7. Payment Webhook Callback

### `POST /payments/webhook`
- **Purpose:** Asynchronous payment notification from Paymob.
- **Auth:** Public with HMAC SHA-512 Signature verification via `X-Paymob-Signature` header.
- **Processing Logic:**
  1. Verify HMAC against raw body.
  2. Locate payment record by `gateway_order_id`.
  3. Validate amount and currency match order.
  4. Inside DB transaction, transition payment to `paid` and order to `pending_confirmation`.
  5. Fire `OrderEligibleForConfirmation` event.
- **Response (200 OK):**
```json
{
  "received": true
}
```
