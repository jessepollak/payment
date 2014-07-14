gulp = require 'gulp'
browserify = require 'gulp-browserify'
scss = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
spawn = require('child_process').spawn
server = require('tiny-lr')()
livereload = require('gulp-livereload')
rename = require 'gulp-rename'
rimraf = require 'gulp-rimraf'
connect = require 'gulp-connect'
open = require 'gulp-open'
mocha = require 'gulp-mocha'
runs = require 'run-sequence'

development = process.env.NODE_ENV == 'development'

gulp.task 'browserify', ->
  gulp.src './src/payment.coffee', read: false
    .pipe browserify
      insertGlobals: false
      debug: development
      transform: ['coffeeify']
      extensions: ['.coffee']
    .pipe livereload(server)
    .pipe rename({ extname: '.js' })
    .pipe gulp.dest('./lib/')

gulp.task 'watch', ['browserify', 'connect'],  ->
  server.listen 35729, ->
    gulp.watch './src/**/*.coffee', ['browserify']

  gulp.src('example/index.html')
    .pipe open("", url: "http://localhost:8080/example")

gulp.task 'connect', ->
  connect.server()

gulp.task 'clean', ->
  gulp.src 'lib'
    .pipe rimraf()

gulp.task 'test', ->
  gulp.src('./test')
    .pipe(mocha({ report: 'nyan', compilers: 'coffee:coffee-script/register' }))

gulp.task 'build', (cb) ->
  runs(
    'test',
    'clean',
    'browserify',
    cb
  )

gulp.task 'default', ['watch']
