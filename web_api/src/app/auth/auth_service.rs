use std::borrow::BorrowMut;
use std::collections::HashMap;
use std::rc::Rc;
use std::sync::{Arc, LockResult, RwLock};
use actix_web::{FromRequest, HttpMessage, HttpRequest};
use actix_web::dev::Payload;
use futures::future::{err, ok};
use uuid::Uuid;
use crate::app::auth::session::Session;

pub struct AuthService {
    data: Arc<RwLock<AuthServiceInner>>
}

struct AuthServiceInner {
    sessions: HashMap<Uuid, Session>, // TOKEN - SESSION
    usernames: HashMap<String, Uuid>, // USERNAME - TOKEN
}

impl AuthService {
    pub fn new() -> AuthService {
        AuthService {
            data: Arc::new(
                RwLock::new(
                    AuthServiceInner {
                        sessions: HashMap::new(),
                        usernames: HashMap::new(),
                    }
                )
            )
        }
    }

    /// TODO: Implement error returning in get_session.
    pub fn get_session(&self, token: Uuid) -> Option<Session> {
        match self.data.read() {
            Ok(data) => {
                data.sessions.get(&token).cloned()
            },
            Err(_) => None
        }
    }

    /// TODO: Implement error handling for anonymous logging in.
    /// Returns a new session and it's token.
    pub fn login_anonymous(&self, username: String) -> Result<(Session, Uuid), ()> {
        // match (self.data.sessions.write(), self.data.usernames.write()) {
        match self.data.write() {
            Ok(mut data) => {
                if data.usernames.contains_key(&username) {
                    //TODO: Implement returning an error - username already in use.
                    return Err(())
                }

                let uuid = Uuid::new_v4();
                let token = Uuid::new_v4();

                let session = Session::new(uuid, username.clone(), token);

                data.usernames.insert(username, token);
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
                if !data.sessions.contains_key(&token) {
                    return Err(());
                }

                let session = data.sessions.get(&token).ok_or(())?.clone();

                data.sessions.remove(&token).ok_or(())?;
                data.usernames.remove(&session.username()).ok_or(())?;

                Ok(session)
            },
            _ => Err(())
        }
    }
}

impl Clone for AuthService {
    fn clone(&self) -> Self {
        Self {
            data: self.data.clone()
        }
    }
}

impl FromRequest for AuthService {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        if let Some(service) = req.extensions_mut().get::<AuthService>() {
            return ok(service.clone());
        }

        // TODO: Write logging the error - couldn't find the AuthService from the extensions.
        err((actix_web::error::ErrorInternalServerError("Failed to retrieve the authentication service.")))
    }
}
