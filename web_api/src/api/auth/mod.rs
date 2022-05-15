mod anonymous;
pub mod check;
pub mod logout;

use actix_web::Scope;
use actix_web::web::{delete, post};
use crate::api::auth::anonymous::login::login_anonymous;
use logout::logout;
use crate::api::auth::check::check_session;

pub fn auth_api_scope(scope: Scope) -> Scope {
    scope
        .route("anonymous", post().to(login_anonymous))
        .route("", delete().to(logout))
        .route("check_session", post().to(check_session))
}
