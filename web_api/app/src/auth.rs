use async_trait::async_trait;
use uuid::Uuid;
use sea_orm::*;
use ::entity::{account, auth_token};
use app_contract::auth::*;

pub struct AuthServiceImpl<'a> {
    database: &'a DatabaseConnection,
}

impl<'a> From<&'a DatabaseConnection> for AuthServiceImpl<'a> {
    fn from(database: &'a DatabaseConnection) -> Self {
        Self {
            database,
        }
    }
}

#[async_trait]
impl<'a> AuthService<'a> for AuthServiceImpl<'a> {
    async fn create_anonymous_account(&self, input: CreateAnonymousAccountInputDto)
                -> Result<CreateAnonymousAccountOutputDto, CreateAnonymousAccountError> {
        let CreateAnonymousAccountInputDto { username } = input;

        if account::Entity::find()
            .filter(account::Column::Username.eq(&username))
            .limit(1)
            .count(self.database).await? > 0 {
            return Err(CreateAnonymousAccountError::UsernameAlreadyInUse(username));
        }

        let id = Uuid::new_v4();

        let account = account::ActiveModel {
            id: Set(id),
            username: Set(username),
        };

        let token_id = Uuid::new_v4();
        let token = Uuid::new_v4();

        let auth_token = auth_token::ActiveModel {
            id: Set(token_id),
            token: Set(token),
            account_id: Set(id),
        };

        self.database.transaction::<_, (), DbErr>(|txn| {
            Box::pin(async move {
                account.save(txn).await?;
                auth_token.save(txn).await?;
                Ok(())
            })
        }).await?;

        Ok(CreateAnonymousAccountOutputDto {
            token_id,
            token,
        })
    }
}
