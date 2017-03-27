/* require module */

const mongoose = require("mongoose");

let partySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    uniqueId: {
        type: Number,
        required: true
    },
    location: {
        type: String
    },    
    startDateTime: {
        type: String
    },
    host: {
        type: String
    },
    rules: [{
        rule: {
            type: String
        }
    }],
    partyType: {
        type: String
    },
    image: {
        type: String
    },
    inviteesList: [{
        inviteeUsername: {
            type: String
        }
    }],
    participantsList: [{
        participantUsername: {
            type: String
        }
    }]
});

mongoose.model("Party", partySchema);
module.exports = mongoose.model("Party");