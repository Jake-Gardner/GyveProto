"use strict";

var mongoose = require("mongoose");
var express = require("express");
var bodyParser = require("body-parser");
var config = require("./config");

// Overwrite built-in promise implementation
mongoose.Promise = require("bluebird");
mongoose.connect(config.dbUri, {});

var app = express();

app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());

app.listen(config.port, config.host, function () {
	console.log("App listening at " + config.host + ":" + config.port);
});

require("./routes/user.routes.js")(app);
require("./routes/thing.routes.js")(app);
