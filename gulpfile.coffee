coffee = require "gulp-coffee"
less = require "gulp-less"
gulp = require "gulp"

assets = "./assets/themes/pure"

gulp.task "less", ->
  gulp.src "#{assets}/less/*.less"
  .pipe less()
  .pipe gulp.dest "#{assets}/css"

gulp.task "watch", ["less"], ->
  gulp.watch "#{assets}/less/*.less", ["less"]

gulp.task "default", ["less", "watch"]