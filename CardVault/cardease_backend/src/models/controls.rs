use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CardControls {
    pub online: bool,
    pub contactless: bool,
    pub international: bool,
    pub atm: bool,
}

#[derive(Debug, Deserialize)]
pub struct UpdateControlsRequest {
    pub online: Option<bool>,
    pub contactless: Option<bool>,
    pub international: Option<bool>,
    pub atm: Option<bool>,
}
