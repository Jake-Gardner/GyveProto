"use strict";

var mongoose = require("mongoose");

var imageSchema = mongoose.Schema({
	name: String,
	data: Buffer
});

module.exports = mongoose.model("Image", imageSchema);