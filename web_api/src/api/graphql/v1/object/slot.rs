use juniper::{graphql_object, GraphQLObject};
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;

pub struct Slot {
    uuid: Uuid,
    in_game: bool,
    //TODO: admin: Player
    //TODO: players: Vec<Player>
}

impl Slot {
    pub fn from_domain(slot: crate::app::slot::slot::Slot) -> Result<Self, ()> {
        Ok(
            Self {
                uuid: slot.uuid()?,
                in_game: slot.in_game()?
            }
        )
    }
}

#[graphql_object(context = GraphQLContext)]
impl Slot {
    fn uuid(&self) -> String {
        self.uuid.to_string()
    }

    fn in_game(&self) -> bool {
        self.in_game
    }

    //TODO: fn admin(&self) -> Player

    //TODO: fn players(&self) -> Vec<Player>
}
