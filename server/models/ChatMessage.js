const mongoose = require("mongoose");

const messageSchema = mongoose.Schema({
	text: String,
	created: Date,
	sender: { type: String, ref: "User" },
	receiver: { type: String, ref: "User" }
});

module.exports = mongoose.model("ChatMessage", messageSchema);