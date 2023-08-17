use crate::games::dto::PlayerDto;
use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct GameDto {
    pub id: Uuid,
    pub players: Vec<PlayerDto>,
}
