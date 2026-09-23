use std::sync::Arc;
use tokio::sync::RwLock;
use uuid::Uuid;
use crate::{core::mask_pan, models::{card::Card, controls::{CardControls, UpdateControlsRequest}, limits::{CardLimits, UpdateLimitsRequest}, statement::Statement, bill::{Bill, PayBillRequest}, credit::CreditSummary}, repositories::RepositoryStore};

pub async fn cards(repo: &Arc<RwLock<RepositoryStore>>) -> Vec<Card> {
    let r = repo.read().await;
    r.cards.values().cloned().map(|mut c| { c.pan = mask_pan(&c.pan); c }).collect()
}

pub async fn card(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<Card> {
    let r = repo.read().await;
    r.cards.get(&id).cloned().map(|mut c| { c.pan = mask_pan(&c.pan); c })
}

pub async fn block(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<Card> {
    let mut r = repo.write().await;
    let c = r.cards.get_mut(&id)?;
    c.status = "BLOCKED".into();
    let mut out = c.clone(); out.pan = mask_pan(&out.pan); Some(out)
}

pub async fn controls(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<CardControls> {
    repo.read().await.controls.get(&id).cloned()
}

pub async fn update_controls(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid, req: UpdateControlsRequest) -> Option<CardControls> {
    let mut r = repo.write().await;
    let c = r.controls.get_mut(&id)?;
    if let Some(v) = req.online { c.online = v; }
    if let Some(v) = req.contactless { c.contactless = v; }
    if let Some(v) = req.international { c.international = v; }
    if let Some(v) = req.atm { c.atm = v; }
    Some(c.clone())
}

pub async fn limits(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<CardLimits> { repo.read().await.limits.get(&id).cloned() }

pub async fn update_limits(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid, req: UpdateLimitsRequest) -> Option<CardLimits> {
    let mut r = repo.write().await;
    let l = r.limits.get_mut(&id)?;
    if let Some(v) = req.daily_purchase { l.daily_purchase = v; }
    if let Some(v) = req.daily_atm { l.daily_atm = v; }
    if let Some(v) = req.contactless { l.contactless = v; }
    Some(l.clone())
}

pub async fn statements(repo: &Arc<RwLock<RepositoryStore>>) -> Vec<Statement> { repo.read().await.statements.clone() }
pub async fn statement(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<Statement> { repo.read().await.statements.iter().find(|s| s.id == id).cloned() }
pub async fn credit(repo: &Arc<RwLock<RepositoryStore>>) -> CreditSummary { repo.read().await.credit.clone() }
pub async fn bills(repo: &Arc<RwLock<RepositoryStore>>) -> Vec<Bill> { repo.read().await.bills.values().cloned().collect() }
pub async fn bill(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<Bill> { repo.read().await.bills.get(&id).cloned() }

pub async fn pay_bill(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid, req: PayBillRequest) -> Result<Bill, String> {
    if req.amount <= 0 { return Err("amount must be greater than zero".into()); }
    if req.idempotency_key.trim().is_empty() { return Err("idempotency_key is required".into()); }
    let mut r = repo.write().await;
    if r.used_idempotency_keys.contains(&req.idempotency_key) { return Err("duplicate idempotency_key".into()); }
    let b = r.bills.get_mut(&id).ok_or_else(|| "bill not found".to_string())?;
    let result = b.clone();
    if b.status == "PAID" { return Err("bill already paid".into()); }
    if req.amount > b.amount { return Err("payment exceeds bill amount".into()); }
    b.status = if req.amount == b.amount { "PAID".into() } else { "PARTIALLY_PAID".into() };
    r.used_idempotency_keys.insert(req.idempotency_key);
    Ok(result)
}

pub async fn reveal(repo: &Arc<RwLock<RepositoryStore>>, id: Uuid) -> Option<String> {
    let r = repo.read().await;
    let c = r.cards.get(&id)?;
    // Demo only. Production should return a short-lived token and fetch PAN from an HSM-backed vault.
    Some(c.pan.clone())
}
