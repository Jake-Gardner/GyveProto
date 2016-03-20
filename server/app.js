"use strict";

var mongoose = require("mongoose");
var express = require("express");
var bodyParser = require("body-parser");

var config = require("./config");

var db = mongoose.connect(config.dbUri, {});
var app = express();

app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());

app.listen(config.port, config.host, function () {
	console.log("App listening at " + config.host + ":" + config.port);
});

require("./routes/thing.routes.js")(app);
