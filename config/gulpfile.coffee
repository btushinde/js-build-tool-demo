###
Gulpfile.coffee
###


_ =               require 'lodash'
connect =         require 'connect'
es =              require 'event-stream'
fs =              require 'fs'
http =            require 'http'
lazypipe =        require 'lazypipe'
path =            require 'path'
join =            path.join
runSequence =     require 'run-sequence'
coffeeStylish =   require('coffeelint-stylish').reporter


gulp =          require 'gulp'
$ =             require('gulp-load-plugins')(camelize: true)
$.util =        require 'gulp-util'


#---------------------------------------------
# Build Assets + Watch/Reload
#---------------------------------------------
gulp.task 'build:coffee', ->
  gulp.src 'assets/**/*.coffee'
    .pipe $.changed('build/gulpBuild', {extension: '.coffee'})
    .pipe $.coffee().on('error', $.util.log)
    .pipe gulp.dest 'build/gulpBuild'

gulp.task 'build:stylus', ->
  gulp.src 'assets/**/*.styl'
    .pipe $.changed('build/gulpBuild', {extension: '.styl'})
    .pipe $.stylus()
    .pipe gulp.dest 'build/gulpBuild'

gulp.task 'build:jade', ->
  gulp.src ['assets/**/*.jade', 'public/**/*.jade']
    .pipe $.changed('build/gulpBuild', {extension: '.jade'})
    .pipe $.jade()
    .pipe gulp.dest 'build/gulpBuild'


#---------------------------------------------
# Copy Files
#---------------------------------------------
gulp.task 'copy:json', ->
  gulp.src ['assets/**/*', 'public/**/*']
    .pipe $.filter '**/*.json'
    .pipe gulp.dest 'build/gulpBuild'

gulp.task 'copy:vendor', ->
  gulp.src 'bower_components/**/*'
    .pipe gulp.dest 'build/gulpBuild/vendor'


#---------------------------------------------
# Delete Files
#---------------------------------------------
gulp.task 'clean:build', ->
   gulp.src 'build/gulpBuild'
    .pipe $.clean(read: false)

gulp.task 'clean:js', ->
  gulp.src 'build/gulpBuild/js'
    .pipe $.clean(read: false)

gulp.task 'clean:css', ->
  gulp.src 'build/gulpBuild/css'
    .pipe $.clean(read: false)

gulp.task 'clean:templates', ->
  gulp.src 'build/gulpBuild/templates'
    .pipe $.clean(read: false)


#---------------------------------------------
# Register Tasks
#---------------------------------------------
gulp.task 'clean', ['clean:build']
gulp.task 'copy', ['copy:json', 'copy:vendor']
gulp.task 'build', ['build:coffee', 'build:stylus', 'build:jade', 'copy']
gulp.task 'watch', ->
  gulp.watch 'assets/**/*.coffee', ['build:coffee']
  gulp.watch 'assets/**/*.styl', ['build:stylus']
  gulp.watch 'assets/**/*.jade', ['build:jade']

gulp.task 'default', ->
  runSequence 'clean', 'build', 'watch'