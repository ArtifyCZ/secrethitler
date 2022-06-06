use crate::api::graphql::v1::object::round::Round;
use uuid::Uuid;
use std::pin::Pin;
use crate::api::graphql::v1::context::GraphQLContext;
use juniper::{FieldError, FieldResult, graphql_subscription};

pub type GameStream = Pin<Box<dyn futures::Stream<Item = FieldResult<Round>> + Send>>;

pub struct Subscription;
#[graphql_subscription(context = GraphQLContext)]
impl Subscription {
    async fn game(&self, context: &GraphQLContext, uuid: String) -> GameStream {
        let stream = async_stream::stream! {
            loop {
                yield Ok(Round);
                break;
            }
        };
        Box::pin(stream)
    }
}
