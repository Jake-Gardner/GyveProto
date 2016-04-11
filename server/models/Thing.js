"use strict";

var mongoose = require("mongoose");

var thingSchema = mongoose.Schema({
	title: String,
	image: {type: mongoose.Schema.Types.ObjectId, ref: "Image"},
	givenBy: {type: mongoose.Schema.Types.ObjectId, ref: "User"},
	gottenBy: [{type: mongoose.Schema.Types.ObjectId, ref: "User"}],
	passedBy: [{type: mongoose.Schema.Types.ObjectId, ref: "User"}],
	junkedBy: [{type: mongoose.Schema.Types.ObjectId, ref: "User"}]
});

module.exports = mongoose.model("Thing", thingSchema);