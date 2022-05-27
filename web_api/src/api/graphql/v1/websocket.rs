// use actix::{Actor, StreamHandler};
// use actix_web::{Error, HttpRequest, HttpResponse, Scope, web::{Data, get, Payload, post }};
// use crate::api::graphql::v1::Schema;
// use actix_web_actors::ws;
// use actix_web_actors::ws::{Message, ProtocolError, WebsocketContext};
//
// pub async fn websocket_gql_endpoint(
//     req: HttpRequest,
//     stream: Payload,
//     schema: Data<Schema>
// ) -> Result<HttpResponse, Error> {
//     ws::start(
//         WsGraphQLSession,
//         &req,
//         stream,
//     )
// }
//
// impl Actor for WsGraphQLSession {
//     type Context = WebsocketContext<Self>;
// }
//
// struct WsGraphQLSession;
// impl StreamHandler<Result<Message, ProtocolError>> for WsGraphQLSession {
//     fn handle(&mut self, msg: Result<Message, ProtocolError>, ctx: &mut Self::Context) {
//         match msg {
//             Ok(ws::Message::Ping(msg)) => ctx.pong(&msg),
//             Ok(ws::Message::Text(text)) => ctx.text(text),
//             Ok(ws::Message::Binary(bin)) => ctx.binary(bin),
//             _ => (),
//         }
//     }
// }
