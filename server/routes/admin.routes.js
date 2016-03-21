"use strict";

var Promise = require("bluebird");
var User = require("../models/User");
var Image = require("../models/Image");

module.exports = function (app) {
	app.get("/admin", function (req, res) {
		Promise.all([User.find(), Image.find()]).spread(function (users, images) {
			res.render("admin", {
				users: users || [],
				images: images || []
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	app.get("/admin/removeUser/:id", function (req, res) {
		User.findOne({
			fbId: req.params.id
		}).then(function (user) {
			return user.remove();
		}).then(function () {
			res.redirect("/admin");
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	app.get("/admin/removeImage/:id", function (req, res) {
		Image.findById(req.params.id).then(function (image) {
			return image.remove();
		}).then(function () {
			res.redirect("/admin");
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});
};
