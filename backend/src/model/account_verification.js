const mongoose = require('mongoose')

const AccountVerificationSchema = new mongoose.Schema({
    accout: {
        type: mongoose.Schema.type.ObjectId,
        ref: 'Account'
    },
    NIDFront: {
        type: Buffer,
        required: true
    },
    NIDBack: {
        type: Buffer,
        required: true
    },
    currentPhoto: {
        type: Buffer,
        required: true,
    },
    createdAt: {
        type: Boolean,
        default: Date.now()
    }
})

const AccountVerification = mongoose.model('Account', AccountVerificationSchema)

module.exports = AccountVerification