const mongoose = require('mongoose')

const AgentVerificationSchema = new mongoose.Schema({
    agent: {
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

const AgentVerification = mongoose.model('AgentVerification', AgentVerificationSchema)

module.exports = AgentVerification