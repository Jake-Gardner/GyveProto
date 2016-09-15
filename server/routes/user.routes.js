"use strict";

var User = require("../models/User");

module.exports = function (nonAuthRouter) {
	nonAuthRouter.get("/user/:id", function (req, res) {
		console.log("User info for user " + req.params.id + " requested");

		//todo: this would just be on req.user
		User.findById(req.params.id).then(function (user) {
			if (user) {
				return user;
			}

			// Create new user if one doesn't exist for this id
			console.log("No user with id " + req.params.id + " found, creating new one");

			return User.create({
				_id: req.params.id
			});
		}).then(function (user) {
			res.json(user);
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});
};
