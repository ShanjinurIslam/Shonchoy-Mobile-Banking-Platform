const router = require('express').Router()
const User = require('../model/adminstration/user')
const Agent = require('../model/agent/agent')
const Client = require('../model/client')
const AgentVerification = require('../model/agent/agent_verification')

const jwt = require('jsonwebtoken')

const middleware = async(req, res, next) => {
    const decoded = jwt.decode(req.cookies.auth)
    try {
        const user = await User.findById(decoded._id)
        if (user) {
            next()
        } else {
            return res.render('index', { title: 'Shonchoy', error: 'Please Log In' })
        }
    } catch (e) {
        return res.render('index', { title: 'Shonchoy', error: e.message })
    }
}

router.get('', async(req, res) => {
    const decoded = jwt.decode(req.cookies.auth)
    try {
        const user = await User.findById(decoded._id)
        if (user) {
            return res.redirect('/home')
        } else {
            return res.render('index', { title: 'Shonchoy' })
        }
    } catch (e) {
        return res.render('index', { title: 'Shonchoy' })
    }
})

router.post('/login', async(req, res) => {
    try {
        const user = await User.authenticate(req.body.username, req.body.password)
        const token = await user.generateAuthToken()
        res.cookie('auth', token)
        res.redirect('/home')
    } catch (e) {
        return res.render('index', { title: 'Shonchoy', error: e.message })
    }
})

router.get('/signup', (req, res) => {
    return res.render('signup', { title: 'Sign Up' })
})

router.post('/signup', async(req, res) => {
    try {
        const user = new User(req.body)
        await user.save()
        res.redirect('/home')
    } catch (e) {
        res.render('signup', { title: 'Sign Up', error: e.message })
    }
})

router.post('/logout', middleware, (req, res) => {
    res.cookie('auth', null)
    req.session.destroy(function(err) {
        res.redirect('/');
    });
})

router.get('/home', middleware, (req, res) => {
    return res.render('home', { title: 'Home', options: ['Personal', 'Agent', 'Merchant'], active: { home: true } })
})

router.get('/Agent', middleware, async(req, res) => {
    try {
        const agents = await Agent.find({ verified: true })
        return res.render('agent', { agents, title: 'Agent', options: [{ name: 'Deposit', url: '/Agent/deposit' }, { name: 'Withdraw', url: '/Agent/withdraw' }, { name: 'Verify', url: '/Agent/verify' }], active: { agent: true } })
    } catch (e) {
        return res.render('agent', { error: e.message, title: 'Agent', options: [{ name: 'Deposit', url: '/Agent/deposit' }, { name: 'Withdraw', url: '/Agent/withdraw' }, { name: 'Verify', url: '/Agent/verify' }], active: { agent: true } })
    }
})

router.get('/Agent/:agentID', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)

        if (!agent) {
            throw new Error('Invalid Agent')
        } else {
            const client = await Client.findById(agent.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                agent.client = client
            }
            return res.render('agent_details', { agent, title: 'Agent Details', active: { agent: true } })
        }
    } catch (e) {
        return res.render('agent_details', { error: e.message, title: 'Agent Details', active: { agent: true } })
    }
})

router.post('/Agent/:agentID/updateClient', middleware, async(req, res) => {
    console.log(req.body)
    res.send('')
})

module.exports = router