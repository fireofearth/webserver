const express  = require("express");
const router   = express.Router();

const utils       = require("../utils");
const controller = require("../controllers/controller");

router.get("",  controller.index);
router.get("/", controller.index);
router.post("/add", controller.addJobs);

module.exports = router;