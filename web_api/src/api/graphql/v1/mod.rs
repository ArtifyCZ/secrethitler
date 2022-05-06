use actix_web::{Error, HttpRequest, web};
use actix_web::HttpResponse;
use actix_web::Scope;
use actix_web::web::{Data, get, Payload, post, resource};
use juniper::{graphql_object, EmptyMutation, EmptySubscription, GraphQLObject, RootNode};
use juniper_actix::graphql_handler;
use crate::api::graphql::v1::context::GraphQLContext;
use crate::api::graphql::v1::mutation::Mutation;
use crate::api::graphql::v1::query::Query;
use crate::app::slot::slot_service::SlotService;
use crate::app::user::identity::Identity;

mod query;
mod object;
mod context;
mod mutation;

pub type Schema = RootNode<'static, Query, Mutation, EmptySubscription<GraphQLContext>>;

pub fn schema() -> Schema {
    Schema::new(
        Query,
        Mutation,
        EmptySubscription::<GraphQLContext>::new()
    )
}

async fn graphql_api_endpoint(
    req: HttpRequest,
    payload: Payload,
    schema: Data<Schema>,
    slots: Data<SlotService>,
    identity: Identity
) -> Result<HttpResponse, Error> {
    let context = GraphQLContext::new(slots.get_ref().clone(), identity);
    graphql_handler(&schema, &context, req, payload).await
}

async fn graphiql_route() -> Result<actix_web::HttpResponse, actix_web::Error> {
    juniper_actix::graphiql_handler("/graphql/v1", None).await
}

pub fn graphql_api_scope_v1(scope: Scope) -> Scope {
    scope
        .app_data(Data::new(schema()))
        .route("", get().to(graphql_api_endpoint))
        .route("", post().to(graphql_api_endpoint))
        .route("graphiql", get().to(graphiql_route))
}
