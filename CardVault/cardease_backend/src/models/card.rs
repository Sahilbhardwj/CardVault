use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Card {
    pub id: Uuid,
    pub nickname: String,
    pub pan: String,
    pub holder_name: String,
    pub expiry_month: u8,
    pub expiry_year: u16,
    pub status: String,
    pub network: String,
}
