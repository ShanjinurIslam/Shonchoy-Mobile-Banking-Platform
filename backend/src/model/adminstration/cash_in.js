const mongoose = require('mongoose')

const CashInSchema = new mongoose.Schema({
    transactionType: {
        type: String,
        required: true
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Personal'
    },
    receiver: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Agent'
    },
    amount: {
        type: Number,
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const CashIn = mongoose.model('CashIn', CashInSchema)
module.exports = CashIn