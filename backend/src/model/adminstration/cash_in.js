const mongoose = require('mongoose')

const CashInSchema = new mongoose.Schema({
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

const CashIn = mongoose.model('CashIn', CashInSchema)
module.exports = CashIn