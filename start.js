const utils = require("./utils");

const runServer = () => {
    const app = require("./app");
    app.http.set("port", 8000);
    require("http").createServer(app.http).listen(
        app.http.get("port"),
        () => { utils.start(`listening on HTTP port: ${app.http.get("port")}`); }
    );
};

runServer();
