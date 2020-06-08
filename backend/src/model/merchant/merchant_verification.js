const mongoose = require('mongoose')

const MerchantVerificationSchema = new mongoose.Schema({
    accout: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Agent',
        unique: true,
    },
    IDFront: {
        type: Buffer,
        required: true
    },
    IDBack: {
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
        type: Date,
        default: Date.now()
    }
})

const MerchantVerification = mongoose.model('MerchantVerification', MerchantVerificationSchema)

module.exports = MerchantVerification