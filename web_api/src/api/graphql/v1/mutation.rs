use std::str::FromStr;
use juniper::{FieldError, FieldResult, graphql_object, graphql_value, GraphQLObject, Value};
use juniper::Selection::Field;
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::object::slot::Slot;

pub struct Mutation;
#[graphql_object(context = GraphQLContext)]
impl Mutation {
    pub fn create_slot(&self, context: &GraphQLContext, players: i32) -> FieldResult<Slot> {
        match players {
            5..=10 => {
                if let Ok(slot) = context.slots.create_slot(&context.identity, players as u8) {
                    if let Ok(()) = slot.add_player(context.identity.user()) {
                        if let Ok(slot) = Slot::from_domain(slot) {
                            return Ok(slot);
                        }
                    }
                }

                Err(FieldError::new(
                    "Failed to create a slot.",
                    Value::Null
                )
                )
            },
            _ => {
                Err(FieldError::new(
                    "Invalid players count. Must be in range 5..=10.",
                    graphql_value!({
                        "players": players
                    })
                ))
            }
        }
    }

    pub fn start_game(&self, context: &GraphQLContext, uuid: String) -> FieldResult<Slot> {
        if let Ok(uuid) = Uuid::from_str(uuid.as_str()) {
            if let Ok(slot) = context.slots.find(&uuid) {
                if let Ok(()) = slot.start_game() {
                    if let Ok(slot) = Slot::from_domain(slot) {
                        return Ok(slot);
                    }
                }

                return Err(FieldError::new(
                    "Failed to start game.",
                    graphql_value!({
                        "uuid": (uuid.to_string())
                    })
                ));
            }

            return Err(FieldError::new(
                "Slot not found.",
                graphql_value!({
                    "uuid": (uuid.to_string())
                })
            ));
        }

        Err(FieldError::new(
            "Invalid uuid.",
            Value::Null
        ))
    }

    // pub fn join_slot(&self, context: &GraphQLContext, uuid: String) -> FieldResult<()>
    pub fn join_slot(&self, context: &GraphQLContext, uuid: String) -> FieldResult<Slot> {
        if let Ok(uuid) = Uuid::from_str(uuid.as_str()) {
            if let Ok(slot) = context.slots.find(&uuid) {
                match slot.add_player(context.identity.user()) {
                    Ok(()) => {
                        if let Ok(slot) = Slot::from_domain(slot) {
                            return Ok(slot);
                        }

                        return Err(FieldError::new(
                            "Failed to join.",
                            Value::Null
                        ));
                    },
                    Err(()) => {}
                }
            }

            return Err(FieldError::new(
                "Slot not found.",
                graphql_value!({
                    "uuid": (uuid.to_string())
                })
            ));
        }

        Err(FieldError::new(
            "Invalid uuid.",
            Value::Null
        ))
    }
}
