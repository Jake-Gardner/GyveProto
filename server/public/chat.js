var socket = io();

$(document).ready(function () {
	var user = $("#user").text();
	var other = $("#otherUser").text().match(/with (.+)/)[1];
	if (user && other) {
		socket.emit("init chat", {
			senderId: user,
			receiverId: other
		});
	}

	var input = $("#messageInput");

	var submit = function () {
		if (input.val().length > 0) {
			var text = input.val();
			socket.emit("message", text);
			input.val("");
		}
	};

	$("#submit").click(submit);
	input.on("keydown", function (evt) {
		if (evt.keyCode === 13) {
			submit();
		}
	});

	var addMsg = function (msg) {
		var msgItem = $("<li></li>");
		msgItem.text(msg.sender.fbId + ": " + msg.text);
		$("#messages").append(msgItem);
	};

	socket.on("message", function (message) {
		addMsg(message);
	});

	socket.on("message list", list => {
		list.forEach(function (item) {
			addMsg(item);
		});
	});
});