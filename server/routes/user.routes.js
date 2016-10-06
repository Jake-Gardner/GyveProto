const User = require("../models/User");

module.exports = (nonAuthRouter) => {
	nonAuthRouter.get("/user/:id", (req, res) => {
		console.log(`User info for user ${req.params.id} requested`);

		User.findById(req.params.id)
			.then(user => {
				if (user) {
					return user;
				}

				// Create new user if one doesn't exist for this id
				console.log("No user with id " + req.params.id + " found, creating new one");

				return User.create({
					_id: req.params.id
				});
			})
			.then(user => res.json(user))
			.catch(err => res.status(500).send(err));
	});
};
