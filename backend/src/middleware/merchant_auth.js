const jwt = require('jsonwebtoken')
const Merchant = require('../model/merchant/merchant')

const auth = async(req, res, next) => {
    const token = req.header('Authorization').replace('Bearer ', '')
    const decoded = jwt.decode(token)
    try {
        const merchant = await Merchant.findById(decoded._id)
        if (!merchant) {
            return res.status(400).send()
        }
        const isAuth = merchant.checkAuth(token)

        if (isAuth) {
            req.merchant = merchant
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