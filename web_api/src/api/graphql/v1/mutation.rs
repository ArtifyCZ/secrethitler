use std::str::FromStr;
use juniper::{FieldError, FieldResult, graphql_object, graphql_value, GraphQLObject, Value};
use juniper::Selection::Field;
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::object::slot::Slot;

fn uuid_parse_err() -> FieldError {
    FieldError::new(
        "Invalid uuid.",
        Value::Null
    )
}

fn slot_not_found_err(uuid: Uuid) -> FieldError {
    FieldError::new(
        "Slot not found.",
        graphql_value!({
                    "uuid": (uuid.to_string())
                })
    )
}

pub struct Mutation;
#[graphql_object(context = GraphQLContext)]
impl Mutation {
    pub fn create_slot(&self, context: &GraphQLContext, players: i32) -> FieldResult<Slot> {
        fn create_slot_err() -> FieldError {
            FieldError::new(
                "Failed to create a slot.",
                Value::Null
            )
        };
        match players {
            5..=10 => {
                let slot = context.slots.create_slot(&context.identity, players as u8)
                    .map_err(|_| create_slot_err())?;
                slot.add_player(context.identity.user()).map_err(|_| create_slot_err())?;
                let res = Slot::from_domain(slot).map_err(|_| create_slot_err())?;
                Ok(res)
            },
            _ => {
                Err(FieldError::new(
                    "Invalid players count. Must be in range 5..=10.",
                    graphql_value!({
                        "players": players
                    })))
            }
        }
    }

    pub fn start_game(&self, context: &GraphQLContext, uuid: String) -> FieldResult<Slot> {
        fn start_err(uuid: Uuid) -> FieldError {
            FieldError::new(
                "Failed to start game.",
                graphql_value!({
                        "uuid": (uuid.to_string())
                }))};

        let uuid = Uuid::from_str(uuid.as_str()).map_err(|_| uuid_parse_err())?;
        let slot = context.slots.find(&uuid).map_err(|_| slot_not_found_err(uuid))?;
        slot.start_game().map_err(|_| start_err(uuid))?;
        let res = Slot::from_domain(slot).map_err(|_| start_err(uuid))?;
        Ok(res)
    }

    pub fn join_slot(&self, context: &GraphQLContext, uuid: String) -> FieldResult<Slot> {
        fn failed_to_join(uuid: Uuid) -> FieldError {
            FieldError::new(
                "Failed to join.",
                graphql_value!({
                    "uuid": (uuid.to_string())
                }))};

        let uuid = Uuid::from_str(uuid.as_str()).map_err(|_| uuid_parse_err())?;
        let slot = context.slots.find(&uuid).map_err(|_| slot_not_found_err(uuid))?;
        slot.add_player(context.identity.user()).map_err(|_| failed_to_join(uuid))?;
        let res = Slot::from_domain(slot).map_err(|_| failed_to_join(uuid))?;
        Ok(res)
    }
}
