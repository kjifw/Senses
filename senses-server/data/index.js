/* globals require module __dirname */ 

const mongoose = require("mongoose");
const fs = require("fs");
const path = require("path");

module.exports = function(config) {
    mongoose.Promise = global.Promise;
    mongoose.connect(config.connectionString);

    let userModel = require("../models/user");
    let partyModel = require("../models/sex-party");

    let models = { userModel, partyModel };

    let data = { };

    fs.readdirSync("./data")
        .filter(x => x.includes("-data"))
        .forEach(file => {
            let dataModule = require(path.join(__dirname, file))(models);

            Object.keys(dataModule)
                .forEach(key => {
                    data[key] = dataModule[key];
                });
        });

    return data;
}