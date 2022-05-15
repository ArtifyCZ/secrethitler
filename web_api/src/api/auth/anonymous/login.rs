use actix_web::{Error, HttpResponse, Responder, web};
use actix_web::body::BoxBody;
use crate::AuthService;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Deserialize, Serialize)]
pub struct LoginAnonymousReqModel {
    pub username: String,
}

#[derive(Deserialize, Serialize)]
pub struct LoginAnonymousResModel {
    id: String,
    nickname: String,
    token: String,
}

pub async fn login_anonymous(auth: AuthService, evt: web::Json<LoginAnonymousReqModel>) -> HttpResponse {
    match auth.login_anonymous(evt.username.clone()) {
        Ok((session, token)) => {
                HttpResponse::Ok()
                    .json(LoginAnonymousResModel {
                        id: session.uuid().to_string(),
                        nickname: session.username(),
                        token: token.to_string(),
                    })
        }
        Err(_) => {
            HttpResponse::Unauthorized()
                .reason("There is already an user with this username.") // It is not always this error.
                .finish()
        }
    }
}
