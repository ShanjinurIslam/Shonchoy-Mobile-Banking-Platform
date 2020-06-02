const router = require('express').Router()
const Personal = require('../model/personal/personal')
const Client = require('../model/client')
const PersonalVerification = require('../model/personal/personal_verification')

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
        res.status(200).send({ message: 'This number is already registered' })
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


module.exports = router