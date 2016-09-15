const multer = require("multer");
const _ = require("lodash/core");
const Image = require("../models/Image");
const Thing = require("../models/Thing");
const config = require("../config");

//TODO: move db queries into a different file

module.exports = (nonAuthRouter, authRouter) => {
	authRouter.post("/thing", multer().single("image"), (req, res) => {
		var title = (req.query.title || "").trim();
		console.log("Received image " + title + " of size " + req.file.size);

		Image.create({
			data: req.file.buffer
		}).then(function (img) {
			return Thing.create({
				image: img._id,
				givenBy: req.user._id,
				title: title,
				location: [req.query.longitude, req.query.latitude]
			});
		}).then(function () {
			res.sendStatus(200);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	nonAuthRouter.get("/things", function (req, res) {
		var coordinates = [req.query.longitude, req.query.latitude];
		var maxDist = config.maxDistanceKm / 6371 / Math.PI * 180;	//Convert km to degrees

		console.log("Thing list requested at location: ", coordinates);

		const query = req.user ? {
			givenBy: {$ne: req.user._id},
			gottenBy: {$not: {$elemMatch: {$eq: req.user._id}}},
			passedBy: {$not: {$elemMatch: {$eq: req.user._id}}},
			junkedBy: {$not: {$elemMatch: {$eq: req.user._id}}},
			location: {$near: coordinates, $maxDistance: maxDist}
		} : {
			location: {$near: coordinates, $maxDistance: maxDist}
		}

		//TODO: maybe remove values that aren't needed by client?
		Thing.find(query)
		.limit(config.maxItemResults)
		.then(function (things) {
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
