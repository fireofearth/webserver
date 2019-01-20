
const utils = require("../utils");
const writer = require("../handers/writer");
const test = require("../test");

const tag = {
    clientEmail:    "client_email",
    clientUsername: "client_username",
    clientDetail:   "client_detail",
    numberOfJobs:   "number_jobs",
    jobName:        "job_name",
    jobWeight:      "job_weight",
    jobs:           "jobs"


};

exports.index = function (req, res) {

    res.render("index", {title: "my website"});
};

exports.addJobs = async (req, res) => {

    const entry = JSON.parse(JSON.stringify(req.body));
    const clientEmail    = entry[tag.clientEmail];
    const clientUsername = entry[tag.clientUsername];
    const numberOfJobs   = entry[tag.numberOfJobs];
    const entries     = [ ];
    for (let i = 1; i <= numberOfJobs; i++) {
        entries.push({
            [tag.clientEmail]: entry[tag.clientEmail],
            [tag.clientUsername]: entry[tag.clientUsername],
            [tag.jobName]: entry[`job_${i}_name`],
            [tag.jobWeight]: entry[`job_${i}_weight`]
        });
    }
    await writer.writeJob(entries);

    res.redirect("/")
};