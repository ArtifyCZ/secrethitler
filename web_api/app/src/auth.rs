use ::entity::{account, auth_token};
use app_contract::auth::*;
use async_trait::async_trait;
use sea_orm::*;
use uuid::Uuid;

#[derive(Clone)]
pub struct AuthServiceImpl {
    database: DatabaseConnection,
}

impl From<DatabaseConnection> for AuthServiceImpl {
    fn from(database: DatabaseConnection) -> Self {
        Self { database }
    }
}

#[async_trait]
impl AuthService for AuthServiceImpl {
    async fn create_anonymous_account(
        &self,
        input: CreateAnonymousAccountInputDto,
    ) -> Result<CreateAnonymousAccountOutputDto, CreateAnonymousAccountError> {
        let CreateAnonymousAccountInputDto { username } = input;

        let id = Uuid::new_v4();
        let token_id = Uuid::new_v4();
        let token = Uuid::new_v4();

        if account::Entity::find()
            .filter(account::Column::Username.eq(&username))
            .limit(1)
            .count(&self.database)
            .await?
            > 0
        {
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

        account.insert(&self.database).await?;
        auth_token.insert(&self.database).await?;

        Ok(CreateAnonymousAccountOutputDto { token_id, token })
    }

    async fn check_token(
        &self,
        input: CheckTokenInputDto,
    ) -> Result<CheckTokenOutputDto, CheckTokenError> {
        let CheckTokenInputDto { token } = input;

        let row = match auth_token::Entity::find()
            .filter(auth_token::Column::Token.eq(token))
            .limit(1)
            .one(&self.database)
            .await?
        {
            Some(row) => row,
            None => {
                return Err(CheckTokenError::TokenNotFound);
            }
        };

        let auth_token::Model {
            id: token_id,
            account_id,
            token: _token,
        } = row;

        Ok(CheckTokenOutputDto {
            token_id,
            account_id,
        })
    }
}
