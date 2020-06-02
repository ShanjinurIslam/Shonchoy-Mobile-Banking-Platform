const mongoose = require('mongoose')

const paymentSchema = new mongoose.Schema({
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
        ref: 'Merchant'
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const Payment = mongoose.model('Payment', paymentSchema)
module.exports = Payment