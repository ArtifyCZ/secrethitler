use juniper::graphql_object;
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::object::player::Player;

pub struct Slot {
    uuid: Uuid,
    in_game: bool,
    admin: Player,
    players: Vec<Player>
}

impl Slot {
    pub fn from_domain(slot: crate::app::slot::slot::Slot) -> Result<Self, ()> {
        Ok(
            Self {
                uuid: slot.uuid()?,
                in_game: slot.in_game()?,
                admin: Player::from_user(&slot.admin()?),
                players: slot.players()?.iter().map(|p| Player::from_user(p)).collect()
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

    fn admin(&self) -> Player {
        self.admin.clone()
    }

    fn players(&self) -> Vec<Player> {
        self.players.clone()
    }
}
