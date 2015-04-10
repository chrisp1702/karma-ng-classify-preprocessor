gulp = require 'gulp'
spawn = require('child_process').spawn

bump = require 'gulp-bump'
coffee = require 'gulp-coffee'
git = require 'gulp-git'

gulp.task 'build', ->
  gulp.src 'src/index.coffee'
    .pipe coffee bare:true
    .pipe gulp.dest './dist'

gulp.task 'publish:bump', ->
  gulp.src './package.json'
    .pipe bump()
    .pipe gulp.dest './'
    .pipe git.add()
    .pipe git.commit "bumped version",

gulp.task 'publish', (done) ->
  spawn 'npm', ['publish'], {stdio: 'inherit'}
    .on 'close', done

gulp.task 'default', [ 'build' ]
