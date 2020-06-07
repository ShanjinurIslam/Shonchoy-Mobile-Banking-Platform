const router = require('express').Router()
const User = require('../model/adminstration/user')
const Agent = require('../model/agent/agent')
const Client = require('../model/client')
const AgentVerification = require('../model/agent/agent_verification')
const AgentTransaction = require('../model/adminstration/agent_transactions')

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

router.get('/Agent/deposit', middleware, (req, res) => {
    return res.render('agent_deposit', { title: 'Agent Deposit', active: { agent: true } })
})

router.post('/Agent/deposit', middleware, async(req, res) => {
    try {
        if (req.body.amount == req.body.confirmAmount) {
            const agent = await Agent.findOne({ mobileNo: req.body.mobileNo })
            if (!agent) {
                throw new Error('No agent registered with this number')
            }
            const transactionType = "deposit"
            const agent_transaction = new AgentTransaction({ transactionType: transactionType, agent: agent._id, amount: parseFloat(req.body.amount) })
            agent.balance = agent.balance + parseFloat(req.body.amount)
            await agent_transaction.save()
            await agent.save()
            return res.render('agent_deposit', { success: agent_transaction, title: 'Agent Deposit', active: { agent: true } })
        } else {
            throw new Error('Amounts does not match')
        }
    } catch (e) {
        return res.render('agent_deposit', { error: e.message, title: 'Agent Deposit', active: { agent: true } })
    }
})

router.get('/Agent/withdraw', middleware, (req, res) => {
    return res.render('agent_withdraw', { title: 'Agent Withdraw', active: { agent: true } })
})

router.post('/Agent/withdraw', middleware, async(req, res) => {
    try {
        if (req.body.amount == req.body.confirmAmount) {
            const agent = await Agent.findOne({ mobileNo: req.body.mobileNo })
            if (!agent) {
                throw new Error('No agent registered with this number')
            }
            if (agent.balance < parseFloat(req.body.amount)) {
                throw new Error('Insufficient Balance')
            }
            const transactionType = "withdraw"
            const agent_transaction = new AgentTransaction({ transactionType: transactionType, agent: agent._id, amount: parseFloat(req.body.amount) })
            agent.balance = agent.balance - parseFloat(req.body.amount)
            await agent_transaction.save()
            await agent.save()
            return res.render('agent_withdraw', { success: agent_transaction, title: 'Agent Withdraw', active: { agent: true } })
        } else {
            throw new Error('Amounts does not match')
        }
    } catch (e) {
        return res.render('agent_deposit', { error: e.message, title: 'Agent Deposit', active: { agent: true } })
    }
})

router.get('/Agent/verify', middleware, (req, res) => {
    return res.render('agent_verification', { title: 'Agent Verification', active: { agent: true } })
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
    try {
        await Client.findByIdAndUpdate(req.body._id, req.body, { new: true, runValidators: true })
        res.redirect('/Agent/' + req.params.agentID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Agent/' + req.params.agentID)
    }
})

router.post('/Agent/:agentID/updateAgent', middleware, async(req, res) => {
    try {
        console.log(req.body)
        await Agent.findByIdAndUpdate(req.params.agentID, req.body, { new: true, runValidators: true })
        res.redirect('/Agent/' + req.params.agentID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Agent/' + req.params.agentID)
    }
})

module.exports = router