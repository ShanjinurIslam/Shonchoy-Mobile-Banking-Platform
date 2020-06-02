const mongoose = require('mongoose')

const chargeSchema = new mongoose.Schema({
    transaction: {
        unique: true,
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Transaction'
    },
    chargeAmount: {
        type: Number,
        required: true
    }
})

const charge = mongoose.model('Charge', chargeSchema)

module.exports = charge