# CardVault Rust Backend

A Flutter-ready REST backend shaped around the CardVault architecture: API Gateway -> domain services -> repositories/data, with a simulated card-network boundary.

## Stack
- Rust + Tokio
- Axum REST API
- Serde JSON
- Tower HTTP CORS + tracing
- In-memory repository for the first Flutter integration pass

## Run
```bash
cargo run
```

Server: `http://localhost:8080`

Health:
```bash
curl http://localhost:8080/health
```

## Demo flow
1. Get cards:
```bash
curl http://localhost:8080/api/v1/cards
```
2. Copy the card `id`.
3. Get limits:
```bash
curl http://localhost:8080/api/v1/cards/<CARD_ID>/limits
```
4. Update controls:
```bash
curl -X PATCH http://localhost:8080/api/v1/cards/<CARD_ID>/controls \
  -H 'content-type: application/json' \
  -d '{"online":false,"international":true}'
```
5. Credit summary:
```bash
curl http://localhost:8080/api/v1/credit/summary
```
6. Statements:
```bash
curl http://localhost:8080/api/v1/statements
```
7. Bills:
```bash
curl http://localhost:8080/api/v1/payments/bills
```
8. Pay a bill:
```bash
curl -X POST http://localhost:8080/api/v1/payments/bills/<BILL_ID> \
  -H 'content-type: application/json' \
  -d '{"amount":2450,"idempotency_key":"flutter-demo-001"}'
```

## Flutter base URL
Android emulator:
`http://10.0.2.2:8080`

Physical Android phone on the same Wi-Fi:
`http://YOUR_LAPTOP_LAN_IP:8080`

Linux/desktop Flutter:
`http://127.0.0.1:8080`

For Android HTTP development, allow cleartext traffic or use HTTPS. Production should use HTTPS only.

## Architecture mapping
- `api/handlers.rs` = API Gateway / HTTP boundary
- `services/` = Card management, controls & limits, credit/statements, bill payments, vault reveal logic
- `repositories/` = data access abstraction (currently in-memory)
- `models/` = request/response/domain models
- `core/` = application state and cross-cutting helpers

## Security notes
This is a development backend, not a real banking backend. PAN reveal is intentionally simulated. For production, use an HSM/token vault, short-lived authorization, audit logs, rate limits, authentication/authorization, request signing where needed, database transactions, encrypted secrets, and a real card-network/payment-provider integration.

## Next production step
Replace `RepositoryStore` with PostgreSQL repositories and introduce authentication middleware that extracts a user/customer ID from a verified access token. Keep Flutter talking only to the API layer; Flutter should never connect directly to PostgreSQL or an HSM.
