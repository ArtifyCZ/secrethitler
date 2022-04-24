use std::str::FromStr;
use juniper::{FieldError, FieldResult, graphql_object, graphql_value, GraphQLObject, Value};
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::object::slot::Slot;

pub struct Query;
#[graphql_object(context = GraphQLContext)]
impl Query {
    fn hello(&self) -> &'static str {
        "Hello world!"
    }

    fn find_slot(&self, context: &GraphQLContext, uuid: String) -> FieldResult<Slot> {
        if let Ok(uuid) = Uuid::from_str(uuid.as_str()) {
            if let Ok(slot) = context.slots.find(&uuid) {
                if let Ok(slot) = Slot::from_domain(slot) {
                    return Ok(slot);
                }
            }

            return Err(FieldError::new(
                "Failed to find the slot.",
                graphql_value!({
                    "uuid": (uuid.to_string())
                })
            ));
        }

        Err(FieldError::new(
            "Invalid string as uuid.",
            graphql_value!({
                "string": uuid
            })
        ))
    }
}
