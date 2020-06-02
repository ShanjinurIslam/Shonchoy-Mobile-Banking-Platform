const mongoose = require('mongoose')

const CashOutSchema = new mongoose.Schema({
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
    charge: {
        type: Number,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const CashOut = mongoose.model('CashOut', CashOutSchema)
module.exports = CashOut