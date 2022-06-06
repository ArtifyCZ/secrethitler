use std::{time::Duration, convert::Infallible, fmt::{Debug, Display, Formatter}, str::FromStr};
use juniper::{RootNode, ScalarValue, Variables};
use actix_web::{Error, error::HttpError, HttpRequest, HttpResponse, Scope,
                web::{ Data, get, Payload, post }};
use juniper_graphql_ws::{ConnectionConfig, Init};
use juniper_actix::{graphql_handler, subscriptions::subscriptions_handler};
use uuid::Uuid;
use crate::{AuthService, api::graphql::v1::{context::GraphQLContext, mutation::Mutation,
                                            subscription::Subscription, query::Query},
    app::{auth::session::Session, slot::slot_service::SlotService, user::user::{User, UserType}}};

mod query;
mod object;
mod context;
mod mutation;
mod subscription;

pub type Schema = RootNode<'static, Query, Mutation, Subscription>;
pub fn schema() -> Schema {
    Schema::new(Query, Mutation, Subscription)
}

async fn graphql_api_endpoint(req: HttpRequest, payload: Payload, schema: Data<Schema>,
    slots: Data<SlotService>, user: User) -> Result<HttpResponse, Error> {
    let context = GraphQLContext::new(slots.get_ref().clone(), user);
    graphql_handler(schema.get_ref(), &context, req, payload).await
}

#[derive(Debug)]
pub enum SubscriptionError {
    Unauthorized
}
impl Display for SubscriptionError {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        match self {
            SubscriptionError::Unauthorized => write!(f, "unauthorized")
        }
    }
}
impl std::error::Error for SubscriptionError {}

async fn socket_gql_endpoint(req: HttpRequest, payload: Payload, schema: Data<Schema>,
                             slots: Data<SlotService>, auth: AuthService) -> Result<HttpResponse, Error> {
    subscriptions_handler(req, payload, schema.into_inner(),
                          move |params: Variables| {
        let res: Result<ConnectionConfig<GraphQLContext>, SubscriptionError> = (|| {
            let token = {
                let param = params.get("Authorization")
                    .ok_or(SubscriptionError::Unauthorized)?;
                let token = param.as_string_value().ok_or(SubscriptionError::Unauthorized)?;
                Uuid::from_str(token).map_err(|_| SubscriptionError::Unauthorized)?
            };
            let user: User = auth.get_session(&token)
                .map_err(|_| SubscriptionError::Unauthorized)?.user();

            let context = GraphQLContext::new(slots.get_ref().clone(), user);
            let config = ConnectionConfig::new(context)
                .with_keep_alive_interval(Duration::from_secs(15));
            Ok(config)
        })();
        futures::future::ready(res)
    }).await
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
}
