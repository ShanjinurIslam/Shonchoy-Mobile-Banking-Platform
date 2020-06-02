const mongoose = require('mongoose')

const agentSchema = new mongoose.Schema({
    client: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Client',
    },
    TLN: {
        type: Number,
        required: true,
        unique: true,
    },
    email: {
        type: String,
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
    businessOrganizationName: {
        type: String,
        required: true,
    },
    businessAddress: {
        type: String,
        required: true,
    },
    balance: {
        type: Number,
        default: 0,
    },
    verified: {
        type: Boolean,
        default: false
    }
})

const agent = mongoose.model('Agent', agentSchema)

module.exports = agent