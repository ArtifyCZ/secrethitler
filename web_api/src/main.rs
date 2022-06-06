use actix_web::{web::{self, Data}, App, HttpServer};
use std::env;
use crate::app::{auth::auth_service::AuthService, slot::slot_service::SlotService,
                 user::user_service::UserService};
use crate::middleware::auth_middleware::AuthMiddlewareFactory;

mod api;
mod app;
mod middleware;

fn extract_args(args: Vec<String>) -> (String, u16) {
    let address = args.get(1).cloned().unwrap_or("0.0.0.0".to_string());
    let port = args.get(2).cloned().unwrap_or("8000".to_string()).parse()
        .unwrap_or(8000);

    (address, port)
}

fn setup_services() -> (AuthMiddlewareFactory, SlotService, UserService) {
    let users = UserService::new();
    let auth = AuthService::new(users.clone());
    let slot_service = SlotService::new();

    (AuthMiddlewareFactory::new(auth), slot_service, users)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let (address, port) = extract_args(env::args().collect());

    println!("Running on port {} on host {}.", port, address);
    println!("http://{}:{}/", address, port);

    let (auth_mw, slots_service, users_service)
        = setup_services();

    HttpServer::new(move || {
        App::new()
            .wrap(actix_cors::Cors::permissive())
            .wrap(auth_mw.clone())
            .app_data(Data::new(slots_service.clone()))
            .app_data(Data::new(users_service.clone()))
            .service(api::auth::auth_api_scope(web::scope("/auth")))
            .service(api::graphql::graphql_api_scope(web::scope("/graphql")))
    })
        .bind(format!("{}:{}", address, port))?
        .workers(5)
        .run()
        .await
}
