/* require module */

module.exports = function (models) {
    let Party = models.partyModel;

    return {
        createNewParty(party) {
            let participants = [];
            participants.push({
                participantUsername: party.host
            });

            const newParty = new Party({
                name: party.name,
                uniqueId: party.uniqueId,
                location: party.location,
                startDateTime: party.startDateTime,
                host: party.host,
                rules: party.rules || [],
                partyType: party.partyType || "normal",
                image: party.image || "",
                inviteesList: party.inviteesList || [],
                participantsList: party.participantsList || participants
            });

            return new Promise((resolve, reject) => {
                newParty.save(err => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(newParty);
                });
            });
        },
        getClosestParties(location) {
            return new Promise((resolve, reject) => {
                Party.find((err, parties) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(parties);
                });
            });
        },
        getAllParties() {
            return new Promise((resolve, reject) => {
                Party.find((err, parties) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(parties);
                });
            });
        },
        getPartyById(partyId) {
            return new Promise((resolve, reject) => {
                Party.findOne({ uniqueId: partyId }, (err, party) => {
                    if (err) {
                        return reject(err);
                    }

                    return resolve(party);
                });
            });
        },
        addUserToInviteesList(username, partyId) {
            return new Promise((resolve, reject) => {
                Party.findOne({ uniqueId: partyId }, (err, party) => {
                    if (err) {
                        return reject(err);
                    }

                    for (let invIndex = 0; invIndex < party.inviteesList.length; invIndex++) {
                        if (party.inviteesList[invIndex].inviteeUsername == username) {
                            return reject({
                                message: "User is already in invitees list."
                            });
                        }
                    }

                    for (let parIndex = 0; parIndex < party.participantsList.length; parIndex++) {
                        if (party.participantsList[parIndex].participantUsername == username) {
                            return reject({
                                message: "User is already in participants list."
                            });
                        }
                    }

                    party.inviteesList.push({ inviteeUsername: username });
                    party.save();

                    return resolve(party);
                });
            });
        },
        removeUserFromInviteesList(username, partyId) {
            return new Promise((resolve, reject) => {
                Party.findOne({ uniqueId: partyId }, (err, party) => {
                    if (err) {
                        return reject(err);
                    }

                    let inviteesList = [];

                    for (let invIndex = 0; invIndex < party.inviteesList.length; invIndex++) {
                        if (party.inviteesList[invIndex].inviteeUsername !== username) {
                            inviteesList.push(party.inviteesList[invIndex].inviteeUsername);
                        }
                    }

                    party.inviteesList = [];

                    inviteesList.forEach(item => {
                        party.inviteesList.push({ inviteeUsername: item });
                    });

                    party.save();

                    return resolve(party);
                });
            });
        },
        addUserToParticipantList(username, partyId) {
            return new Promise((resolve, reject) => {
                Party.findOne({ uniqueId: partyId }, (err, party) => {
                    if (err) {
                        return reject(err);
                    }

                    for (let parIndex = 0; parIndex < party.participantsList.length; parIndex++) {
                        if (party.participantsList[parIndex].participantUsername === username) {
                            return reject({
                                message: "User is already in the participants list."
                            });
                        }
                    }

                    party.participantsList.push({ participantUsername: username});
                    party.save();

                    return resolve(party);
                });
            });
        }
    }
}