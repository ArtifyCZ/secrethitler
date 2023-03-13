use async_trait::async_trait;
use sea_orm::{DatabaseConnection, DbErr, TransactionError};
use serde::{Deserialize, Serialize};
use thiserror::Error;
use uuid::Uuid;

#[derive(Clone, Debug, Deserialize)]
pub struct CreateAnonymousAccountInputDto {
    pub username: String,
}

#[derive(Clone, Debug, Serialize)]
pub struct CreateAnonymousAccountOutputDto {
    pub token_id: Uuid,
    pub token: Uuid,
}

#[derive(Error, Debug)]
pub enum CreateAnonymousAccountError {
    #[error("Username `{0}` is already in use")]
    UsernameAlreadyInUse(String),
    #[error("An database error occurred: {0}")]
    DatabaseError(#[from] DbErr),
}

impl From<TransactionError<DbErr>> for CreateAnonymousAccountError {
    fn from(value: TransactionError<DbErr>) -> Self {
        match value {
            TransactionError::Connection(err) => err,
            TransactionError::Transaction(err) => err,
        }.into()
    }
}

#[async_trait]
pub trait AuthService<'a>: From<&'a DatabaseConnection> {
    async fn create_anonymous_account(&self, input: CreateAnonymousAccountInputDto)
                          -> Result<CreateAnonymousAccountOutputDto, CreateAnonymousAccountError>;
}
