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
