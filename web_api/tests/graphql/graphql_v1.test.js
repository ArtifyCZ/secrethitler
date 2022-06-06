const { request, checkUUIDValidity, checkSession, loginAnonymous, logout, graphql} = require("../index")
const { generateUsername } = require("unique-username-generator") 

test('GraphQL returns the correct version.', async () => {
    const res = await request.get('/graphql/version')
    expect(res.status).toEqual(200)
    expect(res.text).toEqual('v1')
})

test('Register an anonymous user and create a slot.', async () => {
    const username = generateUsername()
    const { id, token } = await loginAnonymous(username)

    await checkSession(id, token)

    const slot_id = (await graphql.query(token, '1', `
        mutation {
            createSlot(players: 5) {
                uuid
            }
        }
    `)).createSlot.uuid
    expect(checkUUIDValidity(slot_id)).toEqual(true)

    await logout(token)
})

test('Try to start and stop a game.', async () => {
    const login = async () => {
        const username = generateUsername()
        const {id, token} = await loginAnonymous(username)
        return {id, username, token}
    }

    const admin = await login()
    const u1 = await login()
    const u2 = await login()
    const u3 = await login()
    const u4 = await login()

    const slot_id = (await graphql.query(admin.token, '1', `
        mutation {
            createSlot(players: 5) {
                uuid
            }
        }
    `)).createSlot.uuid
    expect(checkUUIDValidity(slot_id)).toEqual(true)

    const join = async (token) => {
        const data = (await graphql.query(token, '1', `
            mutation {
                joinSlot(uuid: "${slot_id}") {
                    uuid, inGame, admin { uuid }
                }
            }
        `)).joinSlot
        expect(data.uuid).toEqual(slot_id)
        expect(data.inGame).toEqual(false)
        expect(data.admin.uuid).toEqual(admin.id)
    }

    await join(u1.token)
    await join(u2.token)
    await join(u3.token)
    await join(u4.token)

    const checkPlayerJoined = async ({id, token}) => {
        const { players } = (await graphql.query(token, '1', `
            query {
                findSlot(uuid: "${slot_id}") {
                    players { uuid }
                }
            }
        `)).findSlot
        expect(players).toContainEqual({ 'uuid': id })
    }

    await checkPlayerJoined(admin)
    await checkPlayerJoined(u1)
    await checkPlayerJoined(u2)
    await checkPlayerJoined(u3)
    await checkPlayerJoined(u4)

    expect((await graphql.query(admin.token, '1', `
        mutation {
            startGame(uuid: "${slot_id}") {
                uuid
            }
        }
    `)).startGame.uuid).toEqual(slot_id)

    await checkPlayerJoined(admin)
    await checkPlayerJoined(u1)
    await checkPlayerJoined(u2)
    await checkPlayerJoined(u3)
    await checkPlayerJoined(u4)

    expect((await graphql.query(admin.token, '1', `
        mutation {
            stopGame(uuid: "${slot_id}") {
                uuid
            }
        }
    `)).stopGame.uuid).toEqual(slot_id)

    await checkPlayerJoined(admin)
    await checkPlayerJoined(u1)
    await checkPlayerJoined(u2)
    await checkPlayerJoined(u3)
    await checkPlayerJoined(u4)

    await logout(admin.token)
    await logout(u1.token)
    await logout(u2.token)
    await logout(u3.token)
    await logout(u4.token)
})
