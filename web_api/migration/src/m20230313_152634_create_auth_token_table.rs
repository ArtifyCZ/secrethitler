use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(AuthToken::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(AuthToken::Id)
                            .uuid()
                            .not_null()
                            .primary_key(),
                    )
                    .col(
                        ColumnDef::new(AuthToken::Token)
                            .uuid()
                            .not_null()
                            .unique_key(),
                    )
                    .col(
                        ColumnDef::new(AuthToken::AccountId)
                            .uuid()
                            .not_null()
                    )
                    .foreign_key(
                        ForeignKeyCreateStatement::new()
                            .name(&AuthToken::AccountKey.to_string())
                            .from_tbl(AuthToken::Table)
                            .from_col(AuthToken::AccountId)
                            .to_tbl(Account::Table)
                            .to_col(Account::Id)
                    )
                    .to_owned()
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.drop_foreign_key(ForeignKeyDropStatement::new()
            .name(&AuthToken::AccountKey.to_string())
            .to_owned())
            .await?;
        manager
            .drop_table(
                Table::drop()
                    .table(AuthToken::Table)
                    .if_exists()
                    .to_owned()
            ).await
    }
}

#[derive(Iden)]
enum Account {
    Table,
    Id,
}

#[test]
fn are_account_ident_names_correct() {
    assert_eq!(Account::Table.to_string(), "account");
    assert_eq!(Account::Id.to_string(), "id");
}

#[derive(Iden)]
enum AuthToken {
    Table,
    Id,
    Token,
    AccountId,
    #[iden = "fk-auth_token_account"]
    AccountKey,
}

#[test]
fn are_auth_token_ident_names_correct() {
    assert_eq!(AuthToken::Table.to_string(), "auth_token");
    assert_eq!(AuthToken::Id.to_string(), "id");
    assert_eq!(AuthToken::Token.to_string(), "token");
    assert_eq!(AuthToken::AccountId.to_string(), "account_id");
}
