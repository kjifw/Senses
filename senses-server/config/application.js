/* globals require module */

const express = require("express");
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const cors = require("cors");

const config = require("./index");
const data = require("../data")(config);

let app = express();

// app.set("/static", express.static("../public"));

app.use(bodyParser.json());
app.use(cookieParser());
app.use(bodyParser.urlencoded({
    extended: false
}));

app.use(cors());

require("./passport")(app, data);
require("../routers")(app, data);

module.exports = app;