use std::{str::FromStr, sync::Arc};
use actix_web::{Error, FromRequest, HttpMessage, HttpRequest, dev::Payload};
use futures::future::{ok, ready};
use uuid::Uuid;
use crate::{AuthService, app::auth::session::{Session, session_from_req}};

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

impl PartialEq for User {
    fn eq(&self, other: &Self) -> bool {
        self.data.uuid == other.data.uuid
    }
}

impl FromRequest for User {
    type Error = actix_web::error::Error;
    type Future = futures::future::Ready<Result<Self, Self::Error>>;

    fn from_request(req: &HttpRequest, payload: &mut Payload) -> Self::Future {
        ready(match session_from_req(req, payload) {
            Ok(session) => Ok(session.user()),
            Err(err) => Err(err)
        })
    }
}
