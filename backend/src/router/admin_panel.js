const router = require('express').Router()
const User = require('../model/adminstration/user')
const jwt = require('jsonwebtoken')

const middleware = async(req, res, next) => {
    const decoded = jwt.decode(req.cookies.auth)
    try {
        const user = await User.findById(decoded._id)
        if (user) {
            next()
        } else {
            return res.render('index', { title: 'Shonchoy' })
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
        return res.render('index', { title: 'Shonchoy', error: e.message })
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
    return res.render('home', { title: 'Home', options: ['Personal', 'Agent', 'Merchant'] })
})

module.exports = router