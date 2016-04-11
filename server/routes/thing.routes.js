"use strict";

var multer = require("multer");
var _ = require("lodash/core");
var Promise = require("bluebird");
var Image = require("../models/Image");
var Thing = require("../models/Thing");

//TODO: move db queries into a different file

module.exports = function (nonAuthRouter, authRouter) {
	authRouter.post("/thing", multer().single("image"), function (req, res) {
		var title = (req.query.title || "").trim();
		console.log("Received image " + title + " of size " + req.file.size);

		Image.create({
			data: req.file.buffer
		}).then(function (img) {
			return Thing.create({
				image: img._id,
				givenBy: req.user._id,
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

		//TODO: maybe remove values that aren't needed by client?
		Thing.find({
			givenBy: {$ne: req.user._id},
			gottenBy: {$not: {$elemMatch: {$eq: req.user._id}}},
			passedBy: {$not: {$elemMatch: {$eq: req.user._id}}},
			junkedBy: {$not: {$elemMatch: {$eq: req.user._id}}}
		}).then(function (things) {
			res.json({
				things: things
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	nonAuthRouter.get("/image/:id", function (req, res) {
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

	//TODO: reduce duplication here (basic 200/500 handling)

	authRouter.post("/thing/get/:id", function (req, res) {
		Thing.update({_id: req.params.id}, {
			$addToSet: {gottenBy: req.user._id}
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	authRouter.post("/thing/pass/:id", function (req, res) {
		Thing.update({_id: req.params.id}, {
			$addToSet: {passedBy: req.user._id}
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	authRouter.post("/thing/junk/:id", function (req, res) {
		Thing.update({_id: req.params.id}, {
			$addToSet: {junkedBy: req.user._id}
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});
};
