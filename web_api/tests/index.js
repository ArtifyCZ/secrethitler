const supertest = require('supertest')
const [HOST, PORT] = (() => {
    const env = process.env
    const host = !env.HOST ? "0.0.0.0" : env.HOST
    const port = !env.PORT ? 8000 : env.PORT
    return [host, port]
})()
const request = supertest(`http://${HOST}:${PORT}`)

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

const checkUUIDValidity = (uuid) => {
    const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
    return regexExp.test(uuid)
}

const loginAnonymous = async (username) => {
    const login_res = await request.post('/auth/anonymous').send({
        username
    })
    expect(login_res.status).toEqual(200)
    const { id, nickname, token } = login_res.body
    expect(checkUUIDValidity(id)).toBe(true)
    expect(nickname).toBe(username)
    expect(checkUUIDValidity(token)).toBe(true)
    return {
        id,
        token
    }
}

const checkSession = async (id, token) => {
    const check_res = await request.get('/auth').set({ 'Authorization': token })
    expect(check_res.status).toEqual(200)
    const check_id = check_res.body.id
    expect(check_id).toBe(id)
}

const logout = async (token) => {
    const logout_res = await request.delete('/auth').set({ 'Authorization': token })
    expect(logout_res.status).toEqual(204)
}

module.exports = {
    request,
    checkSession,
    checkUUIDValidity,
    delay,
    loginAnonymous,
    logout
}
