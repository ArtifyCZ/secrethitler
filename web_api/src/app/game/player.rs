use crate::app::user::user::User;

#[derive(Copy, Clone)]
pub enum GameRole {
    Liberal,
    Fascist,
    Hitler
}

#[derive(Copy, Clone)]
pub enum Party {
    Liberal,
    Fascist
}

impl Party {
    fn from_role(role: GameRole) -> Self {
        match role {
            GameRole::Liberal => Self::Liberal,
            GameRole::Fascist => Self::Fascist,
            GameRole::Hitler => Self::Fascist
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

    pub fn user(&self) -> User {
        self.user.clone()
    }

    pub fn role(&self) -> GameRole {
        self.role
    }

    pub fn party(&self) -> Party {
        self.party
    }
}
