const fs = require("fs");
const path = require("path");
const env = require("../env");
const utils = require("../utils");
const LOCK_FILE = path.resolve(__dirname, "..", env.LOCK_FILE);
const JSON_FILE = path.resolve(__dirname, "..", env.JSON_FILE);

const createLock = () => {
    return new Promise((resolve, reject) => {
        if (fs.existsSync(LOCK_FILE)) {
            utils.logger("JOB","waiting to acquire lock");
            setTimeout(createLock, env.SPIN)
        } else {
            fs.closeSync(fs.openSync(LOCK_FILE, 'w'));
            utils.logger("JOB","aquired lock");
            resolve();
        }
    });
};

const getBlob = () => {
    return new Promise((resolve, reject) => {
        if(!fs.existsSync(JSON_FILE)) {
            const stub = JSON.stringify({ entries: [ ] });
            fs.writeFile(JSON_FILE, stub, (error) => {
                if (error) return reject(error);
                resolve(getBlob());
            });
        }
        fs.readFile(JSON_FILE, function (error, data) {
            if (error) return reject(error);
            resolve(data);
        });
    });
};

const writeBlob = (blob) => {
    return new Promise((resolve, reject) => {
        fs.writeFile(JSON_FILE, blob, (error) => {
            if (error) return reject(error);
            resolve();
        });
    });
};

exports.writeJob = async (entries) => {

    console.log(JSON.stringify(entries));
    utils.logger("JOB","writing jobs");
    await createLock().then(() => {
        return getBlob();
    }).then((blob) => {
        const jobList = JSON.parse(blob);
        utils.logger("JOB",blob);
        jobList.entries.push(...entries);
        const newBlob = JSON.stringify(jobList);
        return writeBlob(newBlob);
    }).then(() => {
        utils.logger("JOB","removing lock");
        fs.unlinkSync(LOCK_FILE);
    }).catch((error) => {
        utils.error(error);
    });
};