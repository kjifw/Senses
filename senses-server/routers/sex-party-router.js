/* require module */

module.exports = function(app, data) {
    const express = require("express");
    const partyController = require("../controllers/sex-party-controller")(data);

    const partyRouter = express.Router();

    partyRouter
        .get("/list/closest", partyController.getClosestParties)
        .post("/create", partyController.createParty)
        .get("/:id/details", partyController.getPartyDetails)
        .get("/:id/participants", partyController.getParticipants)
        .get("/:id/invitees", partyController.getInvitees);

    app.use("/party", partyRouter);
}