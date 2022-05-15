use actix_web::web;
use redis::{Client, Commands, Connection};
use {
    actix_web::{
        App,
        get,
        HttpResponse,
        HttpServer,
        Responder
    },
    std::env
};
use crate::app::auth::auth_service::AuthService;

mod middleware;
mod infrastructure;
mod app;
mod api;

use crate::middleware::auth_middleware::AuthMiddlewareFactory;

fn extract_args(args: Vec<String>) -> (String, u16) {
    let address = args.get(1).cloned().unwrap_or("0.0.0.0".to_string());
    let port = args.get(2).cloned().unwrap_or("8000".to_string()).parse()
        .unwrap_or(8000);

    (address, port)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let (address, port) = extract_args(env::args().collect());

    println!("Running on port {} on host {}.", port, address);
    println!("http://{}:{}/", address, port);

    let auth_middleware = AuthMiddlewareFactory::new(AuthService::new());

    HttpServer::new(move || {
        App::new()
            .wrap(actix_cors::Cors::permissive())
            .wrap(auth_middleware.clone())
            .service(api::auth::auth_api_scope(web::scope("/auth")))
            .service(api::graphql::v1::graphql_api_scope(web::scope("/graphql/v1")))
    })
        .bind(format!("{}:{}", address, port))?
        .workers(5)
        .run()
        .await
}
