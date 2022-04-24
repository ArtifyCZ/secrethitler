use crate::app::slot::slot_service::SlotService;
use crate::app::user::identity::Identity;

pub struct GraphQLContext {
    pub slots: SlotService,
    pub identity: Identity
}

impl juniper::Context for GraphQLContext {}

impl GraphQLContext {
    pub fn new(slots: SlotService, identity: Identity) -> Self {
        Self {
            slots,
            identity
        }
    }
}
