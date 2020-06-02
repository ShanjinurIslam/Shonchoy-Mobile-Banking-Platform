const mongoose = require('mongoose')

const AgentVerificationSchema = new mongoose.Schema({
    accout: {
        type: mongoose.Schema.type.ObjectId,
        ref: 'Agent'
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
        type: Boolean,
        default: Date.now()
    }
})

const AgentVerification = mongoose.model('AgentVerification', AgentVerificationSchema)

module.exports = AgentVerification