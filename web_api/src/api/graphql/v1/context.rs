use crate::app::slot::slot_service::SlotService;
use crate::app::user::user::User;

pub struct GraphQLContext {
    pub slots: SlotService,
    pub user: User
}

impl juniper::Context for GraphQLContext {}

impl GraphQLContext {
    pub fn new(slots: SlotService, user: User) -> Self {
        Self {
            slots,
            user
        }
    }
}
