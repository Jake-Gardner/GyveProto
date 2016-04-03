"use strict";

var mongoose = require("mongoose");

var thingSchema = mongoose.Schema({
	title: String,
	image: {type: mongoose.Schema.Types.ObjectId, ref: "Image"},
	creator: {type: mongoose.Schema.Types.ObjectId, ref: "User"},
	getters: [{type: mongoose.Schema.Types.ObjectId, ref: "User"}]
});

module.exports = mongoose.model("Thing", thingSchema);