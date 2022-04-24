use std::str::FromStr;
use actix_web::{Error, HttpResponse, Responder, web};
use actix_web::body::BoxBody;
use actix_web::http::StatusCode;
use crate::AuthService;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Deserialize, Serialize)]
pub struct LogoutReqModel {
    pub token: String,
}

pub async fn logout(auth: AuthService, evt: web::Json<LogoutReqModel>) -> HttpResponse {
    let token_str = evt.token.as_str();

    if let Ok(token) = Uuid::from_str(token_str) {
        match auth.logout(token) {
            Ok(_) => HttpResponse::new(StatusCode::NO_CONTENT),
            Err(_) => HttpResponse::new(StatusCode::UNAUTHORIZED)
        }
    } else {
        HttpResponse::new(StatusCode::BAD_REQUEST)
    }
}
