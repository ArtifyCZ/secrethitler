use std::{time::Duration, convert::Infallible};
use std::ptr::null;
use juniper::{RootNode, ScalarValue};
use actix_web::{Error, HttpRequest, HttpResponse, Scope, web::{ Data, get, Payload, post }};
use futures::StreamExt;
use juniper_graphql_ws::{ConnectionConfig, Init};
use juniper_actix::{graphql_handler, subscriptions::subscriptions_handler};
use uuid::Uuid;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::mutation::Mutation;
use crate::api::graphql::v1::subscription::Subscription;
use crate::api::graphql::v1::query::Query;
//use crate::api::graphql::v1::websocket::websocket_gql_endpoint;
use crate::app::slot::slot_service::SlotService;
use crate::app::user::user::{User, UserType};
use crate::AuthService;

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

pub struct SubscriptionConfig<CtxT: Unpin + Send + 'static>(ConnectionConfig<CtxT>);
impl<S: ScalarValue, CtxT: Unpin + Send + 'static> Init<S, CtxT> for SubscriptionConfig<CtxT> {
    type Error = Infallible;
    type Future = futures::future::Ready<Result<ConnectionConfig<CtxT>, Self::Error>>;

    fn init(self, params: juniper::Variables<S>) -> Self::Future {
        println!("It fuckin' did it!");
        futures::future::ok(self.0)
    }
}

async fn socket_gql_endpoint(
    req: HttpRequest,
    mut payload: Payload,
    schema: Data<Schema>,
    slots: Data<SlotService>,
    // auth: Data<AuthService>
    // user: User
    ) -> Result<HttpResponse, Error> {
    // TODO: This should really be replaced.
    let context = GraphQLContext::new(slots.get_ref().clone(), User::new(Uuid::new_v4(), UserType::Temp, "abc".to_string()));
    let config = ConnectionConfig::new(context);
    let config = config.with_keep_alive_interval(Duration::from_secs(15));

    subscriptions_handler(req, payload, schema.into_inner(), SubscriptionConfig(config)).await
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
