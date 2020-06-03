const router = require('express').Router()

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
const jwt = require('jsonwebtoken')

// sendmoney

const transaction = require('../model/adminstration/transaction')
const sendmoney = require('../model/adminstration/send_money')

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
    const personal = await Personal.authenticate(req.body.mobileNo, req.body.pinCode)
    if (!personal.verified) {
        res.status(200).send({ message: "Account Verification Still in Progress" })
    } else {
        const token = await personal.generateAuthToken()
        res.status(200).send({ personal, token })
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
    Personal.findOne({ mobileNo: req.body.mobileNo }).then((result) => {
        res.send(result)
    }).catch((e) => {
        res.send(e.message)
    })
})

router.get('/personal/me', personalAuth, async(req, res) => {
    res.status(200).send(req.personal)
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

router.post('/personal/verifyAccount', cpUpload, async(req, res) => {
    try {
        const agentVerification = new AgentVerification({
            personal: req.body.accountID,
            IDFront: req.files.IDFront[0].buffer,
            IDBack: req.files.IDBack[0].buffer,
            currentPhoto: req.files.currentPhoto[0].buffer,
            tradeLicencePhoto: req.files.tradeLicencePhoto[0].buffer
        })
        await AgentVerification.save()
        res.status(201).send(agentVerification._id)
    } catch (e) {
        res.status(502).send({ message: e.message })
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