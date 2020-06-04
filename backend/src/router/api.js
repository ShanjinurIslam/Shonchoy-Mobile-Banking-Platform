const router = require('express').Router()
const bcrypt = require('bcryptjs')

const Client = require('../model/client')

// personal models
const Personal = require('../model/personal/personal')
const PersonalVerification = require('../model/personal/personal_verification')

// agent models
const Agent = require('../model/agent/agent')
const AgentVerification = require('../model/agent/agent_verification')

// merchant models

const Merchant = require('../model/merchant/merchant')
const MerchantVerification = require('../model/merchant/merchant_verification')

// middlewares

const personalAuth = require('../middleware/personal_auth')
const agentAuth = require('../middleware/agent_auth')

// sendmoney

const Transaction = require('../model/adminstration/transaction')
const Sendmoney = require('../model/adminstration/send_money')
const Payment = require('../model/adminstration/payments')
const CashIn = require('../model/adminstration/cash_in')
const CashOut = require('../model/adminstration/cash_out')

const nexmo = require('../config/nexmo')
var multer = require('multer')
var storage = multer.memoryStorage()
var upload = multer({ dest: 'uploads/', storage: storage })

// personal
router.post('/personal/mobile', async(req, res) => {
    const personal = await Personal.findOne({ mobileNo: req.body.mobileNo })
    if (!personal) {
        res.status(404).send({ message: 'This number is not linked to any account' })
    } else {
        res.status(200).send(personal)
    }
})

// otp verification - nexmo api

router.post('/personal/mobile/sendCode', async(req, res) => {
    await nexmo.verify.request({
        number: req.body.mobileNo,
        brand: 'Shonchoy',
        code_length: '4'
    }, (err, result) => {
        res.send(err ? err : result)
    });
})

router.post('/personal/mobile/verifyCode', async(req, res) => {
    await nexmo.verify.check({
        request_id: req.body.request_id,
        code: req.body.code,
    }, (err, result) => {
        res.send(err ? err : result)
    });
})

router.post('/personal/mobile/cancel', async(req, res) => {
    await nexmo.verify.control({
        request_id: req.body.request_id,
        cmd: 'cancel'
    }, (err, result) => {
        res.send(err ? err : result)
    });
})

// client registration

router.post('/personal/registerClient', async(req, res) => {
    try {
        const client = new Client(req.body)
        await client.save()
        res.status(201).send({ client_id: client._id })
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

// register personal account

router.post('/personal/registerAccount', async(req, res) => {
    try {
        const personal = new Personal(req.body)
        await personal.save()
        res.status(201).send(personal._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

// add personal account Verification
var cpUpload = upload.fields([{ name: 'accountID', maxCount: 1 }, { name: 'IDFront', maxCount: 1 }, { name: 'IDBack', maxCount: 1 }, { name: 'currentPhoto', maxCount: 1 }])

router.post('/personal/verifyAccount', cpUpload, async(req, res) => {
    try {
        const personalVerification = new PersonalVerification({
            personal: req.body.accountID,
            IDFront: req.files.IDFront[0].buffer,
            IDBack: req.files.IDBack[0].buffer,
            currentPhoto: req.files.currentPhoto[0].buffer,
        })
        await personalVerification.save()
        res.status(201).send(personalVerification._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

router.post('/personal/login', async(req, res) => {
    try {
        const personal = await Personal.authenticate(req.body.mobileNo, req.body.pinCode)
        if (!personal.verified) {
            res.status(200).send({ message: "Account Verification Still in Progress" })
        } else {
            const token = await personal.generateAuthToken()
            res.status(200).send({ personal, token })
        }
    } catch (e) {
        res.status(502).send(e.message)
    }
})

router.post('/personal/logout', personalAuth, (req, res) => {
    const personal = req.personal
    const tokens = personal.tokens.filter((tokens) => tokens.token != req.token)
    personal.tokens = tokens
    personal.save().then((result) => {
        res.status(200).send(result)
    }).catch((e) => {
        res.status(400).send(e.message)
    })
})

router.post('/personal/logoutAll', personalAuth, (req, res) => {
    const personal = req.personal
    personal.tokens = []
    personal.save().then((result) => {
        res.status(200).send(result)
    }).catch((e) => {
        res.status(400).send(e.message)
    })
})

router.post('/personal/check', personalAuth, (req, res) => {
    Personal.checkMobileNo(req.body.mobileNo).then((result) => {
        res.send(result)
    }).catch((e) => {
        res.send(e.message)
    })
})

router.get('/personal/me', personalAuth, (req, res) => {
    res.status(200).send(req.personal)
})


router.post('/personal/sendMoney', personalAuth, async(req, res) => {
    const pinCode = req.body.pinCode
    const amount = req.body.amount
    const transactionType = req.body.transactionType

    const isMatch = await bcrypt.compare(pinCode, req.personal.pinCode)
    if (isMatch) {
        const senderPersonal = req.personal
        const receiverPersonal = await Personal.findOne({ mobileNo: req.body.receiver })

        if (senderPersonal.balance > amount) {
            const transaction = new Transaction({ transactionType, amount })
            await transaction.save()

            senderPersonal.balance = senderPersonal.balance - transaction.amount
            receiverPersonal.balance = receiverPersonal.balance + transaction.amount
            await senderPersonal.save()
            await receiverPersonal.save()

            const sendMoney = new Sendmoney({ transaction: transaction._id, sender: senderPersonal._id, receiver: receiverPersonal._id })
            await sendMoney.save()
            return res.status(200).send(sendMoney)
        } else {
            return res.status(400).send({ message: "Insufficient Balance" })
        }

    } else {
        return res.status(400).send()
    }
})

router.post('/personal/payment', personalAuth, async(req, res) => {
    const pinCode = req.body.pinCode
    const amount = req.body.amount
    const transactionType = req.body.transactionType

    const isMatch = await bcrypt.compare(pinCode, req.personal.pinCode)
    if (isMatch) {
        const senderPersonal = req.personal
        const merchant = await Merchant.findOne({ mobileNo: req.body.receiver })

        if (senderPersonal.balance > amount) {
            const transaction = new Transaction({ transactionType, amount })
            await transaction.save()

            senderPersonal.balance = senderPersonal.balance - transaction.amount
            merchant.balance = merchant.balance + transaction.amount
            await senderPersonal.save()
            await merchant.save()

            const payment = new Payment({ transaction: transaction._id, sender: senderPersonal._id, receiver: merchant._id })
            await payment.save()
            return res.status(200).send(sendMoney)
        } else {
            return res.status(400).send({ message: "Insufficient Balance" })
        }

    } else {
        return res.status(400).send()
    }
})

// agent registration

router.post('/agent/registerClient', async(req, res) => {
    try {
        const client = new Client(req.body)
        await client.save()
        res.status(201).send({ client_id: client._id })
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

// register agent account

router.post('/agent/registerAccount', async(req, res) => {
    try {
        const agent = new Agent(req.body)
        await agent.save()
        res.status(201).send(agent._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

var cpUpload = upload.fields([{ name: 'accountID', maxCount: 1 }, { name: 'IDFront', maxCount: 1 }, { name: 'IDBack', maxCount: 1 }, { name: 'currentPhoto', maxCount: 1 }, { name: 'tradeLicencePhoto', maxCount: 1 }])

router.post('/agent/verifyAccount', cpUpload, async(req, res) => {
    try {
        const agentVerification = new AgentVerification({
            agent: req.body.accountID,
            IDFront: req.files.IDFront[0].buffer,
            IDBack: req.files.IDBack[0].buffer,
            currentPhoto: req.files.currentPhoto[0].buffer,
            tradeLicencePhoto: req.files.tradeLicencePhoto[0].buffer
        })
        await agentVerification.save()
        res.status(201).send(agentVerification._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

router.post('/agent/login', async(req, res) => {
    try {
        const agent = await Agent.authenticate(req.body.mobileNo, req.body.pinCode)
        if (!agent.verified) {
            res.status(200).send({ message: "Account Verification Still in Progress" })
        } else {
            const token = await agent.generateAuthToken()
            res.status(200).send({ agent, token })
        }
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

router.post('/agent/logout', agentAuth, async(req, res) => {
    try {
        const agent = req.agent;
        const tokens = agent.tokens.filter((tokens) => tokens.token != req.token)
        agent.tokens = tokens
        await agent.save()
        res.status(200).send()
    } catch (e) {
        res.send(e.message)
    }
})

router.post('/agent/logoutAll', agentAuth, async(req, res) => {
    try {
        const agent = req.agent;
        agent.tokens = []
        await agent.save()
        res.status(200).send()
    } catch (e) {
        res.send(e.message)
    }
})

// agent -> personaal cash in

router.post('/agent/cashIn', agentAuth, async(req, res) => {
    try {
        const agent = req.agent;
        const mobileNo = req.body.mobileNo;
        const personal = await Personal.findOne({ mobileNo: mobileNo })

        const isMatch = await bcrypt.compare(req.body.pinCode, agent.pinCode)
        if (isMatch) {
            if (agent.balance > req.body.amount) {
                const transaction = new Transaction({ transactionType: req.body.transactionType, amount: req.body.amount })

                agent.balance = agent.balance - transaction.amount
                personal.balance = personal.balance + transaction.amount

                await transaction.save()
                await agent.save()
                await personal.save()

                const cashIn = new CashIn({ transaction: transaction._id, sender: agent._id, receiver: personal._id })
                await cashIn.save()
                return res.status(200).send(cashIn)
            } else {
                res.status(402).send('Insufficient Balance')
            }
        } else {
            res.status(401).send('Incorrect Pincode')
        }
    } catch (e) {
        res.status(502).send(e.message)
    }
})

// personal -> agent cash out
router.post('/personal/cashOut', personalAuth, async(req, res) => {
    try {
        const personal = req.personal
        const agent = await Agent.findOne({ mobileNo: req.body.mobileNo })
        const isMatch = await bcrypt.compare(req.body.pinCode, agent.pinCode)
        if (isMatch) {
            const amount = parseFloat(req.body.amount)
            const charge = parseFloat(req.body.charge)

            if (personal.balance > amount + charge) {
                const transaction = new Transaction({ transactionType: req.body.transactionType, amount: (amount + charge) })
                agent.balance = agent.balance + amount + (.25 * charge)
                personal.balance = personal.balance - amount - charge

                await transaction.save()
                await agent.save()
                await personal.save()

                const cashOut = new CashOut({ transaction: transaction._id, sender: personal._id, receiver: agent._id })
                await cashOut.save()
                return res.status(200).send(cashOut)
            } else {
                res.status(402).send('Insufficient Balance')
            }
        } else {
            res.status(401).send('Incorrect Pincode')
        }

    } catch (e) {
        res.send(e.message)
    }
})

// merchant registration

router.post('/merchant/registerClient', async(req, res) => {
    try {
        const client = new Client(req.body)
        await client.save()
        res.status(201).send({ client_id: client._id })
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

// register merchant account

router.post('/merchant/registerAccount', async(req, res) => {
    try {
        const merchant = new Merchant(req.body)
        await merchant.save()
        res.status(201).send(agent._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})

var cpUpload = upload.fields([{ name: 'accountID', maxCount: 1 }, { name: 'IDFront', maxCount: 1 }, { name: 'IDBack', maxCount: 1 }, { name: 'currentPhoto', maxCount: 1 }, { name: 'tradeLicencePhoto', maxCount: 1 }])

router.post('/merchant/verifyAccount', cpUpload, async(req, res) => {
    try {
        const merchantVerification = new MerchantVerification({
            personal: req.body.accountID,
            IDFront: req.files.IDFront[0].buffer,
            IDBack: req.files.IDBack[0].buffer,
            currentPhoto: req.files.currentPhoto[0].buffer,
            tradeLicencePhoto: req.files.tradeLicencePhoto[0].buffer
        })
        await merchantVerification.save()
        res.status(201).send(agentVerification._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
    }
})




module.exports = router