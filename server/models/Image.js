const mongoose = require("mongoose");

const imageSchema = mongoose.Schema({
	data: Buffer
});

module.exports = mongoose.model("Image", imageSchema);