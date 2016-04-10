"use strict";

var mongoose = require("mongoose");
var express = require("express");
var bodyParser = require("body-parser");
var config = require("./config");
var User = require("./models/User");

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

var authRouter = express.Router();
authRouter.use(function (req, res, next) {
	if (req.headers.authorization) {
		User.findOne({
			fbId: req.headers.authorization
		}).then(function (user) {
			if (user) {
				req.user = user;
				next();
			} else {
				res.sendStatus(401);
			}
		});
	} else {
		res.sendStatus(401);
	}
});

var nonAuthRouter = express.Router();

app.use("/", nonAuthRouter);
app.use("/", authRouter);

require("./routes/user.routes.js")(nonAuthRouter, authRouter);
require("./routes/thing.routes.js")(nonAuthRouter, authRouter);
require("./routes/admin.routes.js")(nonAuthRouter, authRouter);

http.listen(config.port, function () {
	console.log("App listening at " + config.host + ":" + config.port);
});

require("./socket.io")(http);
