// packages
const express = require('express')
const bodyParser = require('body-parser')
const session = require('express-session')
const path = require('path')
const hbs = require('hbs')

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

app.listen(3000, () => {
    console.log('Server started at Port 3000')
})