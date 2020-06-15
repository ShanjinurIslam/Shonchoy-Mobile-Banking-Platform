const mongoose = require('mongoose')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')


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
        type: String,
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
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }]
})


merchantSchema.methods.generateAuthToken = async function() {
    const merchant = this
    const token = jwt.sign({ _id: merchant._id }, 'abc123')
    merchant.tokens = merchant.tokens.concat({ token })
    await merchant.save()
    return token
}

merchantSchema.methods.checkAuth = function(token) {
    const merchant = this
    const filtered = merchant.tokens.filter((tokens) => tokens.token == token)
    if (filtered.length > 0) {
        return true
    }
    return false
}

merchantSchema.statics.checkMobileNo = async function(mobileNo) {
    const merchant = await merchant.findOne({ mobileNo: mobileNo })
    if (!merchant) {
        throw new Error('No user found')
    } else {

        return merchant
    }
}

merchantSchema.statics.authenticate = async function(mobileNo, pinCode) {
    const merchant = await Merchant.findOne({ mobileNo: mobileNo })

    if (!merchant) {
        throw new Error('No user found')
    }

    const isMatch = await bcrypt.compare(pinCode, merchant.pinCode)

    if (!isMatch) {
        throw new Error('Incorrect Pincode')
    } else {
        return merchant
    }
}

merchantSchema.pre('save', async function(next) {
    const merchant = this
    if (merchant.isModified('pinCode')) {
        merchant.pinCode = await bcrypt.hash(merchant.pinCode, 8)
    }
    next()
})

const Merchant = mongoose.model('Merchant', merchantSchema)

module.exports = Merchant