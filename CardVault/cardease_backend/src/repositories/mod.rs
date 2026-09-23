use std::collections::{HashMap, HashSet};
use uuid::Uuid;
use crate::{models::{card::Card, controls::CardControls, limits::CardLimits, statement::Statement, bill::Bill, credit::CreditSummary}, core::{default_controls, default_limits, default_credit}};

pub struct RepositoryStore {
    pub cards: HashMap<Uuid, Card>,
    pub controls: HashMap<Uuid, CardControls>,
    pub limits: HashMap<Uuid, CardLimits>,
    pub statements: Vec<Statement>,
    pub bills: HashMap<Uuid, Bill>,
    pub credit: CreditSummary,
    pub used_idempotency_keys: HashSet<String>,
}

impl RepositoryStore {
    pub fn seeded() -> Self {
        let card_id = Uuid::new_v4();
        let card = Card {
            id: card_id,
            nickname: "Primary Card".into(),
            pan: "4111111111111111".into(),
            holder_name: "Demo User".into(),
            expiry_month: 10,
            expiry_year: 2029,
            status: "ACTIVE".into(),
            network: "VISA".into(),
        };
        let statement = Statement {
            id: Uuid::new_v4(), month: "2026-09".into(), opening_balance: 18_000,
            purchases: 12_500, payments: 8_000, closing_balance: 22_500, due_date: "2026-10-05".into()
        };
        let bill = Bill {
            id: Uuid::new_v4(), biller: "Electricity Board".into(), category: "Utilities".into(),
            amount: 2_450, due_date: "2026-09-28".into(), status: "PENDING".into()
        };
        let mut controls = HashMap::new(); controls.insert(card_id, default_controls());
        let mut limits = HashMap::new(); limits.insert(card_id, default_limits());
        let mut cards = HashMap::new(); cards.insert(card_id, card);
        let mut bills = HashMap::new(); bills.insert(bill.id, bill);
        Self { cards, controls, limits, statements: vec![statement], bills, credit: default_credit(), used_idempotency_keys: HashSet::new() }
    }
}
