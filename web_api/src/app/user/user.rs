use std::sync::Arc;
use uuid::Uuid;

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

impl Clone for User {
    fn clone(&self) -> Self {
        Self {
            data: self.data.clone()
        }
    }
}
