use serde::Serialize;

#[derive(Debug, Serialize)]
pub struct ApiResponse<T> {
    pub data: T,
}

// #[derive(Debug, Serialize)]
// pub struct MessageResponse {
//     pub message: String,
// }
