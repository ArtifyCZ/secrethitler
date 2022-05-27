use std::time::Duration;
use juniper::RootNode;
use actix_web::{Error, HttpRequest, HttpResponse, Scope, web::{ Data, get, Payload, post }};
use juniper_graphql_ws::ConnectionConfig;
use juniper_actix::{graphql_handler, subscriptions::subscriptions_handler};
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::mutation::Mutation;
use crate::api::graphql::v1::subscription::Subscription;
use crate::api::graphql::v1::query::Query;
//use crate::api::graphql::v1::websocket::websocket_gql_endpoint;
use crate::app::slot::slot_service::SlotService;
use crate::app::user::user::User;

mod query;
mod object;
mod context;
mod mutation;
mod subscription;
mod websocket;

pub type Schema = RootNode<'static, Query, Mutation, Subscription>;

pub fn schema() -> Schema {
    Schema::new(
        Query,
        Mutation,
        Subscription
    )
}

async fn graphql_api_endpoint(
    req: HttpRequest,
    payload: Payload,
    schema: Data<Schema>,
    slots: Data<SlotService>,
    user: User
) -> Result<HttpResponse, Error> {
    let context = GraphQLContext::new(slots.get_ref().clone(), user);
    graphql_handler(schema.get_ref(), &context, req, payload).await
}

async fn socket_gql_endpoint(
    req: HttpRequest,
    payload: Payload,
    schema: Data<Schema>,
    slots: Data<SlotService>,
    user: User
    ) -> Result<HttpResponse, Error> {
    println!("Hello world!");
    let context = GraphQLContext::new(slots.get_ref().clone(), user);
    let config = ConnectionConfig::new(context);
    let config = config.with_keep_alive_interval(Duration::from_secs(15));

    subscriptions_handler(req, payload, schema.into_inner(), config).await
}

async fn graphiql_route() -> Result<actix_web::HttpResponse, actix_web::Error> {
    juniper_actix::graphiql_handler("/graphql/v1", Some("/graphql/v1/websocket")).await
}

async fn playground_route() -> Result<actix_web::HttpResponse, actix_web::Error> {
    juniper_actix::playground_handler("/graphql/v1", Some("/graphql/v1/websocket")).await
}

pub fn graphql_api_scope_v1(scope: Scope) -> Scope {
    scope
        .app_data(Data::new(schema()))
        .route("", get().to(graphql_api_endpoint))
        .route("", post().to(graphql_api_endpoint))
        .route("graphiql", get().to(graphiql_route))
        .route("playground", get().to(playground_route))
        .route("websocket", get().to(socket_gql_endpoint))
        // .route("websocket", get().to(websocket_gql_endpoint))
}
