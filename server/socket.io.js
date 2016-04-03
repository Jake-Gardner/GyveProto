"use strict";

module.exports = function (http) {
	var io = require("socket.io").listen(http);

	io.on("connection", function (socket) {
		console.log("user connected");

		socket.on("disconnect", function () {
			console.log("user disconnected");
		});

		socket.on("initChat", function (data) {
			console.log("Starting chat between " + data.user + " and " + data.other);
		});

		socket.on("message", function (message) {
			console.log("message received: " + message);
			socket.broadcast.emit("message", message);
		});
	});
};