/* require module */

// const passport = require("passport");
const authenticateToken = require("../utils/token-authentication");

module.exports = function (data) {
    return {
        getTopUsers(req, res) {
            //var isTokenValid = authenticateToken(req.query.token);
            //if (isTokenValid) {
            data.getTopUsersByKudos()
                .then(users => {
                    let usersToReturn = [];

                    users.forEach(item => {
                        usersToReturn.push({
                            username: item.username,
                            picture: item.picture,
                            city: item.city,
                            kudos: item.kudos
                        });
                    });

                    return res.status(200).json({
                        users: usersToReturn,
                        token: req.query.token
                    });
                });
            //} else {
            //    return res.status(403).json({
            //        message: "Not Authenticated"
            //    });
            //}
        },
        getAllUsers(req, res) {
            data.getAllUsers()
                .then(users => {
                    let usersToReturn = [];

                    users.forEach(item => {
                        usersToReturn.push({
                            username: item.username,
                            picture: item.picture,
                            city: item.city,
                            kudos: item.kudos
                        });
                    });

                    return res.status(200).json({
                        users: usersToReturn,
                        token: req.query.token
                    });
                });
        },
        getUserInvitationsList(req, res) {
            data.getUserByUsername(req.body.username)
                .then(user => {
                    let listToReturn = [];

                    user.invitationsList.forEach(item => {
                        listToReturn.push(item.partyId);
                    });

                    return res.status(200).json({
                        invitationsList: listToReturn,
                        token: req.body.token
                    });
                });
        },
        getUserHistory(req, res) {
            data.getUserByUsername(req.body.username)
                .then(user => {
                    let listToReturn = [];

                    user.partyHistory.forEach(item => {
                        listToReturn.push(item.partyId);
                    });

                    return res.status(200).json({
                        partyHistory: listToReturn,
                        token: req.body.token
                    });
                });
        },
        getUserSettings(req, res) {
            data.getUserByUsername(req.body.username)
                .then(user => {
                    return res.status(200).json({
                        settings: {
                            notification: user.notificationSetting,
                            daynight: user.dayNightSetting
                        },
                        token: req.body.token
                    });
                });
        },
        getUserInformation(req, res) {
            data.getUserByUsername(req.body.username)
                .then(user => {
                    return res.status(200).json({
                        about: user.about,
                        token: req.body.token
                    });
                });
        },
        updateUserProfile(req, res) {
            var itemsToUpdate = {
                picture: req.body.picture,
                city: req.body.city,
                genderPreferences: req.body.genderPreferences,
                position: req.body.position,
                about: req.body.about
            };

            data.updateUserProfile(req.body.username, itemsToUpdate)
                .then(user => {
                    return res.status(200).json({
                        user: {
                            username: user.username,
                            email: user.email,
                            picture: user.picture,
                            city: user.city,
                            age: user.age,
                            gender: user.gender,
                            position: user.position,
                            about: user.about,
                            kudos: user.kudos,
                            notificationSetting: user.notificationSetting,
                            dayNightSetting: user.dayNightSetting,
                            partyHistory: user.partyHistory,
                            invitationsList: user.invitationsList,
                            genderPreferences: user.genderPreferences
                        },
                        token: req.body.token
                    });
                });
        },
        updateUserKudos(req, res) {
            data.getUserByUsername(req.body.username)
                .then(user => {
                    let kudos = user.kudos;
                    let newKudos = +req.body.kudos;

                    kudos += newKudos;

                    data.updateUserKudos(req.body.username, kudos)
                        .then(user => {
                            return res.status(200).json({
                                username: req.body.username,
                                kudos: user.kudos,
                                token: req.body.token
                            });
                        });
                });
        },
        getUserDetails(req, res) {
            data.getUserByUsername(req.body.requiredUsername)
                .then(user => {
                    return res.status(200).json({
                        user: {
                            username: user.username,
                            email: user.email,
                            picture: user.picture,
                            city: user.city,
                            age: user.age,
                            gender: user.gender,
                            position: user.position,
                            about: user.about,
                            kudos: user.kudos,
                            genderPreferences: user.genderPreferences,
                            invitationsList: user.invitationsList,
                            partyHistory: user.partyHistory
                        },
                        token: req.body.token
                    });
                });
        },
        createInvitation(req, res) {
            let partyId = +req.body.partyId;
            let inviteeUsername = req.body.inviteeUsername;

            data.getUserByUsername(inviteeUsername)
                .then(user => {
                    data.addUserToInviteesList(user.username, partyId)
                        .then((party) => {
                            data.addPartyToUserInvitationsList(user.username, partyId)
                                .then((user) => {
                                    return res.status(200).json({
                                        party: party.uniqueId,
                                        user: user.username,
                                        token: req.body.token
                                    });
                                })
                                .catch(err => {
                                    return res.status(403).json({
                                        message: err.message
                                    });
                                });
                        })
                        .catch(err => {
                            return res.status(403).json({
                                message: err.message
                            });
                        });
                });
        },
        acceptInvitation(req, res) {
            let partyId = req.body.partyId;
            let inviteeUsername = req.body.inviteeUsername;

            data.getUserByUsername(inviteeUsername)
                .then(user => {
                    data.removeUserFromInviteesList(user.username, partyId)
                        .then(party => {
                            data.addUserToParticipantList(user.username, partyId)
                                .then(party => {
                                    data.removePatyFromUserInvitationsList(user.username, partyId)
                                        .then(user => {
                                            data.addPartyToUserHistoryList(user.username, partyId)
                                                .then(user => {
                                                    return res.status(200).json({
                                                        party: party.uniqueId,
                                                        user: user.username,
                                                        token: req.body.token
                                                    });
                                                })
                                                .catch(err => {
                                                    return res.status(403).json({
                                                        message: err.message
                                                    });
                                                });
                                        });
                                })
                                .catch(err => {
                                    return res.status(403).json({
                                        message: err.message
                                    });
                                });
                        });
                });
        },
        rejectInvitation(req, res) {
            let partyId = req.body.partyId;
            let inviteeUsername = req.body.inviteeUsername;

            data.getUserByUsername(inviteeUsername)
                .then(user => {
                    data.removeUserFromInviteesList(user.username, partyId)
                        .then(party => {
                            data.removePatyFromUserInvitationsList(user.username, partyId)
                                .then(user => {
                                    return res.status(200).json({
                                        party: party.uniqueId,
                                        user: user.username,
                                        token: req.body.token
                                    });
                                });
                        });
                });
        }
    }
}








            // var result = authenticateToken(req.query.token, function () {
            //     data.getAllUsers()
            //         .then(users => {
            //             return res.status(200).json({
            //                 users: users
            //             });
            //         });
            // });

            // if(!result){
            //     return res.status(400).json({
            //         message: "Not Authenticated"
            //     });
            // }