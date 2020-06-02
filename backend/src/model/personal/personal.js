const mongoose = require('mongoose')

const PersonalSchema = new mongoose.Schema({
    client: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Client',
    },
    mobileNo: {
        type: String,
        required: true,
        unique: true,
    },
    pinCode: {
        type: Number,
        required: false,
    },
    pinCodeSet: {
        type: Boolean,
        default: false
    },
    balance: {
        type: Number,
        default: 0,
    },
    verified: {
        type: Boolean,
        default: false,
    },
})

const Personal = mongoose.model('Personal', PersonalSchema)

module.exports = Personal