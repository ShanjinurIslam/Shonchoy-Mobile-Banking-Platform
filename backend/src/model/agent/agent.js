const mongoose = require('mongoose')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')

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
        type: String,
        required: true,
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
    },
    tokens: [{
        token: {
            type: String,
            required: true
        }
    }]
})

agentSchema.methods.generateAuthToken = async function() {
    const agent = this
    const token = jwt.sign({ _id: agent._id }, 'abc123')
    agent.tokens = agent.tokens.concat({ token })
    await agent.save()
    return token
}

agentSchema.methods.checkAuth = function(token) {
    const agent = this
    const filtered = agent.tokens.filter((tokens) => tokens.token == token)
    if (filtered.length > 0) {
        return true
    }
    return false
}

agentSchema.statics.checkMobileNo = async function(mobileNo) {
    const agent = await agent.findOne({ mobileNo: mobileNo })
    if (!agent) {
        throw new Error('No user found')
    } else {
        return agent
    }
}

agentSchema.statics.authenticate = async function(mobileNo, pinCode) {
    const agent = await Agent.findOne({ mobileNo: mobileNo })

    if (!agent) {
        throw new Error('No user found')
    }

    const isMatch = await bcrypt.compare(pinCode, agent.pinCode)

    if (!isMatch) {
        throw new Error('Incorrect Pincode')
    } else {
        return agent
    }
}

agentSchema.pre('save', async function(next) {
    const agent = this
    if (agent.isModified('pinCode')) {
        agent.pinCode = await bcrypt.hash(agent.pinCode, 8)
    }
    next()
})

const Agent = mongoose.model('Agent', agentSchema)

module.exports = Agent