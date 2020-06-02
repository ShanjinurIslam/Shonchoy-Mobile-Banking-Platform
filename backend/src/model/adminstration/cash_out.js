const mongoose = require('mongoose')

const CashOutSchema = new mongoose.Schema({
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
        ref: 'Agent'
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const CashOut = mongoose.model('CashOut', CashOutSchema)
module.exports = CashOut