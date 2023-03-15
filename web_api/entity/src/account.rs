use sea_orm::entity::prelude::*;

#[derive(Clone, Debug, PartialEq, Eq, DeriveEntityModel)]
#[sea_orm(table_name = "account")]
pub struct Model {
    #[sea_orm(primary_key)]
    pub id: Uuid,
    pub username: String,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(has_many = "super::auth_token::Entity")]
    AuthToken,
}

impl Related<super::auth_token::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::AuthToken.def()
    }
}

impl ActiveModelBehavior for ActiveModel {}
