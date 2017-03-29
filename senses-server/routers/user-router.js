/* require module */

module.exports = function (app, data) {
    const express = require("express");
    const authController = require("../controllers/auth-controller")(data);
    const userController = require("../controllers/user-controller")(data);

    const userRouter = express.Router();

    userRouter
        .post("/login", authController.login)
        .post("/register", authController.register)
        .post("/register/username", authController.checkIfUserExists)
        .post("/profile", userController.getUserDetails)
        .put("/profile", userController.updateUserProfile)
        .put("/profile/kudos", userController.updateUserKudos)
        .get("/list/top", userController.getTopUsers)
        .get("/list/all", userController.getAllUsers)
        .post("/invitations", userController.getUserInvitationsList)
        .post("/invitations/create", userController.createInvitation)
        .post("/invitations/accept", userController.acceptInvitation)
        .post("/invitations/reject", userController.rejectInvitation)
        .post("/history", userController.getUserHistory)
        .post("/settings", userController.getUserSettings)
        .post("/information", userController.getUserInformation);

    app.use("/user", userRouter);
}