const mongoose = require('mongoose')

const merchantSchema = new mongoose.Schema({
    client: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Client',
    },
    TLN: {
        type: Number,
        required: true,
        unique: true,
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
    businessType: {
        type: String,
        required: true,
    },
    businessEmail: {
        type: String,
    },
    webAddress: {
        type: String,
        required: true,
    },
    averageMonthlyPayment: {
        type: Number,
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

const merchant = mongoose.model('Merchant', merchantSchema)

module.exports = merchant