const jwt = require('jsonwebtoken')
const Personal = require('../model/personal/personal')

const auth = async(req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    const decoded = jwt.decode(token)
    try {
        const personal = await Personal.findById(decoded._id)
        if (!personal) {
            return res.status(400).send()
        }
        const isAuth = personal.checkAuth(token)

        if (isAuth) {
            req.personal = personal
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