const router = require('express').Router()
const User = require('../model/adminstration/user')
const bcryptjs = require('bcryptjs')

const Agent = require('../model/agent/agent')
const Client = require('../model/client')
const Personal = require('../model/personal/personal')
const Merchant = require('../model/merchant/merchant')

const PersonalVerification = require('../model/personal/personal_verification')

const AgentVerification = require('../model/agent/agent_verification')
const AgentTransaction = require('../model/adminstration/agent_transactions')

const MerchantVerification = require('../model/merchant/merchant_verification')
const MerchantTransaction = require('../model/adminstration/merchant_transactions')

const jwt = require('jsonwebtoken')

const middleware = async(req, res, next) => {
    const decoded = jwt.decode(req.cookies.auth)
    try {
        const user = await User.findById(decoded._id)
        if (user.checkAuth(req.cookies.auth)) {
            req.session.user = user
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
        const token = await user.generateAuthToken()
        res.cookie('auth', token)
        res.redirect('/home')
    } catch (e) {
        res.render('signup', { title: 'Sign Up', error: e.message })
    }
})

router.post('/logout', middleware, async(req, res) => {
    const user = req.session.user
    const tokens = user.tokens.filter((tokens) => tokens.token != req.token)
    user.tokens = tokens
    await user.save()
    res.cookie('auth', null)
    req.session.destroy(function(err) {
        res.redirect('/');
    });
})

router.get('/home', middleware, (req, res) => {
    return res.render('home', { title: 'Home', options: ['Personal', 'Agent', 'Merchant'], active: { home: true } })
})

router.get('/Personal', middleware, (req, res) => {
    return res.render('personal', { title: 'Personal', options: [{ name: 'Verify', url: '/Personal/verify' }, { name: 'Revoke', url: '/Personal/revoke' }, { name: 'Reactivate', url: '/Personal/reactivate' }], active: { personal: true } })
})


router.get('/Agent', middleware, async(req, res) => {
    try {
        const agents = await Agent.find({ verified: true })
        return res.render('agent', { agents, title: 'Agent', options: [{ name: 'Deposit', url: '/Agent/deposit' }, { name: 'Withdraw', url: '/Agent/withdraw' }, { name: 'Verify', url: '/Agent/verify' }, { name: 'Revoke', url: '/Agent/revoke' }, { name: 'Reactivate', url: '/Agent/reactivate' }], active: { agent: true } })
    } catch (e) {
        return res.render('agent', { error: e.message, title: 'Agent', options: [{ name: 'Deposit', url: '/Agent/deposit' }, { name: 'Withdraw', url: '/Agent/withdraw' }, { name: 'Verify', url: '/Agent/verify' }, { name: 'Revoke', url: '/Agent/revoke' }, { name: 'Reactivate', url: '/Agent/reactivate' }], active: { agent: true } })
    }
})

router.get('/Settings', middleware, async(req, res) => {
    return res.render('settings', {
        user: req.session.user,
        title: 'Settings',
        active: { settings: true }
    })
})

router.post('/user/update', middleware, async(req, res) => {
    const isMatch = await bcryptjs.compare(req.body.oldpassword, req.session.user.password)
    if (isMatch) {
        const user = req.session.user
        user.password = req.body.newpassword
        await user.save()
        return res.render('settings', {
            success: 'Password change successful',
            user: req.session.user,
            title: 'Settings',
            active: { settings: true }
        })
    } else {
        return res.render('settings', {
            error: 'Wrong current password',
            user: req.session.user,
            title: 'Settings',
            active: { settings: true }
        })
    }
})

// personal section

router.get('/Personal/verify', middleware, async(req, res) => {
    const personals = await Personal.find({ verified: false })
    return res.render('personal_verification', { personals, title: 'Personal Verification', active: { personal: true } })
})

router.get('/Personal/:personalID/verify', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        const personal_verification = await PersonalVerification.findOne({ personal: personal._id })
        if (!personal) {
            throw new Error('Invalid personal')
        } else {
            const client = await Client.findById(personal.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                personal.client = client
            }
            return res.render('personal_verify', { personal, personal_verification, title: 'Personal Verification Details', active: { personal: true } })
        }
    } catch (e) {
        return res.render('personal_verify', { error: e.message, title: 'Personal Verification Details', active: { personal: true } })
    }
})

router.post('/Personal/:personalID/verify', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        if (!personal) {
            throw new Error('Invalid Personal')
        } else {
            personal.verified = true
            await personal.save()
            return res.redirect('/Personal/verify')
        }
    } catch (e) {
        console.log(e.message)
        return res.render('personal_verify', { error: e.message, title: 'Personal Verify Details', active: { personal: true } })
    }
})

router.post('/Personal/:personalID/discard', middleware, async(req, res) => {
    try {
        await PersonalVerification.deleteOne({ personal: req.params.personalID })
        const personal = await Personal.findById(req.params.personalID)
        const client = await Client.deleteOne({ _id: personal.client })
        await Personal.deleteOne({ _id: personal._id })
        return res.redirect('/Personal/verify')
    } catch (e) {
        console.log(e.message)
        return res.render('personal_verify', { error: e.message, title: 'Personal Verify Details', active: { personal: true } })
    }
})

router.get('/Personal/revoke', middleware, async(req, res) => {
    const personals = await Personal.find({ locked: false })

    return res.render('personal_revocation', { personals, title: 'Personal Verification', active: { personal: true } })
})

router.get('/Personal/:personalID/revoke', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        const personal_verification = await PersonalVerification.findOne({ personal: personal._id })
        if (!personal) {
            throw new Error('Invalid personal')
        } else {
            const client = await Client.findById(personal.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                personal.client = client
            }
            return res.render('personal_revoke', { personal, personal_verification, title: 'Personal Revocation Details', active: { personal: true } })
        }
    } catch (e) {
        return res.render('personal_revoke', { error: e.message, title: 'Personal Revocation Details', active: { personal: true } })
    }
})

router.post('/Personal/:personalID/revoke', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        if (!personal) {
            throw new Error('Invalid Personal')
        } else {
            personal.locked = true
            console.log(personal)
            await personal.save()
            return res.redirect('/Personal/revoke')
        }
    } catch (e) {
        console.log(e.message)
        return res.render('personal_revoke', { error: e.message, title: 'Personal Revoke Details', active: { personal: true } })
    }
})

router.get('/Personal/reactivate', middleware, async(req, res) => {
    const personals = await Personal.find({ locked: true })

    return res.render('personal_reactivation', { personals, title: 'Personal Reactivate', active: { personal: true } })
})

router.get('/Personal/:personalID/reactivate', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        const personal_verification = await PersonalVerification.findOne({ personal: personal._id })
        if (!personal) {
            throw new Error('Invalid personal')
        } else {
            const client = await Client.findById(personal.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                personal.client = client
            }
            return res.render('personal_reactivate', { personal, personal_verification, title: 'Personal Revocation Details', active: { personal: true } })
        }
    } catch (e) {
        return res.render('personal_reactivate', { error: e.message, title: 'Personal Revocation Details', active: { personal: true } })
    }
})

router.post('/Personal/:personalID/reactivate', middleware, async(req, res) => {
    try {
        const personal = await Personal.findById(req.params.personalID)
        if (!personal) {
            throw new Error('Invalid Personal')
        } else {
            personal.locked = false
            await personal.save()
            return res.redirect('/Personal/reactivate')
        }
    } catch (e) {
        console.log(e.message)
        return res.render('personal_reactivate', { error: e.message, title: 'Personal Revoke Details', active: { personal: true } })
    }
})






// agent section


router.get('/Agent/revoke', middleware, async(req, res) => {
    const agents = await Agent.find({ locked: false })

    return res.render('agent_revocation', { agents, title: 'Agent Verification', active: { agent: true } })
})

router.get('/Agent/:agentID/revoke', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        const agent_verification = await AgentVerification.findOne({ agent: agent._id })
        if (!agent) {
            throw new Error('Invalid agent')
        } else {
            const client = await Client.findById(agent.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                agent.client = client
            }
            return res.render('agent_revoke', { agent, agent_verification, title: 'Agent Revocation Details', active: { agent: true } })
        }
    } catch (e) {
        console.log(e)
        return res.render('agent_revoke', { error: e.message, title: 'Agent Revocation Details', active: { agent: true } })
    }
})

router.post('/Agent/:agentID/revoke', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        console.log(agent)
        if (!agent) {
            throw new Error('Invalid Agent')
        } else {
            agent.locked = true
            console.log(agent)
            await agent.save()
            return res.redirect('/Agent/revoke')
        }
    } catch (e) {
        console.log(e.message)
        return res.render('agent_revoke', { error: e.message, title: 'Agent Revoke Details', active: { agent: true } })
    }
})


router.get('/Agent/reactivate', middleware, async(req, res) => {
    const agents = await Agent.find({ locked: true })
    return res.render('agent_reactivation', { agents, title: 'Agent Reactivate', active: { agent: true } })
})

router.get('/Agent/:agentID/reactivate', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        const agent_verification = await AgentVerification.findOne({ agent: agent._id })
        if (!agent) {
            throw new Error('Invalid agent')
        } else {
            const client = await Client.findById(agent.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                agent.client = client
            }
            return res.render('agent_reactivate', { agent, agent_verification, title: 'Agent Reactivation Details', active: { agent: true } })
        }
    } catch (e) {
        return res.render('agent_reactivate', { error: e.message, title: 'Agent Reactivation Details', active: { agent: true } })
    }
})

router.post('/Agent/:agentID/reactivate', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        if (!agent) {
            throw new Error('Invalid agent')
        } else {
            agent.locked = false
            await agent.save()
            return res.redirect('/Agent/reactivate')
        }
    } catch (e) {
        return res.render('agent_reactivate', { error: e.message, title: 'Agent Revoke Details', active: { agent: true } })
    }
})


router.get('/Agent/deposit', middleware, (req, res) => {
    return res.render('agent_deposit', { title: 'Agent Deposit', active: { agent: true } })
})

router.post('/Agent/deposit', middleware, async(req, res) => {
    try {
        if (req.body.amount == req.body.confirmAmount) {
            const agent = await Agent.findOne({ mobileNo: req.body.mobileNo })
            if (!agent || !agent.verified) {
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
            if (!agent || !agent.verified) {
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

router.get('/Agent/verify', middleware, async(req, res) => {
    const agents = await Agent.find({ verified: false })
        /*
        const pending = await AgentVerification.find({ agent: { $in: agents } })
        console.log(pending)
        */

    return res.render('agent_verification', { agents, title: 'Agent Verification', active: { agent: true } })
})

router.get('/Agent/:agentID/verify', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        const agent_verification = await AgentVerification.findOne({ agent: agent._id })
        if (!agent) {
            throw new Error('Invalid Agent')
        } else {
            const client = await Client.findById(agent.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                agent.client = client
            }
            return res.render('agent_verify', { agent, agent_verification, title: 'Agent Details', active: { agent: true } })
        }
    } catch (e) {
        return res.render('agent_verify', { error: e.message, title: 'Agent Details', active: { agent: true } })
    }
})

router.post('/Agent/:agentID/verify', middleware, async(req, res) => {
    try {
        const agent = await Agent.findById(req.params.agentID)
        if (!agent) {
            throw new Error('Invalid Agent')
        } else {
            agent.verified = true
            await agent.save()
            return res.redirect('/Agent/verify')
        }
    } catch (e) {
        return res.render('agent_verify', { error: e.message, title: 'Agent Details', active: { agent: true } })
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
router.get('/PersonalVerification/:id/IDFront', middleware, async(req, res) => {
    try {
        const verification = await PersonalVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDFront)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/PersonalVerification/:id/IDBack', middleware, async(req, res) => {
    try {
        const verification = await PersonalVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDBack)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/PersonalVerification/:id/currentPhoto', middleware, async(req, res) => {
    try {
        const verification = await PersonalVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.currentPhoto)
        }
    } catch (e) {
        res.status(404).send()
    }
})


router.get('/AgentVerification/:id/IDFront', middleware, async(req, res) => {
    try {
        const verification = await AgentVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDFront)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/AgentVerification/:id/IDBack', middleware, async(req, res) => {
    try {
        const verification = await AgentVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDBack)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/AgentVerification/:id/currentPhoto', middleware, async(req, res) => {
    try {
        const verification = await AgentVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.currentPhoto)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/AgentVerification/:id/tradeLicence', middleware, async(req, res) => {
    try {
        const verification = await AgentVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.tradeLicencePhoto)
        }
    } catch (e) {
        res.status(404).send()
    }
})


// Merchant Section 

router.get('/Merchant', middleware, async(req, res) => {
    try {
        const merchants = await Merchant.find({ verified: true })
        return res.render('merchant', { merchants, title: 'Merchant', options: [{ name: 'Deposit', url: '/Merchant/deposit' }, { name: 'Withdraw', url: '/Merchant/withdraw' }, { name: 'Verify', url: '/Merchant/verify' }], active: { merchant: true } })
    } catch (e) {
        return res.render('merchant', { error: e.message, title: 'Merchant', options: [{ name: 'Deposit', url: '/Merchant/deposit' }, { name: 'Withdraw', url: '/Merchant/withdraw' }, { name: 'Verify', url: '/Merchant/verify' }], active: { merchant: true } })
    }
})


router.get('/Merchant/deposit', middleware, (req, res) => {
    return res.render('merchant_deposit', { title: 'Merchant Deposit', active: { merchant: true } })
})

router.post('/Merchant/deposit', middleware, async(req, res) => {
    try {
        if (req.body.amount == req.body.confirmAmount) {
            const merchant = await Merchant.findOne({ mobileNo: req.body.mobileNo })
            if (!merchant || !merchant.verified) {
                throw new Error('No merchant registered with this number')
            }
            const transactionType = "deposit"
            const merchant_transaction = new MerchantTransaction({ transactionType: transactionType, merchant: merchant._id, amount: parseFloat(req.body.amount) })
            merchant.balance = merchant.balance + parseFloat(req.body.amount)
            await merchant_transaction.save()
            await merchant.save()
            return res.render('merchant_deposit', { success: agent_transaction, title: 'Merchant Deposit', active: { merchant: true } })
        } else {
            throw new Error('Amounts does not match')
        }
    } catch (e) {
        return res.render('merchant_deposit', { error: e.message, title: 'Merchant Deposit', active: { merchant: true } })
    }
})

router.get('/Merchant/withdraw', middleware, (req, res) => {
    return res.render('merchant_withdraw', { title: 'Merchant Withdraw', active: { merchant: true } })
})

router.post('/Merchant/withdraw', middleware, async(req, res) => {
    try {
        if (req.body.amount == req.body.confirmAmount) {
            const merchant = await Merchant.findOne({ mobileNo: req.body.mobileNo })
            if (!merchant || !merchant.verified) {
                throw new Error('No merchant registered with this number')
            }
            if (merchant.balance < parseFloat(req.body.amount)) {
                throw new Error('Insufficient Balance')
            }
            const transactionType = "withdraw"
            const merchant_transaction = new MerchantTransaction({ transactionType: transactionType, merchant: merchant._id, amount: parseFloat(req.body.amount) })
            merchant.balance = merchant.balance - parseFloat(req.body.amount)
            await merchant_transaction.save()
            await merchant.save()
            return res.render('merchant_withdraw', { success: merchant_transaction, title: 'Merchant Withdraw', active: { agent: true } })
        } else {
            throw new Error('Amounts does not match')
        }
    } catch (e) {
        return res.render('merchant_withdraw', { error: e.message, title: 'Merchant Withdraw', active: { agent: true } })
    }
})

router.get('/Merchant/verify', middleware, async(req, res) => {
    const merchants = await Merchant.find({ verified: false })
    return res.render('merchant_verification', { merchants, title: 'Merchant Verification', active: { merchant: true } })
})

router.get('/Merchant/:merchantID/verify', middleware, async(req, res) => {
    try {
        const merchant = await Merchant.findById(req.params.merchantID)
        const merchant_verification = await MerchantVerification.findOne({ merchant: merchant._id })
        console.log(merchant_verification)
        if (!merchant) {
            throw new Error('Invalid Merchant')
        } else {
            const client = await Client.findById(merchant.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                merchant.client = client
            }
            return res.render('merchant_verify', { merchant, merchant_verification, title: 'Merchant Details', active: { merchant: true } })
        }
    } catch (e) {
        return res.render('merchant_verify', { merchant: e.message, title: 'Merchant Details', active: { merchant: true } })
    }
})

router.post('/Merchant/:merchantID/verify', middleware, async(req, res) => {
    try {
        const merchant = await Merchant.findById(req.params.merchantID)
        if (!merchant) {
            throw new Error('Invalid Agent')
        } else {
            merchant.verified = true
            await merchant.save()
            return res.redirect('/Merchant/verify')
        }
    } catch (e) {
        return res.render('merchant_verify', { error: e.message, title: 'Merchant Details', active: { merchant: true } })
    }
})


router.get('/Merchant/:merchantID', middleware, async(req, res) => {
    try {
        const merchant = await Merchant.findById(req.params.merchantID)

        if (!merchant) {
            throw new Error('Invalid merchant')
        } else {
            const client = await Client.findById(merchant.client)
            if (!client) {
                throw new Error('Invalid Client')
            } else {
                merchant.client = client
            }
            return res.render('merchant_details', { merchant, title: 'Merchant Details', active: { merchant: true } })
        }
    } catch (e) {
        return res.render('merchant_details', { error: e.message, title: 'Merchant Details', active: { merchant: true } })
    }
})

router.post('/Merchant/:merchantID/updateClient', middleware, async(req, res) => {
    try {
        await Client.findByIdAndUpdate(req.body._id, req.body, { new: true, runValidators: true })
        res.redirect('/Merchant/' + req.params.merchantID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Merchant/' + req.params.merchantID)
    }
})

router.post('/Merchant/:merchantID/updateMerchant', middleware, async(req, res) => {
    try {
        await Merchant.findByIdAndUpdate(req.params.merchantID, req.body, { new: true, runValidators: true })
        res.redirect('/Merchant/' + req.params.merchantID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Merchant/' + req.params.merchantID)
    }
})

router.get('/MerchantVerification/:id/IDFront', middleware, async(req, res) => {
    try {
        const verification = await MerchantVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDFront)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/MerchantVerification/:id/IDBack', middleware, async(req, res) => {
    try {
        const verification = await MerchantVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.IDBack)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/MerchantVerification/:id/currentPhoto', middleware, async(req, res) => {
    try {
        const verification = await MerchantVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.currentPhoto)
        }
    } catch (e) {
        res.status(404).send()
    }
})

router.get('/MerchantVerification/:id/tradeLicence', middleware, async(req, res) => {
    try {
        const verification = await MerchantVerification.findById(req.params.id)
        if (!verification) {
            throw new Error()
        } else {
            res.set('Content-Type', 'image/jpg')
            res.send(verification.tradeLicencePhoto)
        }
    } catch (e) {
        res.status(404).send()
    }
})



module.exports = router



/*
Personal Modification

router.post('/Personal/:personalID/updateClient', middleware, async(req, res) => {
    try {
        await Personal.findByIdAndUpdate(req.body._id, req.body, { new: true, runValidators: true })
        res.redirect('/Agent/' + req.params.agentID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Agent/' + req.params.agentID)
    }
})

router.post('/Personal/:personalID/updatePersonal', middleware, async(req, res) => {
    try {
        await Personal.findByIdAndUpdate(req.params.agentID, req.body, { new: true, runValidators: true })
        res.redirect('/Agent/' + req.params.agentID)
    } catch (e) {
        console.log(e.message)
        res.redirect('/Agent/' + req.params.agentID)
    }
})*/