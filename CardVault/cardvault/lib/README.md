# CardVault Flutter V1 integration

This is a complete `lib/` directory designed around the P02 CardVault architecture:

- Presentation: screens/widgets/go_router
- State: Riverpod providers/notifiers
- Data: repositories/models
- Core: Dio API client, errors, biometric/secure-screen abstractions, motion

## Backend connection

The default API base URL is:

- Linux/Desktop: `http://127.0.0.1:8080`
- Android emulator: `http://10.0.2.2:8080`
- Physical Android phone: `http://YOUR_LAPTOP_IP:8080`

Change `lib/core/network/api_client.dart` -> `ApiConfig.baseUrl`.

## Add dependencies

Run:

```bash
flutter pub add dio flutter_riverpod go_router
```

Then copy the supplied `lib/` folder over the `lib/` folder in your Flutter project.

For Android development against HTTP, configure cleartext traffic if required by your project. Production should use HTTPS.

## Current API integration

Implemented against the current V1 endpoints:

- GET /health
- GET /api/v1/cards
- GET /api/v1/cards/{card_id}
- POST /api/v1/cards/{card_id}/block
- POST /api/v1/cards/{card_id}/reveal
- GET/PATCH /api/v1/cards/{card_id}/controls
- GET/PATCH /api/v1/cards/{card_id}/limits
- GET /api/v1/statements
- GET /api/v1/statements/{statement_id}
- GET /api/v1/credit/summary
- GET /api/v1/payments/bills
- GET /api/v1/payments/bills/{bill_id}
- POST /api/v1/payments/bills/{bill_id}

## Run

1. Start Rust backend:
```bash
cargo run
```

2. Add Flutter dependencies:
```bash
flutter pub add dio flutter_riverpod go_router
```

3. Copy `lib/` into your Flutter project.

4. Set the correct base URL.

5. Run:
```bash
flutter run
```

The development reveal flow intentionally displays the simulated PAN returned by the V1 backend. Do not use that behavior in production.
