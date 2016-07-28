const User = require("./models/User")
const ChatMessage = require("./models/ChatMessage")

module.exports = function (server) {
	var io = require("socket.io").listen(server)

	io.on("connection", function (socket) {
		console.log("user connected")

		socket.on("disconnect", function () {
			console.log("user disconnected")
		})

		socket.on("init chat", function ({senderId, receiverId}) {
			console.log("Starting chat between " + senderId + " and " + receiverId)

			const userPromises = [User.findOne({
				fbId: senderId
			}), User.findOne({
				fbId: receiverId
			})]

			Promise.all(userPromises).then(([user, other]) => {
				socket.sender = user
				socket.receiver = other
				socket.roomKey = user._id < other._id ? `${user._id}-${other._id}` : `${other._id}-${user._id}`
				socket.join(socket.roomKey)

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
				}).populate("sender receiver").then(messages => {
					socket.emit("message list", messages)
				})
			}).catch(err => console.error(`Oh shit!\n${err}`))
		})

		socket.on("message", function (message) {
			console.log("message received: " + message)
			socket.broadcast.to(socket.roomKey).emit("message", {
				text: message,
				sender: socket.sender,
				receiver: socket.receiver
			})

			ChatMessage.create({
				text: message,
				sender: socket.sender._id,
				receiver: socket.receiver._id
			})
		})
	})
}