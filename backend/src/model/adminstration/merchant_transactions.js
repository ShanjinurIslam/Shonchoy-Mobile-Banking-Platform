const mongoose = require('mongoose')

const MerchantTransactionSchema = new mongoose.Schema({
    transactionType: {
        type: String,
        required: true
    },
    merchant: {
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

const MerchantTransactions = mongoose.model('MerchantTransaction', MerchantTransactionSchema)

module.exports = MerchantTransactions