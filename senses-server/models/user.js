/* require module */

const mongoose = require("mongoose");

let userCredentialsSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        min: 3,
        max: 30,
        unique: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    passHash: {
        type: String,
        required: true
    },
    salt: {
        type: String,
        required: true
    },
    picture: {
        type: String
    },
    city: {
        type: String
    },
    age: {
        type: Number,
        required: true,
        min: 18,
        max: 58
    },
    gender: {
        type: String
    },
    genderPreferences: [{
        gender: {
            type: String
        }
    }],
    position: {
        type: String
    },
    about: {
        type: String
    },
    kudos: {
        type: Number
    },
    latestPartyHosted: {
        type: String
    },
    notificationSetting: {
        type: String
    },
    dayNightSetting: {
        type: String
    },
    invitationsList: [{
        partyId: {
            type: String
        }
    }],
    partyHistory: [{
        partyId: {
            type: String
        }
    }]
});

mongoose.model("UserCredentials", userCredentialsSchema);
module.exports = mongoose.model("UserCredentials");