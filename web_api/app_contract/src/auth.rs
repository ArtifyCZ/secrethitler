use uuid::Uuid;

pub struct CreateAnonymousAccountInputDto {
    pub username: String,
}

pub struct CreateAnonymousAccountOutputDto {
    pub token_id: Uuid,
    pub token: Uuid,
}
