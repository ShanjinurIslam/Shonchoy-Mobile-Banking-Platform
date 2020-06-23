// packages
const express = require('express')
const bodyParser = require('body-parser')
const session = require('express-session')
const path = require('path')
const hbs = require('hbs')
const cookieParser = require('cookie-parser')
const http = require('http')

// path setup
const publicPath = path.join(__dirname, '../public')
const viewsPath = path.join(__dirname, '../templates/views')
const partialsPath = path.join(__dirname, '../templates/partials')

// singleton db call
require('./db/mongoose')

// routers
const api = require('./router/api')
const admin = require('./router/admin_panel')

// initialized app
var app = express()

// session
app.use(cookieParser())
app.set('trust proxy', 1) // trust first proxy
app.use(session({
        secret: 'keyboard cat',
        resave: false,
        saveUninitialized: true,
        cookie: { secure: true, path: '/', maxAge: 245600 }
    }))
    // no cache
app.use((req, res, next) => {
    res.set('Cache-Control', 'no-store')
    next()
})

// bodyParser

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }))

// parse application/json
app.use(bodyParser.json())

// view engine setup
app.use(express.static(publicPath))
app.set('view engine', 'hbs')
app.set('views', viewsPath)

// hbs setup
hbs.registerPartials(partialsPath)
hbs.registerHelper('capitalize', function(str) {
    return str.charAt(0).toUpperCase() + str.slice(1)
});
hbs.registerHelper('toLowerCase', function(str) {
    return str.toLowerCase()
});

// add routers to app
app.use('/api', api)
app.use('', admin)

const server = http.createServer(app)
server.listen(3000, '127.0.0.1', function() {
    server.close(function() {
        server.listen(8080, '192.168.0.101')
    })
})