var webpackConfig = require("./webpack.config.js");
webpackConfig.devtool = "inline-source-map";
delete webpackConfig.externals;
delete webpackConfig.entry;
delete webpackConfig.output;

module.exports = function (config) {
  config.set({
    basePath: ".",
    frameworks: ["es6-shim", "chai", "mocha", "sinon"],
    files: ["tests.bundle.js"],
    preprocessors: {
      "tests.bundle.js": ["webpack", "sourcemap"],
    },
    reporters: ["dots", "coverage"],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ["Chrome"],
    singleRun: false,
    concurrency: Infinity,
    webpack: webpackConfig,
    webpackMiddleware: {
      noInfo: false,
    },
    coverageReporter: {
      type: "lcov",
      dir: "coverage/",
    },
  });
};
