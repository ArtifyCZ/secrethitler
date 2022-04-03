use std::sync::Arc;
use uuid::Uuid;

pub struct Session {
    data: Arc<SessionInner>
}

struct SessionInner {
    uuid: Uuid,
    username: String,
    token: Uuid
}

impl Session {
    pub fn uuid(&self) -> Uuid {
        self.data.uuid
    }

    pub fn username(&self) -> String {
        self.data.username.clone()
    }

    pub fn is_token(&self, token: Uuid) -> bool {
        self.data.token == token
    }

    pub fn new(uuid: Uuid, username: String, token: Uuid) -> Self {
        Self {
            data: Arc::new(SessionInner {
                uuid,
                username,
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
