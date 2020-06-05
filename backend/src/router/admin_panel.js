const router = require('express').Router()

router.get('', (req, res) => {
    return res.render('index', { title: 'Shonchoy' })
})

router.get('/signup', (req, res) => {
    return res.render('signup', { title: 'Sign Up' })
})

router.get('/home', (req, res) => {
    return res.render('home', { title: 'Home', options: ['Personal', 'Agent', 'Merchant'] })
})

module.exports = router