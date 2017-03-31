/* require module */

const hashing = require('../utils/hashing');
const USERNAME_MIN_LENGTH = 3;
const USERNAME_MAX_LENGTH = 30;
const PASSWORD_MIN_LENGTH = 5;
const PASSWORD_MAX_LENGTH = 30;

module.exports = function (models) {
    let User = models.userModel;
    let Party = models.partyModel;

    return {
        createNewUser(user) {
            if (user.username.length < USERNAME_MIN_LENGTH || user.username.length > USERNAME_MAX_LENGTH) {
                return Promise.reject({ reason: `Username must be between ${USERNAME_MIN_LENGTH} and ${USERNAME_MAX_LENGTH} characters long` });
            }

            if (user.password.length < PASSWORD_MIN_LENGTH || user.password.length > PASSWORD_MAX_LENGTH) {
                return Promise.reject({ reason: `Password must be between ${PASSWORD_MIN_LENGTH} and ${PASSWORD_MAX_LENGTH} characters long` });
            }

            const salt = hashing.generateSalt();
            const passHash = hashing.hashPassword(salt, user.password);

            let genderPrefs = []

            user.genderPreferences.split(", ").forEach(item => {
                genderPrefs.push({ gender: item });
            });

            const newUser = new User({
                username: user.username,
                email: user.email,
                passHash,
                salt,
                picture: user.picture || "",
                city: user.city || "",
                age: user.age,
                gender: user.gender,
                genderPreferences: genderPrefs,
                position: user.position,
                about: user.about || "",
                kudos: user.kudos || 0,
                latestPartyHosted: "",
                notificationSetting: user.notificationSetting || "notifications on",
                dayNightSetting: user.dayNightSetting || "day",
                invitationsList: user.invitationsList || [],
                partyHistory: user.partyHistory || []

            });

            return new Promise((resolve, reject) => {
                newUser.save(err => {
                    if (err) {
                        return reject(err);
                    }
                    
                    return resolve(newUser);
                });
            });
        },
        getUserByUsername(username) {
            return new Promise((resolve, reject) => {
                User.findOne({ username: username }, (err, item) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(item);
                });
            });
        },
        getTopUsersByKudos() {
            return new Promise((resolve, reject) => {
                User.find((err, items) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(items);
                }).where("kudos").gt(0).sort({ kudos: -1 }).limit(100);
            });
        },
        getAllUsers() {
            return new Promise((resolve, reject) => {
                User.find((err, items) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(items);
                });
            });
        },
        updateUserProfile(username, itemsToUpdate) {
            return new Promise((resolve, reject) => {
                User.findOneAndUpdate({ username: username }, {
                    $set: {
                        picture: itemsToUpdate.picture,
                        city: itemsToUpdate.city,
                        genderPreferences: itemsToUpdate.genderPreferences,
                        position: itemsToUpdate.position,
                        about: itemsToUpdate.about
                    }
                }, { new: true }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(user);
                })
            });
        },
        updateUserKudos(username, kudos) {
            return new Promise((resolve, reject) => {
                User.findOneAndUpdate({ username: username }, {
                    $set: {
                        kudos: kudos
                    }
                }, { new: true }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(user);
                });
            });
        },
        updateUserPartyHosted(username, partyId) {
            return new Promise((resolve, reject) => {
                User.findOneAndUpdate({ username: username }, {
                    $set: {
                        latestPartyHosted: partyId
                    }
                }, { new: true }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(user);
                });
            });
        },
        addPartyToUserInvitationsList(username, partyId) {
            return new Promise((resolve, reject) => {
                User.findOne({ username: username }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    for (let index = 0; index < user.invitationsList.length; index++) {
                        if (user.invitationsList[index].partyId === partyId) {
                            return reject({
                                message: "Party already in invitations list."
                            });
                        }
                    }

                    user.invitationsList.push({ partyId: partyId });
                    user.save();

                    return resolve(user);
                });
            });
        },
        removePatyFromUserInvitationsList(username, partyId) {
            return new Promise((resolve, reject) => {
                User.findOne({ username: username }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    let invitationsList = [];

                    for (let index = 0; index < user.invitationsList.length; index++) {
                        if (user.invitationsList[index].partyId !== partyId) {
                            invitationsList.push(user.invitationsList[index].partyId);
                        }
                    }

                    user.invitationsList = [];

                    invitationsList.forEach(item => {
                        user.invitationsList.push({ partyId: item });
                    });

                    user.save();

                    return resolve(user);
                });
            });
        },
        addPartyToUserHistoryList(username, partyId) {
            return new Promise((resolve, reject) => {
                User.findOne({ username: username }, (err, user) => {
                    if (err) {
                        return reject(err);
                    }

                    for (let index = 0; index < user.partyHistory.length; index++) {
                        if (user.partyHistory[index].partyId === partyId) {
                            return reject({
                                message: "Party already in history list."
                            });
                        }
                    }

                    user.partyHistory.push({ partyId: partyId });
                    user.save();

                    return resolve(user);
                });
            });
        }
    }
}