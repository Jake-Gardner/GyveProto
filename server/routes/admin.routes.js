const User = require("../models/User");
const Image = require("../models/Image");
const Thing = require("../models/Thing");

module.exports = function (nonAuthRouter) {
	nonAuthRouter.get("/admin", function (req, res) {
		var getThings = Thing.find().populate("givenBy gottenBy passedBy junkedBy");
		Promise.all([User.find(), getThings]).then(([users, things]) => {
			res.render("admin", {
				users: users || [],
				things: things || []
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	nonAuthRouter.get("/admin/chat/:userId", function (req, res) {
		var promises = [User.findById(req.params.userId)];

		if (req.query.with) {
			if (req.params.userId === req.query.with) {
				res.status(400).send("No chatting with yourself, jackass.");
				return;
			}

			promises.push(User.findById(req.query.with));
		}

		Promise.all(promises).then(([user, otherUser]) => {
			res.render("admin-chat", {
				userId: user._id,
				otherUserId: otherUser ? otherUser._id : null
			});
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	nonAuthRouter.get("/admin/chat", function (req, res) {
		res.render("admin-chat");
	});

	nonAuthRouter.get("/admin/removeUser/:id", function (req, res) {
		User.findByIdAndRemove(req.params.id).then(function () {
			res.redirect("/admin");
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});

	nonAuthRouter.get("/admin/removeThing/:id", function (req, res) {
		Thing.findByIdAndRemove(req.params.id).then(function () {
			res.redirect("/admin");
		}).catch(function (err) {
			res.status(500).send(err);
		});
	});
};
