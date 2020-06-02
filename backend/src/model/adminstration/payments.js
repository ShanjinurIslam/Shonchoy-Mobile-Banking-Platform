const mongoose = require('mongoose')

const paymentSchema = new mongoose.Schema({
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
        ref: 'Merchant'
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

const Payment = mongoose.model('Payment', paymentSchema)
module.exports = Payment