const router = require('express').Router()

// test apis
router.get('', (req, res) => {
    res.send({ appName: 'Mobile Banking' })
})

router.post('', (req, res) => {
    console.log(req.body)
    res.send({ appName: 'Mobile Banking' })
})

// check mobile number if already registered (GENERAL CATAGORY)


// create application
router.post('/postApplication', (req, res) => {

})

module.exports = router