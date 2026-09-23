use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CardLimits {
    pub daily_purchase: i64,
    pub daily_atm: i64,
    pub contactless: i64,
}

#[derive(Debug, Deserialize)]
pub struct UpdateLimitsRequest {
    pub daily_purchase: Option<i64>,
    pub daily_atm: Option<i64>,
    pub contactless: Option<i64>,
}
