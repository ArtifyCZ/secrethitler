use async_trait::async_trait;
use uuid::Uuid;
use sea_orm::*;
use ::entity::{account, auth_token};
use app_contract::auth::*;

pub struct AuthServiceImpl {
    database: DatabaseConnection,
}

impl From<DatabaseConnection> for AuthServiceImpl {
    fn from(database: DatabaseConnection) -> Self {
        Self {
            database,
        }
    }
}

#[async_trait]
impl AuthService for AuthServiceImpl {
    async fn create_anonymous_account(&self, input: CreateAnonymousAccountInputDto)
                -> Result<CreateAnonymousAccountOutputDto, CreateAnonymousAccountError> {
        let CreateAnonymousAccountInputDto { username } = input;

        let id = Uuid::new_v4();
        let token_id = Uuid::new_v4();
        let token = Uuid::new_v4();

        if account::Entity::find()
            .filter(account::Column::Username.eq(&username))
            .limit(1)
            .count(&self.database).await? > 0 {
            return Err(CreateAnonymousAccountError::UsernameAlreadyInUse(username));
        }

        let account = account::ActiveModel {
            id: Set(id),
            username: Set(username),
        };

        let auth_token = auth_token::ActiveModel {
            id: Set(token_id),
            token: Set(token),
            account_id: Set(id),
        };

        account.save(&self.database).await?;
        auth_token.save(&self.database).await?;

        Ok(CreateAnonymousAccountOutputDto {
            token_id,
            token,
        })
    }
}
