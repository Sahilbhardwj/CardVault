use std::sync::Arc;
use tokio::sync::RwLock;

use crate::{models::{card::Card, controls::CardControls, limits::CardLimits, statement::Statement, bill::Bill, credit::CreditSummary}, repositories::RepositoryStore};

#[derive(Clone)]
pub struct AppState {
    pub repo: Arc<RwLock<RepositoryStore>>,
}

impl AppState {
    pub fn new() -> Self {
        Self {
            repo: Arc::new(RwLock::new(RepositoryStore::seeded())),
        }
    }
}

pub const DEMO_USER_ID: &str = "demo-user";

pub fn mask_pan(pan: &str) -> String {
    if pan.len() < 4 { return "****".to_string(); }
    format!("•••• {}", &pan[pan.len()-4..])
}

pub fn card_to_public(mut card: Card) -> Card {
    card.pan = mask_pan(&card.pan);
    card
}

pub fn default_controls() -> CardControls {
    CardControls { online: true, contactless: true, international: false, atm: true }
}

pub fn default_limits() -> CardLimits {
    CardLimits { daily_purchase: 100_000, daily_atm: 25_000, contactless: 5_000 }
}

pub fn default_credit() -> CreditSummary {
    CreditSummary { credit_limit: 200_000, available_credit: 157_500, current_due: 12_500, minimum_due: 2_500, due_date: "2026-10-05".into(), utilization_percent: 21.25 }
}

pub fn _keep_types(_: Statement, _: Bill) {}
