use std::{str::FromStr, sync::Arc};
use actix_web::{FromRequest, HttpMessage, HttpRequest, dev::Payload};
use futures::future::ready;
use uuid::Uuid;
use crate::{app::user::user::{User, UserType}, AuthService};

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

    pub fn new(user: User, token: Uuid) -> Self {
        Self {
            data: Arc::new(SessionInner {
                user,
                token
            })
        }
    }
}
pub fn session_from_req(req: &HttpRequest) -> Result<Session, actix_web::error::Error> {
    fn missing_token_err() -> actix_web::error::Error {
        actix_web::error::ErrorUnauthorized("Missing token header `Authorization`")}
    fn invalid_token_err() -> actix_web::error::Error {
        actix_web::error::ErrorBadRequest("Invalid token")}
    fn internal_err() -> actix_web::error::Error {
        actix_web::error::ErrorInternalServerError("")}
    fn token_not_found_err() -> actix_web::error::Error {
        actix_web::error::ErrorForbidden("Token not found")}

    let token: &str = req.headers().get("Authorization").ok_or(missing_token_err())?
        .to_str().map_err(|_| invalid_token_err())?;
    let token = Uuid::from_str(token).map_err(|_| invalid_token_err())?;

    let extensions = req.extensions_mut();
    let auth = extensions.get::<AuthService>()
        .ok_or(internal_err())?;
    let session = auth.get_session(&token).map_err(|_| token_not_found_err())?;
    Ok(session)
}

impl FromRequest for Session {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        ready(session_from_req(req))
    }
}
