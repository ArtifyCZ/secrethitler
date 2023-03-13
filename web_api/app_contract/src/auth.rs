use async_trait::async_trait;
use uuid::Uuid;

pub struct CreateAnonymousAccountInputDto {
    pub username: String,
}

pub struct CreateAnonymousAccountOutputDto {
    pub token_id: Uuid,
    pub token: Uuid,
}

#[async_trait]
pub trait AuthService {
}
