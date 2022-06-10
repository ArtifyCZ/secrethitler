use std::{collections::HashMap, sync::{Arc, RwLock}};
use uuid::Uuid;
use crate::app::user::user::{User, UserType};

#[derive(Clone)]
pub struct UserService {
    data: Arc<RwLock<UserServiceInner>>
}

struct UserServiceInner {
    users: HashMap<Uuid, User>, // User ID - Identity
    usernames: HashMap<String, Uuid> // Username - User ID
}

impl UserService {
    pub fn new() -> Self {
        Self {
            data: Arc::new(
                RwLock::new(
                    UserServiceInner {
                        users: HashMap::new(),
                        usernames: HashMap::new()
                    }
                )
            )
        }
    }

    ///TODO: Implement error handling for creating new users.
    pub fn create(&self, username: String, u_type: UserType) -> Result<User, ()> {
        match self.data.write() {
            Ok(mut data) => {
                if data.usernames.contains_key(&username) {
                    return Err(())
                }

                let uuid = Uuid::new_v4();

                let user = User::new(uuid.clone(), u_type, username.clone());

                if let Some(_uuid) = data.usernames.insert(username, uuid.clone()) {
                    return Err(()); // An user with the username exists.
                }

                // There is so low chance to uuid's collision that we can just ignore it.
                data.users.insert(uuid, user.clone());

                Ok(user)
            },
            Err(_) => Err(())
        }
    }

    ///TODO: Implement error handling.
    pub fn delete(&self, uuid: Uuid) -> Result<User, ()> {
        match self.data.write() {
            Ok(mut data) => {
                let user = data.users.remove(&uuid).ok_or(())?;
                data.usernames.remove(&user.username()).ok_or(())?;

                Ok(user)
            },
            Err(_) => Err(())
        }
    }
}
