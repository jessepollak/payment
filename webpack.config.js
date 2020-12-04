var webpack = require("webpack");

module.exports = {
  resolve: {
    extensions: [".js", ".coffee"],
  },
  entry: "./src/index.coffee",
  mode: "none",
  output: {
    path: __dirname + "/dist/",
    filename: "payment.js",
    library: "payment",
    libraryTarget: "var",
  },
  module: {
    rules: [
      { test: /\.json/, loader: "json-loader" },
      { test: /\.coffee$/, loader: "coffee-loader" },
    ],
  },
};
