use std::sync::Arc;
use axum::{extract::{Path, State}, http::StatusCode, Json};
use serde_json::json;
use uuid::Uuid;
use crate::{core::AppState, models::{api::{ApiResponse}, controls::UpdateControlsRequest, limits::UpdateLimitsRequest, bill::PayBillRequest}, services};

pub async fn health() -> Json<serde_json::Value> { Json(json!({"status":"ok","service":"cardvault-backend"})) }

fn not_found() -> (StatusCode, Json<serde_json::Value>) { (StatusCode::NOT_FOUND, Json(json!({"error":"resource not found"}))) }
fn bad_request(msg: String) -> (StatusCode, Json<serde_json::Value>) { (StatusCode::BAD_REQUEST, Json(json!({"error":msg}))) }

pub async fn list_cards(State(s): State<Arc<AppState>>) -> Json<ApiResponse<Vec<crate::models::card::Card>>> { Json(ApiResponse { data: services::cards(&s.repo).await }) }
pub async fn get_card(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::card::Card>>, (StatusCode, Json<serde_json::Value>)> { services::card(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn block_card(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::card::Card>>, (StatusCode, Json<serde_json::Value>)> { services::block(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn reveal_card(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<serde_json::Value>, (StatusCode, Json<serde_json::Value>)> { services::reveal(&s.repo,id).await.map(|pan| Json(json!({"data":{"pan":pan,"expires_in_seconds":30}}))).ok_or_else(not_found) }

pub async fn get_controls(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::controls::CardControls>>, (StatusCode, Json<serde_json::Value>)> { services::controls(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn update_controls(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>, Json(req): Json<UpdateControlsRequest>) -> Result<Json<ApiResponse<crate::models::controls::CardControls>>, (StatusCode, Json<serde_json::Value>)> { services::update_controls(&s.repo,id,req).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn get_limits(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::limits::CardLimits>>, (StatusCode, Json<serde_json::Value>)> { services::limits(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn update_limits(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>, Json(req): Json<UpdateLimitsRequest>) -> Result<Json<ApiResponse<crate::models::limits::CardLimits>>, (StatusCode, Json<serde_json::Value>)> { services::update_limits(&s.repo,id,req).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }

pub async fn list_statements(State(s): State<Arc<AppState>>) -> Json<ApiResponse<Vec<crate::models::statement::Statement>>> { Json(ApiResponse{data:services::statements(&s.repo).await}) }
pub async fn get_statement(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::statement::Statement>>, (StatusCode, Json<serde_json::Value>)> { services::statement(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn credit_summary(State(s): State<Arc<AppState>>) -> Json<ApiResponse<crate::models::credit::CreditSummary>> { Json(ApiResponse{data:services::credit(&s.repo).await}) }
pub async fn list_bills(State(s): State<Arc<AppState>>) -> Json<ApiResponse<Vec<crate::models::bill::Bill>>> { Json(ApiResponse{data:services::bills(&s.repo).await}) }
pub async fn get_bill(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>) -> Result<Json<ApiResponse<crate::models::bill::Bill>>, (StatusCode, Json<serde_json::Value>)> { services::bill(&s.repo,id).await.map(|x| Json(ApiResponse{data:x})).ok_or_else(not_found) }
pub async fn pay_bill(State(s): State<Arc<AppState>>, Path(id): Path<Uuid>, Json(req): Json<PayBillRequest>) -> Result<Json<ApiResponse<crate::models::bill::Bill>>, (StatusCode, Json<serde_json::Value>)> { services::pay_bill(&s.repo,id,req).await.map(|x| Json(ApiResponse{data:x})).map_err(bad_request) }
