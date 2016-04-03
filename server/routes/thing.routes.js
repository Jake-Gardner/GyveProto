"use strict";

var multer = require("multer");
var _ = require("lodash/core");
var Promise = require("bluebird");
var Image = require("../models/Image");
var User = require("../models/User");
var Thing = require("../models/Thing");

module.exports = function (app) {
	app.post("/thing", multer().single("image"), function (req, res) {
		console.log("Received image " + req.query.title + " of size " + req.file.size);

		var makeImage = Image.create({
			data: req.file.buffer
		});
		var getUser = User.findOne({
			fbId: req.query.user
		});

		Promise.all([makeImage, getUser]).spread(function (img, user) {
			return Thing.create({
				image: img._id,
				creator: user._id,
				title: req.query.title
			});
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	app.get("/things", function (req, res) {
		console.log("Thing list requested");

		Thing.find().then(function (things) {
			res.json({
				things: things
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	app.get("/thing/:id", function (req, res) {
		console.log("Item of id " + req.params.id + " requested");

		Image.findById(req.params.id).then(function (image) {
			res.type("png").send(image.data);
		}).catch(function (err) {
			if (err.name === "CastError") {
				res.sendStatus(404);
			} else {
				res.status(500).send(err);
			}
		});
	});
};
