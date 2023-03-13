use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use sea_orm::DatabaseConnection;
use serde_json::{json, Value};
use app_contract::auth::*;

pub async fn create_anonymous_account<'a, AS>(Json(payload): Json<CreateAnonymousAccountInputDto>,
                                        State(database): State<&'a DatabaseConnection>,
        ) -> Result<Json<CreateAnonymousAccountOutputDto>, (StatusCode, Value)>
        where
            AS: 'static + AuthService<'a> {
    let auth: AS = database.into();
    auth.create_anonymous_account(payload).await
        .map(Json)
        .map_err(|error| match error {
            CreateAnonymousAccountError::UsernameAlreadyInUse(username) => {
                (StatusCode::CONFLICT, json!({
                    "status": 409,
                    "message": format!("Username `{}` already in use", username),
                }))
            },
            error => {
                println!("ERROR: {}", error);
                (StatusCode::INTERNAL_SERVER_ERROR, json!({
                    "status": 500,
                    "message": "Internal server error",
                }))
            },
        })
}
