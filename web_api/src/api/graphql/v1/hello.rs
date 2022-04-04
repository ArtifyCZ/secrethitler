use juniper::{graphql_object, GraphQLObject};
use crate::api::graphql::v1::GraphQLContext;

pub struct Hello;

#[graphql_object(context = GraphQLContext)]
impl Hello {
    fn world(&self) -> &'static str {
        "Hello world!"
    }

    pub fn new() -> Self {
        Self
    }
}
