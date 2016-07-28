"use strict";

var mongoose = require("mongoose");

var messageSchema = mongoose.Schema({
	text: String,
	created: Date,
	sender: {type: mongoose.Schema.Types.ObjectId, ref: "User"},
	receiver: {type: mongoose.Schema.Types.ObjectId, ref: "User"}
});

module.exports = mongoose.model("ChatMessage", messageSchema);