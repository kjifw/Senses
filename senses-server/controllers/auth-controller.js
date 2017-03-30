/* require module */

const passport = require("passport");
const jwt = require("jwt-simple");
const config = require("../config/passport/config");

module.exports = function (data) {
    return {
        login(req, res, next) {
            const auth = passport.authenticate('local', function (error, user) {

                if (error) {
                    next(error);
                    return;
                }

                if (!user) {
                    return res.status(405).json("Not authorized.");
                }

                req.login(user, error => {
                    if (error) {
                        next(error);
                        return;
                    }

                    var token = jwt.encode({ username: req.body.username }, config.jwtSecret);

                    data.getUserByUsername(req.body.username)
                        .then(dbUser => {
                            return res.status(200).json({
                                user: {
                                    username: req.user.username,
                                    invitationsList: dbUser.invitationsList,
                                    token: token
                                }
                            });
                        });
                });
            });

            auth(req, res, next);
        },
        register(req, res) {
            let user = {
                username: req.body.username,
                email: req.body.email,
                password: req.body.password,
                age: req.body.age,
                gender: req.body.gender,
                genderPreferences: req.body.genderPreferences,
                // position: req.body.position,
                token: req.body.token
            }

            data.getUserByUsername(req.body.username)
                .then(existingUser => {
                    if (existingUser == null || existingUser == undefined) {
                        data.createNewUser(user)
                            .then(newUser => {
                                req.login(newUser, error => {
                                    if (error) {
                                        next(error);
                                        return;
                                    }
                                });
                                console.log("user registered");
                                return res.status(200).json({
                                    message: "User successfully created.",
                                    user: {
                                        username: newUser.username
                                    }
                                });
                            })
                            .catch(error => res.status(409).json({
                                message: "User already existss."
                            }));
                    } else {
                        return res.status(409).json({
                            message: "User already exists."
                        });
                    }
                });
        },
        checkIfUserExists(req, res) {
            let usernameToFind = req.body.username;

            data.getAllUsers()
                .then(users => {
                    for (let index = 0; index < users.length; index++) {
                        if (usernameToFind === users[index].username) {
                            return res.status(200).json({
                                message: "Username already exists."
                            });
                        }
                    }

                    return res.status(200).json({
                        message: "Username is free.",
                        username: req.body.username
                    });
                });
        }
    }
}