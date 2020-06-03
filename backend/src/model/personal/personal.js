const mongoose = require('mongoose')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')

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
        type: String,
        required: true,
    },
    balance: {
        type: Number,
        default: 0,
    },
    verified: {
        type: Boolean,
        default: false,
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }]
})

PersonalSchema.methods.generateAuthToken = async function() {
    const personal = this
    const token = jwt.sign({ _id: personal._id }, 'abc123')
    personal.tokens = personal.tokens.concat({ token })
    await personal.save()
    return token
}

PersonalSchema.methods.checkAuth = function(token) {
    const personal = this
    const filtered = personal.tokens.filter((tokens) => tokens.token == token)
    if (filtered.length > 0) {
        return true
    }
    return false
}

PersonalSchema.statics.checkMobileNo = async function(mobileNo) {
    const personal = await Personal.findOne({ mobileNo: mobileNo })
    if (!personal) {
        throw new Error('No user found')
    } else {
        return personal
    }
}

PersonalSchema.statics.authenticate = async function(mobileNo, pinCode) {
    const personal = await Personal.findOne({ mobileNo: mobileNo })

    if (!personal) {
        throw new Error('No user found')
    }

    const isMatch = await bcrypt.compare(pinCode, personal.pinCode)

    if (!isMatch) {
        throw new Error('Incorrect Pincode')
    } else {
        return personal
    }
}

PersonalSchema.pre('save', async function(next) {
    const personal = this
    if (personal.isModified('pinCode')) {
        personal.pinCode = await bcrypt.hash(personal.pinCode, 8)
    }
    next()
})

const Personal = mongoose.model('Personal', PersonalSchema)

module.exports = Personal