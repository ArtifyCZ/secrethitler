const { request, checkUUIDValidity } = require("../index")
const { generateUsername } = require("unique-username-generator") 

test('GraphQL returns the correct version.', async () => {
    const res = await request.get('/graphql/version')
    expect(res.status).toEqual(200)
    expect(res.text).toEqual('v1')
})

test('Register an anonymous user and create a slot.', async () => {
    const username = generateUsername()
    // register anonymously
    const login_res = await request.post('/auth/anonymous').send({
        username
    })
    expect(login_res.status).toEqual(200)
    const { id, nickname, token } = login_res.body
    expect(checkUUIDValidity(id)).toBe(true)
    expect(checkUUIDValidity(token)).toBe(true)
    expect(nickname).toBe(username)

    // check the session
    const check_res = await request.post('/auth/check_session').send({
        token
    })
    expect(check_res.status).toEqual(200)
    expect(check_res.body.id).toBe(id)

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

    // log out the session
    const logout_res = await request.delete('/auth').send({
        token
    })
    expect(logout_res.status).toEqual(204)
})

