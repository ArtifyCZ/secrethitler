use std::str::FromStr;
use std::sync::Arc;
use actix_web::dev::Payload;
use actix_web::{FromRequest, HttpMessage, HttpRequest};
use futures::future::ready;
use uuid::Uuid;
use crate::app::user::user::{User, UserType};
use crate::AuthService;

#[derive(Clone)]
pub struct Session {
    data: Arc<SessionInner>
}

struct SessionInner {
    user: User,
    token: Uuid
}

impl Session {
    pub fn user(&self) -> User {
        self.data.user.clone()
    }

    /// Returns the uuid of the user.
    pub fn uuid(&self) -> Uuid {
        self.data.user.uuid()
    }

    pub fn token(&self) -> Uuid {
        self.data.token
    }

    pub fn user_type(&self) -> UserType {
        self.data.user.u_type()
    }

    pub fn username(&self) -> String {
        self.data.user.username()
    }

    pub fn is_token(&self, token: Uuid) -> bool {
        self.data.token == token
    }

    pub fn new(user: User, token: Uuid) -> Self {
        Self {
            data: Arc::new(SessionInner {
                user,
                token
            })
        }
    }
}
pub fn session_from_req(req: &HttpRequest, payload: &mut Payload) -> Result<Session, actix_web::error::Error> {
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
    let session = auth.get_session(&token).map_err(|_| unauthorized_err())?;
    Ok(session)
}

impl FromRequest for Session {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        ready(session_from_req(req, payload))
    }
}
