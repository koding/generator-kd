gulp       = require 'gulp'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
rename     = require 'gulp-rename'
uglify     = require 'gulp-uglify'
stylus     = require 'gulp-stylus'
clean      = require 'gulp-clean'
concat     = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
argv       = require('minimist') process.argv
browserify = require 'browserify'
coffeeify  = require 'coffeeify'
source     = require 'vinyl-source-stream'

STYLES_PATH = ['./app/styl/**/*.styl']
COFFEE_PATH = ['./app/coffee/**/*.coffee']
INDEX_PATH  = ['./app/index.html']
SERVER_PATH = './server/server.coffee'

BUILD_PATH  = argv.outputDir ? 'static'

SERVER_PORT = argv.port ? 9800

log = (color, message) -> gutil.log gutil.colors[color] message

watchLogger = (color, watcher) ->
  watcher.on 'change', (event) ->
    log color, "file #{event.path} was #{event.type}"

gulpBrowserify = (options, bundleOptions) ->
  options.extensions or= ['.coffee']
  bundleOptions or= {}
  b = browserify options
  b.transform coffeeify
  b.bundle bundleOptions

gulp.task 'serve', ['build'], ->
  server = require SERVER_PATH

gulp.task 'styles', ->

  gulp.src STYLES_PATH
    .pipe stylus()
    .pipe rename "main.css"
    .pipe gulp.dest "#{BUILD_PATH}/css"

gulp.task 'watch-styles', -> watchLogger 'cyan', gulp.watch STYLES_PATH, ['styles']

gulp.task 'coffee', ->

  gulpBrowserify
      entries : ['./app/coffee/main.coffee']
    .pipe source "main.js"
    .pipe gulp.dest "#{BUILD_PATH}/js"

  # gulp.src COFFEE_PATH
  #   .pipe sourcemaps.init()
  #   .pipe coffee bare: yes
  #   .pipe concat 'main.js'
  #   .pipe uglify()
  #   .pipe sourcemaps.write('./')
  #   .pipe gulp.dest "#{BUILD_PATH}/js"

gulp.task 'watch-coffee', -> watchLogger 'cyan', gulp.watch COFFEE_PATH, ['coffee']

gulp.task 'index', ->

  gulp.src INDEX_PATH
    .pipe gulp.dest "#{BUILD_PATH}"

gulp.task 'watch-index', -> watchLogger 'yellow', gulp.watch INDEX_PATH, ['index']

gulp.task 'clean', ->
  gulp.src [BUILD_PATH], read: no
    .pipe clean force: yes

gulp.task 'build', ['styles', 'coffee', 'index']

watchersArray = [
  'watch-styles'
  'watch-coffee'
  'watch-index'
]

gulp.task 'watchers', watchersArray

gulp.task 'watch', ['build'].concat watchersArray

gulp.task 'default', ['watch', 'serve']
