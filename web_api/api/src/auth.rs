use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use sea_orm::DatabaseConnection;
use serde_json::{json, Value};
use app_contract::auth::*;

pub use authorize::{Authorize, AuthorizeError};

mod authorize {
    use std::marker::PhantomData;
    use std::str::FromStr;
    use axum::extract::{FromRef, FromRequestParts, State};
    use axum::http::request::Parts;
    use axum::http::StatusCode;
    use axum::response::{IntoResponse, Response};
    use axum_auth::AuthBearer;
    use sea_orm::{DatabaseConnection, DbErr};
    use thiserror::Error;
    use uuid::Uuid;
    use app_contract::auth::{AuthService, CheckTokenError, CheckTokenInputDto, CheckTokenOutputDto};

    /// Meant to be used as request extractor.
    /// The value it wraps is current user's account id.
    pub struct Authorize<AS: 'static + AuthService>(pub Uuid, PhantomData<AS>);

    #[derive(Error, Debug)]
    pub enum AuthorizeError {
        #[error("No authorization method provided")]
        Unauthorized,
        #[error("Provided token not found")]
        TokenNotFound,
        #[error("Token not parsable")]
        TokenNotParsable,
        #[error("An database error occurred: {0}")]
        DatabaseError(DbErr),
        #[error("An error occurred in Axum")]
        AxumInternalError,
    }

    impl IntoResponse for AuthorizeError {
        fn into_response(self) -> Response {
            match self {
                AuthorizeError::Unauthorized => (StatusCode::UNAUTHORIZED, "\n".to_string()),
                AuthorizeError::TokenNotFound => (StatusCode::FORBIDDEN, "\n".to_string()),
                AuthorizeError::TokenNotParsable => (StatusCode::BAD_REQUEST, "\n".to_string()),
                error => {
                    println!("ERROR OCCURRED: {}", error);
                    (StatusCode::INTERNAL_SERVER_ERROR, "\n".to_string())
                },
            }.into_response()
        }
    }

    #[async_trait::async_trait]
    impl<S, AS> FromRequestParts<S> for Authorize<AS>
            where
                S: Sync + Send,
                AS: 'static + AuthService + Sync + Send,
                DatabaseConnection: FromRef<S> {
        type Rejection = AuthorizeError;

        async fn from_request_parts(parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
            let AuthBearer(token) = FromRequestParts::from_request_parts(parts, state).await
                .map_err(|_| AuthorizeError::Unauthorized)?;

            let token = Uuid::from_str(token.trim())
                .map_err(|_| AuthorizeError::TokenNotParsable)?;

            let State(database): State<DatabaseConnection> =
                FromRequestParts::from_request_parts(parts, state).await
                .map_err(|_| AuthorizeError::AxumInternalError)?;

            let auth: AS = database.into();

            let CheckTokenOutputDto { account_id, token_id: _ } =
                auth.check_token(CheckTokenInputDto {
                    token,
                }).await.map_err(|error| match error {
                    CheckTokenError::TokenNotFound => AuthorizeError::TokenNotFound,
                    CheckTokenError::DatabaseError(error) => AuthorizeError::DatabaseError(error),
                })?;

            Ok(Self(account_id, PhantomData))
        }
    }

    impl<AS> From<Authorize<AS>> for Uuid
            where
                AS: 'static + AuthService + Sync + Send {
        fn from(value: Authorize<AS>) -> Self {
            value.0
        }
    }
}

pub async fn create_anonymous_account<AS>(State(database): State<DatabaseConnection>,
                                          Json(payload): Json<CreateAnonymousAccountInputDto>,
        ) -> (StatusCode, Json<Value>)
        where
            AS: 'static + AuthService {
    let auth: AS = database.into();
    match auth.create_anonymous_account(payload).await {
        Ok(out) => (StatusCode::CREATED, Json(json!(out))),
        Err(error) => match error {
            CreateAnonymousAccountError::UsernameAlreadyInUse(username) => {
                (StatusCode::CONFLICT, Json(json!({
                    "status": 409,
                    "message": format!("Username `{}` already in use", username),
                })))
            },
            error => {
                println!("ERROR: {}", error);
                (StatusCode::INTERNAL_SERVER_ERROR, Json(json!({
                    "status": 500,
                    "message": "Internal server error",
                })))
            },
        }
    }
}
