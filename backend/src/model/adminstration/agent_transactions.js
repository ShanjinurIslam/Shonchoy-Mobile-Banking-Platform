const mongoose = require('mongoose')

const AgentTransactionSchema = new mongoose.Schema({
    transactionType: {
        type: String,
        required: true
    },
    merchant: {
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

const AgentTransactions = mongoose.model('AgentTransaction', AgentTransactionSchema)

module.exports = AgentTransactions