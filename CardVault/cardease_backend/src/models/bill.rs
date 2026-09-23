use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Bill {
    pub id: Uuid,
    pub biller: String,
    pub category: String,
    pub amount: i64,
    pub due_date: String,
    pub status: String,
}

#[derive(Debug, Deserialize)]
pub struct PayBillRequest {
    pub amount: i64,
    pub idempotency_key: String,
}
