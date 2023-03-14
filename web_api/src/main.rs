#![deny(unsafe_code)]

use std::time::Duration;
use anyhow::Result;
use axum::Router;
use sea_orm::{Database, DatabaseConnection};
use migration::MigratorTrait;
use axum::routing::*;
use app::auth::AuthServiceImpl;

#[tokio::main]
async fn main() -> Result<()> {
    let db: DatabaseConnection = {
        let mut opt = sea_orm::ConnectOptions::new(
            std::env::var("DB_URL")
                .unwrap_or_else(|_| "postgresql://localhost/secrethitler".to_string()));
        opt.max_connections(100)
            .min_connections(5)
            .connect_timeout(Duration::from_secs(8))
            .acquire_timeout(Duration::from_secs(8))
            .idle_timeout(Duration::from_secs(8))
            .max_lifetime(Duration::from_secs(8))
            .sqlx_logging(true);
        let db = Database::connect(opt).await?;
        migration::Migrator::up(&db, None).await?;
        db
    };

    let auth: AuthServiceImpl = db.into();

    let app = Router::new()
        .route("/auth/anonymous", post(api::auth::create_anonymous_account::<AuthServiceImpl>))
        .route("/auth/check", get(api::auth::check_auth::<AuthServiceImpl>))
        .with_state(auth);

    let address = match std::env::var("HOST") {
        Ok(str) => str,
        Err(_) => "0.0.0.0:3000".to_string(),
    }.parse()?;

    axum::Server::bind(&address)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
