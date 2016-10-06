const multer = require("multer");
const _ = require("lodash/core");
const Image = require("../models/Image");
const Thing = require("../models/Thing");
const config = require("../config");

// TODO: move db queries into a different file

module.exports = (nonAuthRouter, authRouter) => {
	authRouter.post("/thing", multer().single("image"), (req, res) => {
		const title = (req.query.title || "").trim();
		console.log(`Received image ${title} of size ${req.file.size}`);

		Image.create({
			data: req.file.buffer
		})
			.then(img =>
				Thing.create({
					image: img._id,
					givenBy: req.user._id,
					title,
					condition: req.query.condition,
					location: [req.query.longitude, req.query.latitude]
				}))
			.then(() => res.sendStatus(200))
			.catch(err => res.status(500).send(err));
	});

	nonAuthRouter.get("/things", (req, res) => {
		const coordinates = [req.query.longitude, req.query.latitude];
		const maxDist = config.maxDistanceKm / 6371 / Math.PI * 180;	// Convert km to degrees

		console.log("Thing list requested at location: ", coordinates);

		const query = req.user ? {
			givenBy: { $ne: req.user._id },
			gottenBy: { $not: { $elemMatch: { $eq: req.user._id } } },
			passedBy: { $not: { $elemMatch: { $eq: req.user._id } } },
			junkedBy: { $not: { $elemMatch: { $eq: req.user._id } } },
			location: { $near: coordinates, $maxDistance: maxDist }
		} : {
			location: { $near: coordinates, $maxDistance: maxDist }
		};

		// TODO: maybe remove values that aren't needed by client?
		Thing.find(query)
			.limit(config.maxItemResults)
			.then(things => res.json({ things }))
			.catch(err => res.status(500).send(err));
	});

	nonAuthRouter.get("/image/:id", (req, res) => {
		console.log(`Item of id ${req.params.id} requested`);

		Image.findById(req.params.id)
			.then(image => res.type("png").send(image.data))
			.catch(err => {
				if (err.name === "CastError") {
					res.sendStatus(404);
				} else {
					res.status(500).send(err);
				}
			});
	});

	// TODO: reduce duplication here (basic 200/500 handling)

	authRouter.post("/thing/get/:id", (req, res) => {
		// TODO: isn't there a findByIdAndUpdate?
		Thing.update({ _id: req.params.id }, {
			$addToSet: { gottenBy: req.user._id }
		})
			.then(() => res.sendStatus(200))
			.catch(err => res.status(500).send(err));
	});

	authRouter.post("/thing/pass/:id", (req, res) => {
		Thing.update({ _id: req.params.id }, {
			$addToSet: { passedBy: req.user._id }
		})
			.then(() => res.sendStatus(200))
			.catch(err => res.status(500).send(err));
	});

	authRouter.post("/thing/junk/:id", (req, res) => {
		Thing.update({ _id: req.params.id }, {
			$addToSet: { junkedBy: req.user._id }
		})
			.then(() => res.sendStatus(200))
			.catch(err => res.status(500).send(err));
	});
};
