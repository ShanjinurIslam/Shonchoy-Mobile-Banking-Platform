const mongoose = require('mongoose')
const Personal = require('../personal/personal')

const sendMoneySchema = new mongoose.Schema({
    transaction: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Transaction'
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Personal'
    },
    receiver: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Personal'
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})


const SendMoney = mongoose.model('SendMoney', sendMoneySchema)
module.exports = SendMoney