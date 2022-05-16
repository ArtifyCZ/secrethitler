use actix_web::{Error, HttpResponse, Responder, web};
use actix_web::http::StatusCode;
use crate::AuthService;
use uuid::Uuid;
use crate::app::auth::session::Session;

pub async fn logout(auth: AuthService, session: Session) -> HttpResponse {
    match auth.logout(session.token()) {
        Ok(_) => HttpResponse::new(StatusCode::NO_CONTENT),
        Err(_) => HttpResponse::new(StatusCode::UNAUTHORIZED)
    }
}
