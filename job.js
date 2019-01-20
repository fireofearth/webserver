const nodemailer = require('nodemailer');
const env = require("./env");
const utils =require("./utils");

const transport = nodemailer.createTransport({
    host: env.mail.HOST,
    port: env.mail.PORT,
    auth: {
        user: env.mail.USER,
        pass: env.mail.PASS
    }
});

const clientEmail    = process.argv[2];
const clientUsername = process.argv[3];
const jobName        = process.argv[4];
const jobWeight     = process.argv[5]*1000;

const mailOptions = {
    from: 'admin@acme.com',
    to: clientEmail,
    subject: `Job ${jobName} has finished`,
    html: `<p>Dear ${clientUsername}, your job ${jobName} is done.</p>`
};

const finish = () => {
    transport.sendMail(mailOptions, (err, info) => {
        if(err) utils.error(err);
        else    utils.start(JSON.stringify(info));
    });
};

setTimeout(finish, jobWeight);


