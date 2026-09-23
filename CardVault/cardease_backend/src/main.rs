mod api;
mod core;
mod models;
mod repositories;
mod services;

use std::sync::Arc;

use axum::{
    routing::{get, post},
    Router,
};
use tower_http::{cors::CorsLayer, trace::TraceLayer};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

use crate::{api::handlers, core::AppState};

#[tokio::main]
async fn main() {
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| {
                    "cardvault_backend=debug,tower_http=debug".into()
                }),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    let state = Arc::new(AppState::new());

    let app = Router::new()
        // Health
        .route("/health", get(handlers::health))

        // Cards
        .route("/api/v1/cards", get(handlers::list_cards))
        .route("/api/v1/cards/{card_id}", get(handlers::get_card))
        .route(
            "/api/v1/cards/{card_id}/block",
            post(handlers::block_card),
        )
        .route(
            "/api/v1/cards/{card_id}/reveal",
            post(handlers::reveal_card),
        )

        // Card limits
        .route(
            "/api/v1/cards/{card_id}/limits",
            get(handlers::get_limits)
                .patch(handlers::update_limits),
        )

        // Card controls
        .route(
            "/api/v1/cards/{card_id}/controls",
            get(handlers::get_controls)
                .patch(handlers::update_controls),
        )

        // Statements
        .route(
            "/api/v1/statements",
            get(handlers::list_statements),
        )
        .route(
            "/api/v1/statements/{statement_id}",
            get(handlers::get_statement),
        )

        // Credit
        .route(
            "/api/v1/credit/summary",
            get(handlers::credit_summary),
        )

        // Bills
        .route(
            "/api/v1/payments/bills",
            get(handlers::list_bills),
        )
        .route(
            "/api/v1/payments/bills/{bill_id}",
            get(handlers::get_bill)
                .post(handlers::pay_bill),
        )

        // Middleware
        .layer(TraceLayer::new_for_http())
        .layer(CorsLayer::permissive())

        // Application state
        .with_state(state);

    let addr = "0.0.0.0:8080";

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .expect("bind failed");

    tracing::info!(
        "CardVault backend listening on http://{addr}"
    );

    axum::serve(listener, app)
        .await
        .expect("server failed");
}