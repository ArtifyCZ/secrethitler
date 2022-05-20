const { request, checkUUIDValidity, checkSession, loginAnonymous, logout} = require("../index")
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

    // create a slot
    const slot_res = await request.post('/graphql/v1').set({ 'Authorization': token }).send({
        query: `
        mutation {
            createSlot(players: 5) {
                uuid
            }
        }`})
    expect(slot_res.status).toEqual(200)
    expect(slot_res.body.data).toBeDefined()
    expect(slot_res.body.data.createSlot).toBeDefined()
    const slot_id = slot_res.body.data.createSlot.uuid
    expect(slot_id).toBeDefined()
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

    // create a slot
    const slot_res = await request.post('/graphql/v1').set({ 'Authorization': admin.token }).send({
        query: `
        mutation {
            createSlot(players: 5) {
                uuid
            }
        }`})
    expect(slot_res.status).toEqual(200)
    expect(slot_res.body.data).toBeDefined()
    expect(slot_res.body.data.createSlot).toBeDefined()
    const slot_id = slot_res.body.data.createSlot.uuid
    expect(slot_id).toBeDefined()
    expect(checkUUIDValidity(slot_id)).toEqual(true)

    const join = async (token) => {
        const join_res = await request.post('/graphql/v1').set({ 'Authorization': token }).send({
            query: `
            mutation {
                joinSlot(uuid: "${slot_id}") {
                    uuid,
                    inGame,
                    admin {
                        uuid
                    }
                }
            }`
        })
        expect(join_res.status).toEqual(200)
        expect(join_res.body.data).toBeDefined()
        expect(join_res.body.data.joinSlot).toBeDefined()
        const join_obj = join_res.body.data.joinSlot
        expect(join_obj.uuid).toEqual(slot_id)
        expect(join_obj.inGame).toEqual(false)
        expect(join_obj.admin.uuid).toEqual(admin.id)
    }

    await join(u1.token)
    await join(u2.token)
    await join(u3.token)
    await join(u4.token)

    const checkPlayerJoined = async ({id, token}) => {
        const check_res = await request.post('/graphql/v1').set({ 'Authorization': token }).send({
            query: `
            query {
                findSlot(uuid: "${slot_id}") {
                    players {
                        uuid
                    }
                }
            }`
        })
        expect(check_res.status).toEqual(200)
        const check_obj = check_res.body.data.findSlot.players
        expect(check_obj).toContainEqual({ 'uuid': id })
    }

    await checkPlayerJoined(admin)
    await checkPlayerJoined(u1)
    await checkPlayerJoined(u2)
    await checkPlayerJoined(u3)
    await checkPlayerJoined(u4)

    const start_res = await request.post('/graphql/v1').set({ 'Authorization': admin.token }).send({
        query: `
        mutation {
            startGame(uuid: "${slot_id}") {
                uuid
            }
        }`
    })
    expect(start_res.status).toEqual(200)
    expect(start_res.body.data.startGame.uuid).toEqual(slot_id)

    await checkPlayerJoined(admin)
    await checkPlayerJoined(u1)
    await checkPlayerJoined(u2)
    await checkPlayerJoined(u3)
    await checkPlayerJoined(u4)

    const stop_res = await request.post('/graphql/v1').set({ 'Authorization': admin.token }).send({
        query: `
        mutation {
            stopGame(uuid: "${slot_id}") {
                uuid
            }
        }`
    })
    expect(stop_res.status).toEqual(200)
    expect(stop_res.body.data.stopGame.uuid).toEqual(slot_id)

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
