const mongoose = require('mongoose')

const balaceSchema = new mongoose.Schema({
    balance: {
        type: Number,
        default: 0
    }
})