"use strict";

var multer = require("multer");
var _ = require("lodash/core");
var Promise = require("bluebird");
var Image = require("../models/Image");
var Thing = require("../models/Thing");

module.exports = function (nonAuthRouter, authRouter) {
	authRouter.post("/thing", multer().single("image"), function (req, res) {
		var title = (req.query.title || "").trim();
		console.log("Received image " + title + " of size " + req.file.size);

		Image.create({
			data: req.file.buffer
		}).then(function (img) {
			return Thing.create({
				image: img._id,
				creator: req.user._id,
				title: title
			});
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	authRouter.get("/things", function (req, res) {
		console.log("Thing list requested");

		Thing.find().then(function (things) {
			res.json({
				things: things
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	authRouter.get("/thing/:id", function (req, res) {
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
