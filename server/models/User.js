"use strict";

var mongoose = require("mongoose");

var userSchema = mongoose.Schema({
	_id: String,
	displayName: String,
	getCount: {
		type: Number,
		default: 0
	},
	giveCount: {
		type: Number,
		default: 0
	}
});

module.exports = mongoose.model("User", userSchema);