"use strict";

var mongoose = require("mongoose");

var imageSchema = mongoose.Schema({
	data: Buffer
});

module.exports = mongoose.model("Image", imageSchema);