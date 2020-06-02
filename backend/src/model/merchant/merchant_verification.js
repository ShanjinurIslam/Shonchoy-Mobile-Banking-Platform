const mongoose = require('mongoose')

const MerchantVerificationSchema = new mongoose.Schema({
    accout: {
        type: mongoose.Schema.type.ObjectId,
        ref: 'Agent'
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
    tradeLicencePhoto: {
        type: Buffer,
        required: true,
    },
    createdAt: {
        type: Boolean,
        default: Date.now()
    }
})

const MerchantVerification = mongoose.model('MerchantVerification', MerchantVerificationSchema)

module.exports = MerchantVerification