/* globals require module */

const config = require("./config");
const app = require("./config/application");

app.listen(config.port, 
    () => console.log(`Magic at work at port: ${config.port}`)
);