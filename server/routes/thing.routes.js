"use strict";

var multer = require("multer");
var _ = require("lodash/core");
var Image = require("../models/Image");

module.exports = function (app) {
	app.post("/image", multer().single("image"), function (req, res) {
		console.log("Received image " + req.file.originalName + " of size " + req.file.size);

		Image.create({
			data: req.file.buffer
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	app.get("/thingIds", function (req, res) {
		console.log("Id list requested");

		Image.find().then(function (images) {
			if (images.length > 0) {
				var ids = _.map(images, "id");
				res.json({
					ids: ids
				});
			} else {
				res.sendStatus(404);
			}
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
