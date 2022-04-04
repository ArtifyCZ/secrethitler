mod anonymous;
pub mod check;

use actix_web::Scope;
use actix_web::web::{delete, post};
use crate::api::auth::anonymous::login::login_anonymous;
use crate::api::auth::anonymous::logout::logout_anonymous;
use crate::api::auth::check::check_session;

pub fn auth_api_scope(scope: Scope) -> Scope {
    scope
        .route("anonymous", post().to(login_anonymous))
        .route("anonymous", delete().to(logout_anonymous))
        .route("checksession", post().to(check_session))
}
