/* require module */

const authenticateToken = require("../utils/token-authentication");

module.exports = function (data) {
    return {
        createParty(req, res) {
            data.getAllParties()
                .then(parties => {
                    let partyId = parties.length + 1;

                    let party = {
                        name: req.body.name,
                        uniqueId: partyId,
                        location: req.body.location,
                        startDateTime: req.body.startDateTime,
                        host: req.body.host,
                        // rules: req.body.rules,
                        partyType: req.body.partyType,
                        image: req.body.image,
                        // inviteesList: req.body.inviteesList,
                        // participantsList: req.body.participantsList
                    }

                    data.createNewParty(party)
                        .then(newParty => {
                            let participantsList = [];
                            let inviteesList = [];
                            let rules = [];

                            newParty.participantsList.forEach(item => {
                                participantsList.push(item.participantUsername);
                            });

                            newParty.inviteesList.forEach(item => {
                                inviteesList.push(item.inviteeUsername);
                            });

                            newParty.rules.forEach(item => {
                                rules.push(item.rule);
                            });

                            data.addPartyToUserHistoryList(req.body.host, newParty.uniqueId)
                                .then(() => {
                                    return res.status(200).json({
                                        party: {
                                            name: newParty.name,
                                            uniqueId: newParty.uniqueId,
                                            location: newParty.location,
                                            startDateTime: newParty.startDateTime,
                                            host: newParty.host,
                                            partyType: newParty.partyType,
                                            image: newParty.image,
                                            inviteesList: inviteesList,
                                            participantsList: participantsList,
                                            rules: rules
                                        }
                                    });
                                });
                        });
                });
        },
        getClosestParties(req, res) {
            data.getClosestParties(req.body.location)
                .then(parties => {
                    return res.status(200).json({
                        parties: parties
                    });
                });
        },
        getPartyDetails(req, res) {
            data.getPartyById(req.params.id)
                .then(party => {
                    let inviteesList = [];
                    let participantsList = [];
                    let rules = [];

                    party.inviteesList.forEach(item => {
                        inviteesList.push(item.inviteeUsername);
                    });

                    party.participantsList.forEach(item => {
                        participantsList.push(item.participantUsername);
                    });

                    party.rules.forEach(item => {
                        rules.push(item.rule);
                    });

                    let partyToReturn = {
                        name: party.name,
                        uniqueId: party.uniqueId,
                        location: party.location,
                        startDateTime: party.startDateTime,
                        host: party.host,
                        partyType: party.partyType,
                        image: party.image,
                        inviteesList: inviteesList,
                        participantsList: participantsList,
                        rules: rules
                    };

                    return res.status(200).json({
                        party: partyToReturn
                    });
                });
        },
        getParticipants(req, res) {
            data.getPartyById(req.params.id)
                .then(party => {
                    let promiseArr = [];

                    for (var index = 0; index < party.participantsList.length; index++) {
                        let participant = data.getUserByUsername(party.participantsList[index].participantUsername);
                        promiseArr.push(participant);
                    }

                    return promiseArr;
                })
                .then(promiseArr => {
                    Promise.all(promiseArr)
                        .then(participants => {
                            let participantsToReturn = [];

                            participants.forEach(item => {
                                participantsToReturn.push({
                                    username: item.username,
                                    picture: item.picture,
                                    city: item.city,
                                    kudos: item.kudos
                                });
                            });

                            return res.status(200).json({
                                participants: participantsToReturn
                            });
                        })
                        .catch(err => {
                            return res.status(500).json({
                                message: "error"
                            })
                        })
                });
        },
        getInvitees(req, res) {
            data.getPartyById(req.params.id)
                .then(party => {
                    let promiseArr = [];

                    for (var index = 0; index < party.inviteesList.length; index++) {
                        let invitee = data.getUserByUsername(party.inviteesList[index].inviteeUsername);
                        promiseArr.push(invitee);
                    }

                    return promiseArr;
                })
                .then(promiseArr => {
                    Promise.all(promiseArr)
                        .then(invitees => {
                            let inviteesToReturn = [];

                            invitees.forEach(item => {
                                inviteesToReturn.push({
                                    username: item.username,
                                    picture: item.picture,
                                    city: item.city,
                                    kudos: item.kudos
                                });
                            });

                            return res.status(200).json({
                                invitees: inviteesToReturn
                            });
                        })
                        .catch(err => {
                            return res.status(500).json({
                                message: "error"
                            })
                        })
                });
        }
    }
}