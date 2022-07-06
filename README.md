
# Secrethitler

## GraphQL Client
- Path: `http://127.0.0.1:8000/graphql/v1`
- Header: `Authorization: <token>`


## API


### Create a new anonymous account
- Method: `POST`
- Path: `/auth/anonymous`
- Header: `Content-Type: application/json`
- body:
```json
{"username": "<name>"}
```

<details>
  <summary>Curl</summary>

```bash
curl 'http://127.0.0.1:8000/auth/anonymous' -X POST -H 'Content-Type: application/json' -H 'Authorization: None' --data-raw '{"username":"<name>"}'
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
POST /auth/anonymous HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json
Authorization: None
Content-Length: 19

{
	"username":"name"
}
```
</details>

Response:
```json
{
	"id":"947e37e5-3e7f-44a3-b7a6-d678f69f5e81",
	"nickname":"<name>",
	"token":"400a6569-c4a9-467f-8fa5-97214eab6026"
}
```


------------------------


### Create new game slot
- Using GraphQL mutation
- Method: `POST`
- Path: `/graphql/v1`
- Header: `Content-Type: application/json`
- Header `Authorization` with `token` received from login
- body:
```json
{
	"operationName":null,
	"variables":{
		"nPlayers":5
	},
	"query":"mutation CreateSlot($nPlayers: Int!) {  __typename\n  createSlot(players: $nPlayers) {\n    __typename\n    uuid\n  }\n}"
}
```

<details>
  <summary>GraphQL</summary>

```graphql
mutation {
    createSlot(players: 5) {
        uuid
    }
}
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
POST /graphql/v1 HTTP/1.1
Host: 127.0.0.1:8000
Content-Type: application/json
Authorization: 400a6569-c4a9-467f-8fa5-97214eab6026
Content-Length: 182

{
	"operationName":null,
	"variables":{
		"nPlayers":5
	},
	"query":"mutation CreateSlot($nPlayers: Int!) {  __typename\n  createSlot(players: $nPlayers) {\n    __typename\n    uuid\n  }\n}"
}
```
</details>

Response:
```json
{
	"id":"947e37e5-3e7f-44a3-b7a6-d678f69f5e81",
	"nickname":"<name>",
	"token":"400a6569-c4a9-467f-8fa5-97214eab6026"
}
```


------------------------


### Subscribe to game events
- Using GraphQL subscription
- WebSockets (currently `ws://` protocol, in the future `wss://` encrypted protocol)
- `ws://127.0.0.1:8000/graphql/v1/websocket`
- Header `Authorization` with `token` received from login (sent with WS initial payload, not via HTTP headers)
- Initial WebSocket link payload:
```json
{"Authorization": "<token>"}
```

<details>
  <summary>GraphQL</summary>

```graphql
subscription Game($uuid: String!){
    game(uuid: $uuid) {
        hello
    }
}
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
GET /graphql/v1/websocket HTTP/1.1
Host: 127.0.0.1:8000
Sec-WebSocket-Version: 13
Sec-WebSocket-Protocol: graphql-ws
Sec-WebSocket-Key: 26i09MP46HbbYIQhQPZJdQ==
Upgrade: websocket


```

Websockets:
```json
{"type":"connection_init","payload":{"Authorization":"1dc0e1d8-a54e-4cff-b3d0-14e5d7aa2269"}}
```
```json
{"type":"start","id":"87499fcf-9447-46e8-9070-7ce5a916bc04","payload":{"operationName":null,"variables":{"uuid":"fa74c486-6ae9-45dc-90b5-e78b2b5d3ff5"},"query":"subscription Game($uuid: String!) {\n  game(uuid: $uuid) {\n    __typename\n    hello\n  }\n}"}}
```
</details>

Response websockets:
```json
{"type":"data","id":"87499fcf-9447-46e8-9070-7ce5a916bc04","payload":{"data":{"game":{"__typename":"Round","hello":"world"}}}}
```



------------------------



### Logout
- Method: `DELETE`
- Path: `/auth`
- Header `Authorization` with `token` received from login

<details>
  <summary>Curl</summary>

```bash
curl 'http://127.0.0.1:8000/auth' -X DELETE -H 'Authorization: 1dc0e1d8-a54e-4cff-b3d0-14e5d7aa2269'
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
DELETE /auth HTTP/1.1
Host: 127.0.0.1:8000
Authorization: 400a6569-c4a9-467f-8fa5-97214eab6026


```
</details>

Response:
- 204 No Content


------------------------


### Verify session
- *not mandatory*
- Method: `GET`
- Path: `/auth`
- Header `Authorization` with `token` received from login

<details>
  <summary>Curl</summary>

```bash
curl 'http://127.0.0.1:8000/auth' -H 'Authorization: 1dc0e1d8-a54e-4cff-b3d0-14e5d7aa2269'
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
GET /auth HTTP/1.1
Host: 127.0.0.1:8000
Authorization: 400a6569-c4a9-467f-8fa5-97214eab6026


```
</details>

Response:
```json
{
	"id":"947e37e5-3e7f-44a3-b7a6-d678f69f5e81"
}
```


------------------------



### Get API version
- *not mandatory*
- Method: `GET`
- Path: `/graphql/version`

<details>
  <summary>Curl</summary>

```bash
curl 'http://127.0.0.1:8000/graphql/version'
```
</details>

<details>
  <summary>HTTP Request</summary>

```http
GET /graphql/version HTTP/1.1
Host: 127.0.0.1:8000
```
</details>

Response:
```
v1
```



