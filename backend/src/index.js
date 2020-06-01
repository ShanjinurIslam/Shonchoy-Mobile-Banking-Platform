// packages
const express = require('express')
const bodyParser = require('body-parser')
const session = require('express-session')

// singleton db call
require('./db/mongoose')

// routers
const api = require('./router/api')

// initialized app
var app = express()

// session
app.set('trust proxy', 1) // trust first proxy
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true }
}))

// bodyParser

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }))

// parse application/json
app.use(bodyParser.json())

// add routers to app
app.use('/api', api)

app.listen(3000, () => {
    console.log('Server started at Port 3000')
})