use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use sea_orm::DatabaseConnection;
use serde_json::{json, Value};
use app_contract::auth::*;

pub async fn create_anonymous_account<AS>(Json(payload): Json<CreateAnonymousAccountInputDto>,
                                        State(database): State<DatabaseConnection>,
        ) -> (StatusCode, Json<Value>)
        where
            AS: 'static + AuthService {
    let auth: AS = database.into();
    match auth.create_anonymous_account(payload).await {
        Ok(out) => (StatusCode::CREATED, Json(json!(out))),
        Err(error) => match error {
            CreateAnonymousAccountError::UsernameAlreadyInUse(username) => {
                (StatusCode::CONFLICT, Json(json!({
                    "status": 409,
                    "message": format!("Username `{}` already in use", username),
                })))
            },
            error => {
                println!("ERROR: {}", error);
                (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({
                    "status": 500,
                    "message": "Internal server error",
                })))
            },
        }
    }
}
