coffee = require "gulp-coffee"
less = require "gulp-less"
gulp = require "gulp"
concat = require "gulp-concat"
uglify = require "gulp-uglify"
plumber = require "gulp-plumber"
streamqueue = require "streamqueue"

assets = "./assets/themes/pure"

gulp.task "less", ->
  gulp.src "#{assets}/less/iframe.less"
  .pipe plumber()
  .pipe less compress:true
  .pipe gulp.dest "#{assets}/iframe"

  gulp.src "#{assets}/less/screen.less"
  .pipe plumber()
  .pipe less compress:true
  .pipe gulp.dest "#{assets}/css"

gulp.task "js", ->
  queue = streamqueue objectMode: true
  queue.queue gulp.src "#{assets}/js/lib/*.js"
  queue.queue(
    gulp.src "#{assets}/coffee/*.coffee"
    .pipe coffee bare:true
    .pipe plumber()
  )
  queue.done()
  .pipe plumber()
  .pipe concat("app.js", newLine:';')
  .pipe uglify preserveComments:"some"
  .pipe gulp.dest "#{assets}/js"

gulp.task "watch", ["less", "js"], ->
  gulp.watch "#{assets}/less/**/*.less", ["less"]
  gulp.watch ["#{assets}/coffee/*.coffee","#{assets}/js/**/*.js"], ["js"]

gulp.task "default", ["less", "js", "watch"]