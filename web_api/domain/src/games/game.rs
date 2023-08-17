use crate::games::{Player, State};
use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct Game {
    id: Uuid,
    state: State,
}

impl Game {
    pub fn create(players: Vec<Player>) -> Self {
        Self {
            id: Uuid::new_v4(),
            state: State::WaitingForPlayers { players },
        }
    }

    pub fn id(&self) -> Uuid {
        self.id
    }
}

#[cfg(feature = "dto")]
mod dto {
    use super::*;
    use crate::games::dto::{GameDto, PlayerDto};

    impl From<GameDto> for Game {
        fn from(game: GameDto) -> Self {
            Self {
                id: game.id,
                state: State::WaitingForPlayers {
                    // TODO:
                    players: game.players.into_iter().map(PlayerDto::into).collect(),
                },
            }
        }
    }

    impl From<Game> for GameDto {
        fn from(game: Game) -> Self {
            Self {
                id: game.id,
                players: match game.state {
                    State::WaitingForPlayers { players } => {
                        players.into_iter().map(Player::into).collect()
                    }
                    State::Running => todo!(),
                    State::Finished => todo!(),
                },
            }
        }
    }
}
