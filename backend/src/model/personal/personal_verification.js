const mongoose = require('mongoose')

const PersonalVerificationSchema = new mongoose.Schema({
    personal: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Personal',
        unique: true
    },
    IDFront: {
        type: Buffer,
        //required: true
    },
    IDBack: {
        type: Buffer,
        //required: true
    },
    currentPhoto: {
        type: Buffer,
        //required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
})

const PersonalVerification = mongoose.model('PersonalVerification', PersonalVerificationSchema)

module.exports = PersonalVerification