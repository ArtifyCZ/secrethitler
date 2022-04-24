const { request } = require("../index")

test.only('GraphQL returns the correct version.', async () => {
    const res = await request.get('/graphql/version')
    expect(res.status).toEqual(200)
    expect(res.text).toEqual('v1')
})
