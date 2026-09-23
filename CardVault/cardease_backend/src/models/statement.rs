use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Statement {
    pub id: Uuid,
    pub month: String,
    pub opening_balance: i64,
    pub purchases: i64,
    pub payments: i64,
    pub closing_balance: i64,
    pub due_date: String,
}
