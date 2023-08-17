use uuid::Uuid;

#[derive(Clone, Debug)]
pub struct PlayerDto {
    pub id: Uuid,
    pub name: String,
}
