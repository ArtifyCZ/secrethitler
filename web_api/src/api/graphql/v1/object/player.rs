use juniper::graphql_object;
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;

#[derive(Clone)]
pub struct Player {
    uuid: Uuid,
    nickname: String
}

impl Player {
    pub fn from_user(user: &crate::app::user::user::User) -> Self {
        Self {
            uuid: user.uuid(),
            nickname: user.username()
        }
    }
}

#[graphql_object(context = GraphQLContext)]
impl Player {
    fn uuid(&self) -> String {
        self.uuid.to_string()
    }

    fn nickname(&self) -> String {
        self.nickname.clone()
    }
}
