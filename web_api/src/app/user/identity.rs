use std::str::FromStr;
use actix_web::{FromRequest, HttpMessage, HttpRequest};
use actix_web::dev::Payload;
use futures::future::{err, ok};
use uuid::Uuid;
use crate::app::auth::session::Session;
use crate::app::user::user::User;
use crate::AuthService;

pub struct Identity {
    user: User
}

impl Identity {
    pub fn from_user(user: User) -> Self {
        Self {
            user
        }
    }

    pub fn uuid(&self) -> Uuid {
        self.user.uuid()
    }

    pub fn username(&self) -> String {
        self.user.username()
    }

    pub fn user(&self) -> User {
        self.user.clone()
    }
}

enum FromRequestIdentityError {
    CouldNotRetrieveAuthService,
    InvalidToken,
    Unauthorized
}

fn retrieve_identity(req: &HttpRequest, payload: &mut Payload) -> Result<Identity, FromRequestIdentityError> {
    if let Some(auth) = req.extensions_mut().get::<AuthService>() {
        let token = req.headers().get("Authorization")
            .ok_or(FromRequestIdentityError::InvalidToken)?
            .to_str().map_err(|_| FromRequestIdentityError::InvalidToken)?;

        let token = Uuid::from_str(token)
            .map_err(|_| FromRequestIdentityError::InvalidToken)?;

        let session = auth.get_session(token)
            .map_err(|_| FromRequestIdentityError::Unauthorized)?;

        return Ok(session.identity());
    }

    Err(FromRequestIdentityError::CouldNotRetrieveAuthService)
}

impl FromRequest for Identity {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        match retrieve_identity(req, payload) {
            Ok(res) => ok(res),
            Err(error) => match error {
                FromRequestIdentityError::CouldNotRetrieveAuthService => {
                    err(
                        actix_web::error::ErrorInternalServerError(
                            "Failed to retrieve the authentication service."
                        )
                    )
                }
                FromRequestIdentityError::InvalidToken => {
                    err(
                        actix_web::error::ErrorBadRequest(
                            "Invalid or missing token header `Authorization`."
                        )
                    )
                }
                FromRequestIdentityError::Unauthorized => {
                    err(
                        actix_web::error::ErrorUnauthorized(
                            "Token unauthorized."
                        )
                    )
                }
            }
        }
    }
}
