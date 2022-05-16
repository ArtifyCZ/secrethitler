use std::str::FromStr;
use actix_web::{HttpResponse, web};
use actix_web::http::StatusCode;
use uuid::Uuid;
use serde::{Deserialize, Serialize};
use crate::app::auth::session::Session;
use crate::AuthService;

#[derive(Deserialize, Serialize)]
pub struct CheckSessionResModel {
    pub id: String
}

pub async fn check_session(auth: AuthService, session: Session) -> HttpResponse {
    HttpResponse::Ok()
        .json(CheckSessionResModel {
            id: session.uuid().to_string()
        })
}
