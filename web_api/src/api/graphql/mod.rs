use actix_web::{Scope, web};
use crate::api::graphql::v1::graphql_api_scope_v1;

mod v1;

async fn graphql_api_version() -> &'static str {
    "v1"
}

pub fn graphql_api_scope(scope: Scope) -> Scope {
    scope
        .service(web::resource("version").to(graphql_api_version))
        .service(graphql_api_scope_v1(web::scope("v1")))
}
