use sea_orm::DatabaseConnection;

pub struct AuthService<'a> {
    database: &'a DatabaseConnection,
}

impl<'a> AuthService<'a> {
}
