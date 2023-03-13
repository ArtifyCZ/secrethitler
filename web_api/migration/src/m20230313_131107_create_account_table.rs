use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(Account::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(Account::Id)
                            .uuid()
                            .not_null()
                            .primary_key(),
                    )
                    .col(
                        ColumnDef::new(Account::Username)
                            .string_len(128)
                            .not_null()
                            .unique_key(),
                    )
                    .to_owned()
            ).await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(
                Table::drop()
                    .table(Account::Table)
                    .if_exists()
                    .to_owned()
            ).await
    }
}

#[derive(Iden)]
enum Account {
    Table,
    Id,
    Username,
}

#[test]
fn are_account_ident_names_correct() {
    assert_eq!(Account::Table.to_string(), "account");
    assert_eq!(Account::Id.to_string(), "id");
    assert_eq!(Account::Username.to_string(), "username");
}
