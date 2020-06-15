const jwt = require('jsonwebtoken')
const Agent = require('../model/agent/agent')

const auth = async(req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    const decoded = jwt.decode(token)
    try {
        const agent = await Agent.findById(decoded._id)
        if (!agent) {
            return res.status(400).send()
        }
        const isAuth = agent.checkAuth(token)

        if (isAuth) {
            req.agent = agent
            req.token = token
            next()
        } else {
            return res.status(401).send()
        }
    } catch (e) {
        return res.status(502).send(e)
    }
}

module.exports = auth