use std::sync::Arc;
use uuid::Uuid;
use crate::app::user::identity::Identity;
use crate::app::user::user::{User, UserType};

pub struct Session {
    data: Arc<SessionInner>
}

struct SessionInner {
    user: User,
    token: Uuid
}

impl Session {
    pub fn identity(&self) -> Identity {
        Identity::from_user(self.data.user.clone())
    }

    /// Returns the uuid of the user.
    pub fn uuid(&self) -> Uuid {
        self.data.user.uuid()
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

impl Clone for Session {
    fn clone(&self) -> Self {
        Self {
            data: self.data.clone()
        }
    }
}
