use std::borrow::Borrow;
use std::collections::HashMap;
use std::sync::{Arc, RwLock};
use actix_web::{FromRequest, HttpMessage, HttpRequest};
use actix_web::dev::Payload;
use futures::future::{err, ok};
use uuid::Uuid;
use crate::app::auth::session::Session;
use crate::app::user::user::UserType;
use crate::app::user::user_service::UserService;

#[derive(Clone)]
pub struct AuthService {
    data: Arc<RwLock<AuthServiceInner>>,
    users: UserService
}

struct AuthServiceInner {
    sessions: HashMap<Uuid, Session>, // TOKEN - SESSION
}

impl AuthService {
    pub fn new(users: UserService) -> AuthService {
        AuthService {
            data: Arc::new(
                RwLock::new(
                    AuthServiceInner {
                        sessions: HashMap::new()
                    }
                )
            ),
            users
        }
    }

    /// TODO: Implement error returning in get_session.
    pub fn get_session(&self, token: &Uuid) -> Result<Session, ()> {
        match self.data.read() {
            Ok(data) => {
                data.sessions.get(token).cloned()
                    .ok_or(())
            },
            Err(_) => Err(())
        }
    }

    /// TODO: Implement error handling for anonymous logging in.
    /// Returns a new session and it's token.
    pub fn login_anonymous(&self, username: String) -> Result<(Session, Uuid), ()> {
        match self.data.write() {
            Ok(mut data) => {
                let user = self.users.create(username, UserType::Temp)?;
                let token = Uuid::new_v4();

                let session = Session::new(user, token);

                // There is so low chance for collision with tokens that we can ignore it.
                data.sessions.insert(token, session.clone());

                Ok((session, token))
            },
            _ => Err(())
        }
    }

    /// TODO: Implement error handling for anonymous logging out.
    /// TODO: Implement returning specific errors.
    /// Logs out a session by it's id and returns it.
    pub fn logout(&self, token: Uuid) -> Result<Session, ()> {
        match self.data.write() {
            Ok(mut data) => {
                let session = data.sessions.remove(&token).ok_or(())?;

                if session.user_type() == UserType::Temp {
                    self.users.delete(session.uuid())?;
                }

                Ok(session)
            },
            _ => Err(())
        }
    }
}

impl FromRequest for AuthService {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, _: &mut Payload) -> Self::Future {
        if let Some(service) = req.extensions_mut().get::<AuthService>() {
            return ok(service.clone());
        }

        // TODO: Write logging the error - couldn't find the AuthService from the extensions.
        err((actix_web::error::ErrorInternalServerError("Failed to retrieve the authentication service.")))
    }
}
