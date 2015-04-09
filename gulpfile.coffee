gulp = require 'gulp'
spawn = require('child_process').spawn

coffee = require 'gulp-coffee'

gulp.task 'build', ->
  gulp.src 'src/index.coffee'
    .pipe coffee bare:true
    .pipe gulp.dest './dist'

gulp.task 'publish', (done) ->
  spawn 'npm', ['publish'], {stdio: 'inherit'}
    .on 'close', done

gulp.task 'default', [ 'build' ]
