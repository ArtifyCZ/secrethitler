use async_trait::async_trait;
use sea_orm::{DbErr, TransactionError};
use thiserror::Error;
use uuid::Uuid;

pub struct CreateAnonymousAccountInputDto {
    pub username: String,
}

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
pub trait AuthService {
}
