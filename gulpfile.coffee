###
Gulpfile.coffee
###


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



gulp =        require('gulp')
# coffee =      require('gulp-coffee')
# concat =      require('gulp-concat')
# uglify =      require('gulp-uglify')
# imagemin =    require('gulp-imagemin')

paths =
  scripts: [
    'client/js/**/*.coffee'
    '!client/external/**/*.coffee'
  ]
  images: 'client/img/**/*'



# Minify and copy all JavaScript (except vendor scripts)
gulp.task 'scripts', ->
  gulp.src(paths.scripts)
    .pipe(coffee())
    .pipe(uglify())
    .pipe(concat('all.min.js'))
    .pipe gulp.dest('build/js')


# Copy all static images
gulp.task 'images', ->
  gulp.src(paths.images)
    .pipe(imagemin(optimizationLevel: 5))
    .pipe gulp.dest('build/img')


# Rerun the task when a file changes
gulp.task 'watch', ->
  gulp.watch paths.scripts, ['scripts']
  gulp.watch paths.images, ['images']
  return


# The default task (called when you run `gulp` from cli)
# gulp.task 'default', [
#   'scripts'
#   'images'
#   'watch'
# ]

gulp.task 'default', ->
  console.log 'default task!'







# #=============================================
# # Configuration
# #=============================================
# cfg =             require './build.config'
# compile =         require './compile'
# isPrduction =     $.util.env.production

# # requireDir =    require 'require-dir'
# # dir =           requireDir './tasks'

# appDescriptor =   JSON.parse fs.readFileSync('appDescriptor.json').toString()
# version =         fs.readFileSync('version.txt').toString().replace('\n', '')
# stackatoAppId = [
#   appDescriptor.appId
#   version.replace /\./g, '-'
#   moment().format 'YYYYMM'
#   process.env.USER
# ].join('-')




# #=============================================
# # File Source Factories
# #=============================================
# assetFiles = (pattern) ->
#   gulp.src([
#     cfg.assetDir + '/**'
#     '!assets/js/vendor/**/*'
#   ]).pipe $.filter pattern

# buildFiles = (pattern) ->
#   gulp.src [cfg.buildDir + '/**']
#     .pipe($.filter pattern)

# newAsset = (name, type, extension, pattern) ->
#   baseDir = cfg.assetDir
#   typeDir = switch
#     when type is 'style' then cfg.cssDir
#     when type is 'script' then cfg.jsDir
#     when type is 'template' then cfg.templateDir
#     when type is 'image' then cfg.imageDir

#   assetPath = join baseDir, typeDir

# gulp.task 'test', ->
#   console.log compile
#   files.assets.js()
#     .pipe compile.javascript
#     .pipe dest()


# files =
#   build:
#     all: -> buildFiles '**/*'
#   assets:
#     all: ->
#       assetFiles '**/*'
#     js: ->
#       assetFiles '**/*.js'
#         # .pipe $.jshint cfg.taskOptions.jshint
#         # .pipe $.jshint.reporter jsStylish
#     coffee: ->
#       assetFiles '**/*.coffee'
#         .pipe $.coffeelint cfg.taskOptions.coffee
#         .pipe $.coffeelint.reporter coffeeStylish()
#     css: ->
#       assetFiles '**/*.css'
#         .pipe $.csslint cfg.taskOptions.csslint
#         .pipe $.csslint.reporter()
#     html: ->
#       assetFiles '**/*.html'
#         .pipe $.htmlhint cfg.taskOptions.htmlhint
#         .pipe $.htmlhint.reporter()
#     jade: ->
#       assetFiles '**/*.jade'
#     stylus: ->
#       assetFiles '*/app.styl'
#     json: ->
#       assetFiles '**/*.json'
#         .pipe $.jsonlint()
#         .pipe $.jsonlint.reporter()
#     python: ->
#       assetFiles '**/*.py'

# dest = -> gulp.dest cfg.buildDir



# #=============================================
# # Main Tasks
# #=============================================

# watchTasks = lazypipe()
#   .pipe $.plumber
#   .pipe $.watch

# gulp.task 'default', ->
#   runSequence(
#     'clean:build'
#     [
#       'build:coffee'
#       'build:stylus'
#       'build:jade'
#       'copy:js'
#       'copy:html'
#       'copy:json'
#       'copy:python'
#     ]
#   )

# gulp.task 'build', ['default']
# gulp.task 'watch', ['default']

# # gulp.task 'watch', ->
# #   $.watch(
# #     glob: 'assets/js/**/*.coffee'
# #     emitOnGlob: false
# #     name: "Templates"
# #     runSequence 'build:coffee'
# #   )

# #     $.watch(
# #     glob: 'assets/js/**/*.coffee'
# #     emitOnGlob: false
# #     name: "Templates"
# #     runSequence 'build:coffee'
# #   )



# #---------------------------------------------
# # MISC.
# #---------------------------------------------

# gulp.task 'help', $.taskListing

# gulp.task 'info', ->
#   $.gitinfo()
#     .pipe es.map (data, cb) ->
#       $.util.log data

# gulp.task 'ant', ->
#   gulp.src('.').pipe($.exec 'ant')
#     .pipe(gulp.dest cfg.buildDir)

# gulp.task 'ant-clean', ->
#   gulp.src(files.all).pipe($.exec 'ant clean')

# gulp.task 'update', ->
#   gulp.src(files.all).pipe($.exec 'stackato update -n --path build/stackato')

# gulp.task 'push', ->
#   gulp.src(files.all).pipe($.exec 'stackato push -n --path build/stackato')



# #---------------------------------------------
# # Build Assets
# #---------------------------------------------

# # CoffeeScript
# gulp.task 'build:coffee', ->
#   files.assets.coffee()
#     .pipe watchTasks()
#     .pipe $.coffee().on('error', $.util.log)
#     .pipe dest()

# # Stylus
# gulp.task 'build:stylus', ->
#   files.assets.stylus()
#     .pipe watchTasks()
#     .pipe $.stylus()
#     .pipe dest()

# # Jade
# gulp.task 'build:jade', ->
#   files.assets.jade()
#     .pipe watchTasks()
#     .pipe $.jade()
#     .pipe dest()



# #---------------------------------------------
# # Copy Assets
# #---------------------------------------------

# gulp.task 'copy', [
#   'copy:js'
#   'copy:css'
#   'copy:html'
#   'copy:images'
#   'copy:json'
#   'copy:python'
# ]

# gulp.task 'copy:js', ->
#   files.assets.js()
#     .pipe watchTasks()
#     .pipe dest()

# gulp.task 'copy:css', ->
#   files.assets.css()
#     .pipe watchTasks()
#     .pipe dest()

# gulp.task 'copy:html', ->
#   files.assets.html()
#     .pipe watchTasks()
#     .pipe dest()

# gulp.task 'copy:images', ->
#   gulp.src cfg.buildDir + '/' + cfg.imageDir
#     .pipe watchTasks()
#     .pipe dest()

# gulp.task 'copy:json', ->
#   files.assets.json()
#     .pipe watchTasks()
#     .pipe dest()

# gulp.task 'copy:python', ->
#   files.assets.python()
#     .pipe watchTasks()
#     .pipe dest()


# #---------------------------------------------
# # Delete Files
# #---------------------------------------------

# # Clean files
# gulp.task 'clean', ['clean:scripts', 'clean:styles', 'clean:templates']

# gulp.task 'clean:build', ->
#    gulp.src cfg.buildDir
#     .pipe $.clean(cfg.taskOptions.clean)

# gulp.task 'clean:scripts', ->
#   gulp.src cfg.buildDir + '/' + cfg.jsDir
#     .pipe $.clean(cfg.taskOptions.clean)

# gulp.task 'clean:styles', ->
#   gulp.src cfg.buildDir + '/' + cfg.cssDir
#     .pipe $.clean(cfg.taskOptions.clean)

# gulp.task 'clean:templates', ->
#   gulp.src cfg.buildDir + '/' + cfg.templateDir
#     .pipe $.clean(cfg.taskOptions.clean)

# gulp.task 'clean:images', ->
#   gulp.src cfg.buildDir + '/' + cfg.imageDir
#     .pipe $.clean(cfg.taskOptions.clean)




# grunt.registerTask 'syncFile', 'sync changed files to Stackato via SCP', ()->
#   done = @async
#   source = grunt.config 'assets.dest'
#   destination = source.replace 'WebContent/', ''

#   log "Updating file: " + source + " ... "
#   grunt.warn 'Updating ' + source
#   exec "stackato scp " + stackatoAppId + " " + source + " :" + destination, (err, stdout, stderr) ->
#     if err
#       log source + ": Error."
#       grunt.warn 'SCP failed: ' + source
#       log stdout + stderr
#       done()
#     else
#       grunt.warn source + " uploaded successfully"
#       log source + " uploaded successfully"
#       done()







#---------------------------------------------
# JavaScript
#---------------------------------------------
# jsFiles = -> gulp.src cfg.appFiles.js
# tplFiles = -> gulp.src cfg.appFiles.tpl

# # jshint won't render parse errors without plumber
# jsBaseTasks = lazypipe()
#   .pipe(plumber)
#   .pipe ->
#     jshint _.clone cfg.taskOptions.jshint
#   .pipe jshint.reporter, "jshint-stylish"

# jsBuildTasks = jsBaseTasks.pipe(gulp.dest, join(cfg.buildDir, cfg.jsDir))

# tplBuildTasks = lazypipe()
#   .pipe ngHtml2js, moduleName: "templates"
#   .pipe gulp.dest, join(cfg.buildDir, cfg.jsDir, cfg.templatesDir)



# gulp.task "build-scripts-vendor", ->
#   if cfg.vendorFiles.js.length
#     gulp.src(cfg.vendorFiles.js, base: cfg.vendorDir)
#       .pipe gulp.dest join(cfg.buildDir, cfg.jsDir, cfg.vendorDir)

# gulp.task "build-scripts-app", ->
#   jsFiles().pipe jsBuildTasks()

# gulp.task "build-scripts-templates", ->
#   tplFiles().pipe tplBuildTasks()

# gulp.task "build-scripts", [
#   "build-scripts-vendor"
#   "build-scripts-app"
#   "build-scripts-templates"
# ]


# gulp.task "compile-scripts", ->
#   appFiles = jsFiles()
#     .pipe jsBaseTasks()
#     .pipe concat("appFiles.js")
#     .pipe ngmin()
#     .pipe header(readFile("module.prefix"))
#     .pipe footer(readFile("module.suffix"))

#   templates = tplFiles()
#     .pipe minifyHtml
#       empty: true
#       spare: true
#       quotes: true
#     .pipe ngHtml2js(moduleName: "templates")
#     .pipe concat("templates.min.js")


#   files = [appFiles, templates]

#   files.unshift gulp.src(cfg.vendorFiles.js)  if cfg.vendorFiles.js.length

#   es.concat.apply(es, files)
#     .pipe(concat(concatName + ".js"))
#     .pipe(uglify(cfg.taskOptions.uglify))
#     .pipe(rev())
#     .pipe(gulp.dest(join(cfg.compileDir, cfg.jsDir)))
#     .pipe(gzip())
#     .pipe gulp.dest(join(cfg.compileDir, cfg.jsDir))





