"use strict";

var multer = require("multer");
var _ = require("lodash/core");
var Image = require("../models/Image");

module.exports = function (app) {
	app.post("/image", multer().single("image"), function (req, res) {
		console.log("Received image " + req.file.originalName + " of size " + req.file.size);

		Image.create({
			data: req.file.buffer
		}, function (err) {
			if (err) {
				res.status(500).send(err);
			} else {
				res.sendStatus(200);
			}
		});
	});

	app.get("/thingIds", function (req, res) {
		console.log("Id list requested");

		Image.find(function (err, images) {
			if (err) {
				res.status(500).send(err);
			} else if (images.length > 0) {
				var ids = _.map(images, "_id");
				res.json({
					ids: ids
				});
			} else {
				res.sendStatus(404);
			}
		});
	});

	app.get("/thing/:id", function (req, res) {
		console.log("Item of id " + req.params.id + " requested");

		Image.findById(req.params.id, function (err, image) {
			if (err && err.name === "CastError") {
				res.sendStatus(404);
			} else if (err) {
				res.status(500).send(err);
			} else {
				res.type("png").send(image.data);
			}
		});
	});
};
