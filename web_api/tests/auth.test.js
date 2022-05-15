const { request, checkUUIDValidity } = require("./index")
const { generateUsername } = require("unique-username-generator")

test('Tries to login as anonymous and checks the session.', async () => {
    // Logins anonymously
    const username = generateUsername()
    const login_res = await request.post('/auth/anonymous').send({
        username
    })
    expect(login_res.status).toEqual(200)
    const { id, nickname, token } = login_res.body
    expect(checkUUIDValidity(id)).toBe(true)
    expect(nickname).toBe(username)
    expect(checkUUIDValidity(token)).toBe(true)

    // Checks the session
    const check_res = await request.post('/auth/check_session').send({
        token
    })
    expect(check_res.status).toEqual(200)
    const check_id = check_res.body.id
    expect(check_id).toBe(id)

    // Logs out the session
    const logout_res = await request.delete('/auth').send({
        token
    })
    expect(logout_res.status).toEqual(204)
})
