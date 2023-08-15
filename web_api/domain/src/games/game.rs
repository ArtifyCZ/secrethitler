use crate::games::{Player, State};
use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct Game {
    pub id: Uuid,
    pub state: State,
}

impl Game {
    pub fn create(players: Vec<Player>) -> Self {
        Self {
            id: Uuid::new_v4(),
            state: State::WaitingForPlayers { players },
        }
    }
}
