const User = require("../models/User");
const ChatMessage = require("../models/ChatMessage");

module.exports = server => {
	const io = require("socket.io").listen(server);

	io.on("connection", socket => {
		console.log("user connected");

		socket.on("disconnect", () => {
			console.log("user disconnected");
		});

		socket.on("init chat", ({ senderId, receiverId }) => {
			console.log(`Starting chat between ${senderId} and ${receiverId}`);

			const userPromises = [User.findById(senderId), User.findById(receiverId)];

			Promise.all(userPromises)
				.then(([user, other]) => {
					socket.sender = user;
					socket.receiver = other;
					socket.roomKey = user._id < other._id ? `${user._id}-${other._id}` : `${other._id}-${user._id}`;
					socket.join(socket.roomKey);

					return ChatMessage.find({
						$or: [
							{
								sender: user._id,
								receiver: other._id
							},
							{
								sender: other._id,
								receiver: user._id
							}
						]
					})
						.populate("sender receiver")
						.then(messages => socket.emit("message list", messages));
				})
				.catch(err => console.error(`Oh shit!\n${err}`));
		});

		socket.on("message", message => {
			console.log("message received: " + message);

			ChatMessage.create({
				text: message,
				sender: socket.sender._id,
				receiver: socket.receiver._id
			})
				.then(() => {
					io.to(socket.roomKey).emit("message", {
						text: message,
						sender: socket.sender,
						receiver: socket.receiver
					});
				});
		});
	});
};