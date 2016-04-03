var socket = io();

$(document).ready(function () {
	var input = $("#messageInput");

	var submit = function () {
		if (input.val().length > 0) {
			socket.emit("message", input.val());
			input.val("");
		}
	};

	$("#submit").click(submit);
	input.on("keydown", function (evt) {
		if (evt.keyCode === 13) {
			submit();
		}
	});

	var user = $("#user").text();
	var other = $("#otherUser").text();
	if (user && other) {
		socket.emit("initChat", {
			user: user,
			other: other
		});
	}

	socket.on("message", function (message) {
		var msgItem = $("<li></li>");
		msgItem.text(message);
		$("#messages").append(msgItem);
	});
});