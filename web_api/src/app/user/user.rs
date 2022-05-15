use std::str::FromStr;
use std::sync::Arc;
use actix_web::{FromRequest, HttpMessage, HttpRequest};
use actix_web::dev::Payload;
use futures::future::{ok, ready};
use uuid::Uuid;
use crate::AuthService;

#[derive(Clone)]
pub struct User {
    data: Arc<UserInner>
}

#[derive(Clone, PartialEq)]
pub enum UserType {
    Temp
}

struct UserInner {
    uuid: Uuid,
    u_type: UserType,
    username: String
}

impl User {
    pub fn new(uuid: Uuid, user_type: UserType, username: String) -> Self {
        Self {
            data: Arc::new(UserInner {
                uuid,
                u_type: user_type,
                username
            })
        }
    }

    pub fn uuid(&self) -> Uuid {
        self.data.uuid
    }

    pub fn username(&self) -> String {
        self.data.username.clone()
    }

    pub fn u_type(&self) -> UserType {
        self.data.u_type.clone()
    }
}

fn user_from_req(req: &HttpRequest, payload: &mut Payload) -> Result<User, actix_web::error::Error> {
    fn invalid_token_err() -> actix_web::error::Error {
        actix_web::error::ErrorBadRequest(
            "Invalid or missing token header `Authorization`."
        )}
    fn internal_err() -> actix_web::error::Error {
        actix_web::error::ErrorInternalServerError("")}
    fn unauthorized_err() -> actix_web::error::Error {
        actix_web::error::ErrorUnauthorized("Token not found.")}

    let extensions = req.extensions_mut();
    let auth = extensions.get::<AuthService>()
        .ok_or(internal_err())?;
    let token = req.headers().get("Authorization").ok_or(invalid_token_err())?
        .to_str().map_err(|_| invalid_token_err())?;
    let token = Uuid::from_str(token).map_err(|_| invalid_token_err())?;
    let session = auth.get_session(token).map_err(|_| unauthorized_err())?;
    Ok(session.user())
}

impl FromRequest for User {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        ready(user_from_req(req, payload))
    }
}
