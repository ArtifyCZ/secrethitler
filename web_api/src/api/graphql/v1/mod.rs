use actix_web::{Error, HttpRequest};
use actix_web::HttpResponse;
use actix_web::Scope;
use actix_web::web::{Data, get, Payload, post, resource};
use juniper::{graphql_object, EmptyMutation, EmptySubscription, GraphQLObject, RootNode};
use juniper_actix::graphql_handler;
use crate::api::graphql::v1::hello::Hello;

mod hello;

pub struct GraphQLContext();

impl juniper::Context for GraphQLContext {}

pub struct Query;
#[graphql_object(context = GraphQLContext)]
impl Query {
    fn hello() -> Hello {
        Hello
    }
}

pub type Schema = RootNode<'static, Query, EmptyMutation<GraphQLContext>, EmptySubscription<GraphQLContext>>;

pub fn schema() -> Schema {
    Schema::new(
        Query,
        EmptyMutation::<GraphQLContext>::new(),
        EmptySubscription::<GraphQLContext>::new()
    )
}

async fn graphql_api_endpoint(
    req: HttpRequest,
    payload: Payload,
    schema: Data<Schema>,
) -> Result<HttpResponse, Error> {
    let context = GraphQLContext();
    println!("Hello from GraphQL.");
    graphql_handler(&schema, &context, req, payload).await
}

pub fn graphql_api_scope(scope: Scope) -> Scope {
    scope
        .app_data(Data::new(schema()))
        .route("", get().to(graphql_api_endpoint))
        .route("", post().to(graphql_api_endpoint))
}
