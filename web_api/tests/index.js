const supertest = require('supertest')
const [HOST, PORT] = (() => {
    const env = process.env
    const host = !env.HOST ? "0.0.0.0" : env.HOST
    const port = !env.PORT ? 8000 : env.PORT
    return [host, port]
})()
const request = supertest(`http://${HOST}:${PORT}`)

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

const { exec } = require('child_process')
let server = null
const before = async () => {
    server = exec('cargo run --release')
    await delay(1000)
}

const after = async () => {
    server.kill()
    await delay(300)
}

const checkUUIDValidity = (uuid) => {
    const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
    return regexExp.test(uuid)
}

beforeEach(before, 100000)
afterEach(after, 1000)

module.exports = {
    request,
    checkUUIDValidity,
    delay
}
