const User = require("../models/User");
const Image = require("../models/Image");
const Thing = require("../models/Thing");

module.exports = nonAuthRouter => {
	nonAuthRouter.get("/admin", (req, res) => {
		const getThings = Thing.find().populate("givenBy gottenBy passedBy junkedBy");
		Promise.all([User.find(), getThings])
			.then(([users, things]) => {
				res.render("admin", {
					users: users || [],
					things: things || []
				});
			})
			.catch(err => res.status(500).send(err));
	});

	nonAuthRouter.get("/admin/chat/:userId", (req, res) => {
		const promises = [User.findById(req.params.userId)];

		if (req.query.with) {
			if (req.params.userId === req.query.with) {
				res.status(400).send("No chatting with yourself, jackass.");
				return;
			}

			promises.push(User.findById(req.query.with));
		}

		Promise.all(promises)
			.then(([user, otherUser]) => {
				res.render("admin-chat", {
					userId: user._id,
					otherUserId: otherUser ? otherUser._id : null
				});
			})
			.catch(err => res.status(500).send(err));
	});

	nonAuthRouter.get("/admin/chat", (req, res) => {
		res.render("admin-chat");
	});

	nonAuthRouter.get("/admin/removeUser/:id", (req, res) => {
		User.findByIdAndRemove(req.params.id)
			.then(() => res.redirect("/admin"))
			.catch(err => res.status(500).send(err));
	});

	nonAuthRouter.get("/admin/removeThing/:id", (req, res) => {
		Thing.findByIdAndRemove(req.params.id)
			.then(() => res.redirect("/admin"))
			.catch(err => res.status(500).send(err));
	});
};
