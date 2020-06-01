const mongoose = require('mongoose')

const sendMoneySchema = new mongoose.Schema({
    transactionType: {
        type: String,
        required: true
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Account'
    },
    receiver: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Account'
    },
    amount: {
        type: Number,
        required: true
    },
    charge: {
        type: Number,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const SendMoney = mongoose.model('SendMoney', sendMoneySchema)
module.exports = SendMoney