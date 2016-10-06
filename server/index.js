const mongoose = require("mongoose");
const express = require("express");
const bodyParser = require("body-parser");
const morgan = require("morgan");
const config = require("./config");
const User = require("./models/User");

mongoose.set("debug", true);

// Overwrite built-in promise implementation
mongoose.Promise = global.Promise;
mongoose.connect(config.dbUri, {});

const app = express();
app.set("port", config.port);
const http = require("http").Server(app);

app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());
app.set("view engine", "jade");
app.set("views", __dirname + "/views");
app.use(express.static(__dirname + "/public"));
app.use(morgan("dev"));

const authRouter = express.Router();
authRouter.use((req, res, next) => {
	if (req.headers.authorization) {
		User.findById(req.headers.authorization)
			.then(user => {
				if (user) {
					req.user = user;
					next();
				} else {
					res.sendStatus(401);
				}
			});
	} else {
		res.sendStatus(401);
	}
});

const nonAuthRouter = express.Router();
nonAuthRouter.use((req, res, next) => {
	if (req.headers.authorization) {
		User.findById(req.headers.authorization)
			.then(user => {
				req.user = user;
				next();
			});
	} else {
		next();
	}
});

app.use("/", nonAuthRouter);
app.use("/", authRouter);

require("./routes/user.routes")(nonAuthRouter, authRouter);
require("./routes/thing.routes")(nonAuthRouter, authRouter);
require("./routes/admin.routes")(nonAuthRouter, authRouter);

http.listen(app.get("port"), () => {
	console.log(`\nApp listening at ${config.host}:${app.get("port")}\n\n`);
});

require("./routes/chat.routes")(http);
