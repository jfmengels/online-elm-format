const util = require("util");
const childProcess = require("child_process");
const express = require("express");
const bodyParser = require("body-parser");

// ELM FORMATTING

const binary = "./node_modules/.bin/elm-format";
const elmVersion = "0.19";
const spawnAsync = util.promisify(childProcess.spawn);

const elmFormat = async input => {
  try {
    const { status, stdout, stderr } = childProcess.spawnSync(
      binary,
      ["--elm-version", elmVersion, "--stdin"],
      { input }
    );

    switch (status) {
      case 0: {
        return stdout.toString();
      }
      case 1: {
        // Remove term colors
        const errorText = stderr
          .toString()
          .replace(/\[\d{1,2}m/g, "")
          .replace(
            /[\s\S]*I ran into something unexpected when parsing your code!/i,
            ""
          );
        return "Elm Format Failed\n\n" + errorText;
      }
      default:
        return "An unknown error occurred... :/";
    }
  } catch (exception) {
    return `elm-format exception: ${exception}`;
  }
};

// SERVER

const app = express();
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(express.static("dist"));
app.post("/", async (req, res, next) => {
  return res.send({
    code: await elmFormat(req.body.code)
  });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Started on port ${port}`);
});
