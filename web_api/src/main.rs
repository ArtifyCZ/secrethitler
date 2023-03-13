#![deny(unsafe_code)]

use anyhow::Result;
use axum::Router;

#[tokio::main]
async fn main() -> Result<()> {
    let app = Router::new()
        .route("/", axum::routing::get(|| async { "Hello world!" }));

    let address = match std::env::var("HOST") {
        Ok(str) => str,
        Err(_) => "0.0.0.0:3000".to_string(),
    }.parse()?;

    axum::Server::bind(&address)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
