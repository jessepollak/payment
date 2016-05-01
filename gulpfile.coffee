gulp = require 'gulp'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'
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
  bundler = browserify
    entries: ['./src/payment.coffee']
    extensions: ['.coffee']
    debug: development
    standalone: 'payment.js'

  bundler
    .bundle().on 'error', console.log
    .pipe(source('payment.js'))
    .pipe(gulp.dest('lib/'))


gulp.task 'watch', ['browserify'],  ->
  gulp.watch './src/**/*.coffee', ['browserify']

gulp.task 'connect', ->
  connect.server()

gulp.task 'clean', ->
  gulp.src 'lib'
    .pipe rimraf()

gulp.task 'test', ->
  gulp.src('./test')
    .pipe(mocha({ reporter: 'nyan', compilers: 'coffee:coffee-script/register' }))
    .pipe(gulp.dest('.'))

gulp.task 'build', (cb) ->
  process.env.NODE_ENV = 'production'
  runs(
    'test',
    'clean',
    'browserify',
    cb
  )

gulp.task 'default', ['watch']
