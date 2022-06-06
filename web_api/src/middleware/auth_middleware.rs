use std::{pin::Pin, task::{Context, Poll}};
use actix_web::{dev::{ServiceRequest, ServiceResponse, Service, Transform}, Error, HttpMessage, body::MessageBody};
use futures::{future::{ok, Ready}, Future};
use crate::app::auth::auth_service::AuthService;

#[derive(Clone)]
pub struct AuthMiddlewareFactory(AuthService);

impl AuthMiddlewareFactory {
    pub fn new(service: AuthService) -> Self {
        Self(service)
    }
}

impl<S, B> Transform<S, ServiceRequest> for AuthMiddlewareFactory
    where
        S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
        B: MessageBody + 'static,
        S::Future: 'static,
        B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Transform = AuthMiddleware<S>;
    type InitError = ();
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ok(AuthMiddleware {
            auth_service: self.0.clone(),
            service
        })
    }
}

pub struct AuthMiddleware<S> {
    auth_service: AuthService,
    service: S
}

impl<S, B> Service<ServiceRequest> for AuthMiddleware<S>
    where
        S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
        S::Future: 'static,
        B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response, Self::Error>>>>;

    fn poll_ready(&self, cx: &mut Context<'_>) -> Poll<Result<(), Self::Error>> {
        self.service.poll_ready(cx)
    }

    fn call(&self, req: ServiceRequest) -> Self::Future {
        req.extensions_mut().insert(self.auth_service.clone());

        let fut = self.service.call(req);

        Box::pin(async move {
            let res = fut.await?;

            Ok(res)
        })
    }
}
