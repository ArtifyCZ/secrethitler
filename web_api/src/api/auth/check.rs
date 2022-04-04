use std::str::FromStr;
use actix_web::{HttpResponse, web};
use actix_web::http::StatusCode;
use uuid::Uuid;
use serde::{Deserialize, Serialize};
use crate::AuthService;

#[derive(Deserialize, Serialize)]
pub struct CheckSessionReqModel {
    pub token: String
}

#[derive(Deserialize, Serialize)]
pub struct CheckSessionResModel {
    pub id: String
}

pub async fn check_session(auth: AuthService, evt: web::Json<CheckSessionReqModel>) -> HttpResponse {
    let token_str = evt.token.as_str();

    if let Ok(token) = Uuid::from_str(token_str) {
        match auth.get_session(token) {
            Some(session) => {
                HttpResponse::Ok()
                    .json(CheckSessionResModel {
                        id: session.uuid().to_string()
                    })
            },
            None => HttpResponse::new(StatusCode::UNAUTHORIZED)
        }
    } else {
        HttpResponse::new(StatusCode::BAD_REQUEST)
    }
}