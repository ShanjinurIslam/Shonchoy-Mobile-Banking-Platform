const router = require('express').Router()

// test apis
router.get('', (req, res) => {
    res.send({ appName: 'Mobile Banking' })
})

router.post('', (req, res) => {
    console.log(req.body)
    res.send({ appName: 'Mobile Banking' })
})


module.exports = router