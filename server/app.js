"use strict";

var mongoose = require("mongoose");
var express = require("express");
var bodyParser = require("body-parser");
var config = require("./config");

// Overwrite built-in promise implementation
mongoose.Promise = require("bluebird");
mongoose.connect(config.dbUri, {});

var app = express();
var http = require("http").Server(app);

app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());
app.set("view engine", "jade");
app.set("views", __dirname + "/views");
app.use(express.static(__dirname + "/public"));

require("./routes/user.routes.js")(app);
require("./routes/thing.routes.js")(app);
require("./routes/admin.routes.js")(app);

http.listen(config.port, function () {
	console.log("App listening at " + config.host + ":" + config.port);
});

require("./socket.io")(http);
