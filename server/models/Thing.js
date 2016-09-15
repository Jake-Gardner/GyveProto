"use strict";

var mongoose = require("mongoose");

var thingSchema = mongoose.Schema({
	title: String,
	image: {type: mongoose.Schema.Types.ObjectId, ref: "Image"},
	givenBy: {type: String, ref: "User"},
	gottenBy: [{type: String, ref: "User"}],
	passedBy: [{type: String, ref: "User"}],
	junkedBy: [{type: String, ref: "User"}],
	location: {type: [Number], index: "2d"}
});

module.exports = mongoose.model("Thing", thingSchema);