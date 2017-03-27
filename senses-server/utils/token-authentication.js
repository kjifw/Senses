/* require module */

const jwt = require("jwt-simple");
const config = require("../config/passport/config");

module.exports = function (token) {
    if (token) {
        try {
            var decoded = jwt.decode(token, config.jwtSecret);
            return true;
        } catch (err) {
            return false;
        }
    } else {
        return false;
    }
}