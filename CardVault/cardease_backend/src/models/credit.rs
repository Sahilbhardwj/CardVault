use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreditSummary {
    pub credit_limit: i64,
    pub available_credit: i64,
    pub current_due: i64,
    pub minimum_due: i64,
    pub due_date: String,
    pub utilization_percent: f64,
}
