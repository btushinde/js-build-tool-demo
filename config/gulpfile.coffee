###
Gulpfile.coffee
###

# "gulp": "*",
# "gulp-load-plugins": "*",
# "gulp-watch": "*",
# "gulp-clean": "*",
# "gulp-rename": "*",
# "gulp-concat": "*",
# "gulp-exec": "*",
# "gulp-newer": "*",
# "gulp-changed": "*",
# "gulp-cached": "*",
# "gulp-coffee": "*",
# "gulp-coffeelint": "*",
# "gulp-closure-compiler": "*",
# "gulp-jade": "*",
# "gulp-stylus": "*",
# "gulp-htmlmin": "*",
# "gulp-uncss": "*",
# "gulp-csso": "*",
# "gulp-autoprefixer": "*",



#=============================================
# General Modules
#=============================================
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
jsStylish =       require 'jshint-stylish'



#=============================================
# Gulp Tasks
#=============================================

# Gulp
gulp =          require 'gulp'
$ =             require('gulp-load-plugins')(camelize: true)
$.util =        require 'gulp-util'


#=============================================
# Configuration
#=============================================
cfg =             require './build.config'
isPrduction =     $.util.env.production
paths = cfg.paths


gulp.task 'default', ->
  console.log 'default task!'


#=============================================
# File Source Factories
#=============================================
assetFiles = (pattern) ->
  gulp.src([cfg.assetDir + '/**'])
    .pipe($.filter pattern)

buildFiles = (pattern) ->
  gulp.src([cfg.buildDir + '/**'])
    .pipe($.filter pattern)


gulp.task 'test', ->
  console.log compile
  files.assets.js()
    .pipe compile.javascript
    .pipe dest()


files =
  build:
    all: -> buildFiles '**/*'
  assets:
    all: ->
      assetFiles '**/*'
    coffee: ->
      assetFiles '**/*.coffee'
        .pipe $.coffeelint cfg.taskOptions.coffee
        .pipe $.coffeelint.reporter coffeeStylish()
    jade: ->
      assetFiles '**/*.jade'
    stylus: ->
      assetFiles '*/app.styl'

dest = -> gulp.dest cfg.buildDir



#=============================================
# Main Tasks
#=============================================

watchTasks = lazypipe()
  .pipe $.plumber
  .pipe $.watch

gulp.task 'default', ->
  runSequence(
    'clean:build'
    [
      'build:coffee'
      'build:stylus'
      'build:jade'
    ]
  )

gulp.task 'build', ['default']
gulp.task 'watch', ['default']

# gulp.task 'watch', ->
#   $.watch(
#     glob: 'assets/js/**/*.coffee'
#     emitOnGlob: false
#     name: "Templates"
#     runSequence 'build:coffee'
#   )

#     $.watch(
#     glob: 'assets/js/**/*.coffee'
#     emitOnGlob: false
#     name: "Templates"
#     runSequence 'build:coffee'
#   )



#---------------------------------------------
# Build Assets
#---------------------------------------------

# CoffeeScript
gulp.task 'build:coffee', ->
  files.assets.coffee()
    .pipe watchTasks()
    .pipe $.coffee().on('error', $.util.log)
    .pipe dest()

# Stylus
gulp.task 'build:stylus', ->
  files.assets.stylus()
    .pipe watchTasks()
    .pipe $.stylus()
    .pipe dest()

# Jade
gulp.task 'build:jade', ->
  files.assets.jade()
    .pipe watchTasks()
    .pipe $.jade()
    .pipe dest()



#---------------------------------------------
# Delete Files
#---------------------------------------------
gulp.task 'clean', ['clean:build']

gulp.task 'clean:build', ->
   gulp.src cfg.buildDir
    .pipe $.clean(cfg.taskOptions.clean)

gulp.task 'clean:js', ->
  gulp.src cfg.buildDir + '/' + cfg.jsDir
    .pipe $.clean(cfg.taskOptions.clean)

gulp.task 'clean:css', ->
  gulp.src cfg.buildDir + '/' + cfg.cssDir
    .pipe $.clean(cfg.taskOptions.clean)

gulp.task 'clean:templates', ->
  gulp.src cfg.buildDir + '/' + cfg.templateDir
    .pipe $.clean(cfg.taskOptions.clean)



