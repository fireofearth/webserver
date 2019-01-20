const utils = require("./utils");

utils.start("Starting app.js");

const path = require("path");
const bodyParser = require('body-parser');


utils.start("importing npm modules");
const express = require("express");

const app = express();

utils.start("setup view engine");
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

utils.start("importing routes");
const routes = require("./routes/routes");
app.use("/", routes);

app.use(express.static(path.join(__dirname, "public")));

module.exports.http = app;

