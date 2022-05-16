const { request, checkUUIDValidity, checkSession, loginAnonymous, logout} = require("./index")
const { generateUsername } = require("unique-username-generator")

test('Tries to login as anonymous and checks the session.', async () => {
    const username = generateUsername()
    const {id, token} = await loginAnonymous(username)

    await checkSession(id, token)

    await logout(token)
})
