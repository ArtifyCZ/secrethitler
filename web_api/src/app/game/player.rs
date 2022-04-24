use crate::app::user::identity::Identity;
use crate::app::user::user::User;

#[derive(Copy, Clone)]
pub enum GameRole {
    Liberalist,
    Fasict,
    Hitler
}

#[derive(Copy, Clone)]
pub enum Party {
    Liberalist,
    Facist
}

impl Party {
    fn from_role(role: GameRole) -> Self {
        match role {
            GameRole::Liberalist => Self::Liberalist,
            GameRole::Fasict => Self::Facist,
            GameRole::Hitler => Self::Facist
        }
    }
}

#[derive(Clone)]
pub struct Player {
    user: User,
    role: GameRole,
    party: Party,
    alive: bool
}

impl Player {
    pub fn new(user: User, role: GameRole) -> Self {
        Self {
            user,
            role,
            party: Party::from_role(role),
            alive: true
        }
    }

    pub fn identity(&self) -> Identity {
        Identity::from_user(self.user.clone())
    }

    pub fn role(&self) -> GameRole {
        self.role
    }

    pub fn party(&self) -> Party {
        self.party
    }
}
