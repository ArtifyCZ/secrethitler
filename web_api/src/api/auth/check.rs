use actix_web::HttpResponse;
use serde::{Deserialize, Serialize};
use crate::app::auth::session::Session;

#[derive(Deserialize, Serialize)]
pub struct CheckSessionResModel {
    pub id: String
}

pub async fn check_session(session: Session) -> HttpResponse {
    HttpResponse::Ok()
        .json(CheckSessionResModel {
            id: session.uuid().to_string()
        })
}
