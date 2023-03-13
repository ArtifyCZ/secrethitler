pub use sea_orm_migration::prelude::*;

mod m20230313_131107_create_account_table;

pub struct Migrator;

#[async_trait::async_trait]
impl MigratorTrait for Migrator {
    fn migrations() -> Vec<Box<dyn MigrationTrait>> {
        vec![
            Box::new(m20230313_131107_create_account_table::Migration),
        ]
    }
}
