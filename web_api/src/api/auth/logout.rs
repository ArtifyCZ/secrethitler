use actix_web::{HttpResponse, http::StatusCode};
use crate::{AuthService, app::auth::session::Session};

pub async fn logout(auth: AuthService, session: Session) -> HttpResponse {
    match auth.logout(session.token()) {
        Ok(_) => HttpResponse::new(StatusCode::NO_CONTENT),
        Err(_) => HttpResponse::new(StatusCode::UNAUTHORIZED)
    }
}
