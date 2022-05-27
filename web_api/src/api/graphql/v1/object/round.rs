use juniper::{FieldError, FieldResult, graphql_object};
use crate::api::graphql::v1::context::GraphQLContext;

pub struct Round;
#[graphql_object(context = GraphQLContext)]
impl Round {
    fn hello(&self) -> &'static str {
        "world"
    }
}
