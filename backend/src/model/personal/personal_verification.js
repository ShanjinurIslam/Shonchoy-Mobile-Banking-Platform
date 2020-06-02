const mongoose = require('mongoose')

const PersonalVerificationSchema = new mongoose.Schema({
    accout: {
        type: mongoose.Schema.type.ObjectId,
        ref: 'Personal'
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

const PersonalVerification = mongoose.model('PersonalVerification', PersonalVerificationSchema)

module.exports = PersonalVerification