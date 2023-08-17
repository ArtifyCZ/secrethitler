use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct Player {
    id: Uuid,
    name: String,
}

impl Player {
    pub fn create(name: String) -> Self {
        Self {
            id: Uuid::new_v4(),
            name,
        }
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn name(&self) -> &str {
        &self.name
    }
}

#[cfg(feature = "dto")]
mod dto {
    use super::*;
    use crate::games::dto::PlayerDto;

    impl From<PlayerDto> for Player {
        fn from(player: PlayerDto) -> Self {
            Self {
                id: player.id,
                name: player.name,
            }
        }
    }

    impl From<Player> for PlayerDto {
        fn from(player: Player) -> Self {
            Self {
                id: player.id,
                name: player.name,
            }
        }
    }
}
