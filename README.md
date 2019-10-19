## About

It was a programming assignment I did over the weekend for a job involving Bash, CRON scheduling, async processes, and server programming. You can upload jobs (they just sleep for a set amount of time) in a web form, the jobs will be saved in a JSON file, and scheduled using a CRON script and then the jobs email you back when they are done.

## Installation

Make sure you update the path of this server hard coded in the `job.sh` and `scheduler.sh` files.

You need a CRON daemon, Node.js, [jq](https://www.archlinux.org/packages/community/x86_64/jq/) and NPM installed. I'm assuming you have `systemd` and `cronie` installed. You should also set up a Nodemailer account and set your user details so that jobs can send you email.

Create a `env.js` file with the contents:

```
exports.JSON_FILE = "job_list.json";
exports.LOCK_FILE = "lock";
exports.SPIN = 100;
exports.mail = { };
exports.mail.HOST = "smtp.mailtrap.io";
exports.mail.PORT = <PORT>;
exports.mail.USER = "<USER>";
exports.mail.PASS = "<PASS>";
```

Then all you need to 

```
npm install
systemctl start cronie
crontab webserver-crontask
node start
```

Access `localhost:8000` on your browser to submit jobs using the form. To see jobs that are running do `ps aux | grep job.sh`. Jobs that are finished will email you a notification via Nodemailer.
