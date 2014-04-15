module.exports = (grunt) ->
  # grunt.loadNpmTasks "grunt-contrib-uglify"
  # grunt.loadNpmTasks "grunt-contrib-jshint"
  # grunt.loadNpmTasks "grunt-contrib-qunit"
  # grunt.loadNpmTasks "grunt-contrib-watch"
  # grunt.loadNpmTasks "grunt-contrib-concat"


  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    concat:
      options:
        separator: ";"

      dist:
        src: ["src/**/*.js"]
        dest: "dist/<%= pkg.name %>.js"

    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"dd-mm-yyyy\") %> */\n"

      dist:
        files:
          "dist/<%= pkg.name %>.min.js": ["<%= concat.dist.dest %>"]

    qunit:
      files: ["test/**/*.html"]

    jshint:
      files: [
        "Gruntfile.js"
        "src/**/*.js"
        "test/**/*.js"
      ]
      options:

        # options here to override JSHint defaults
        globals:
          jQuery: true
          console: true
          module: true
          document: true

    watch:
      files: ["<%= jshint.files %>"]
      tasks: [
        "jshint"
        "qunit"
      ]


  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
  # grunt.registerTask "default", [
  #   "jshint"
  #   "qunit"
  #   "concat"
  #   "uglify"
  # ]

  grunt.registerTask "default", ->
    console.log 'default task!'


# module.exports = (grunt) ->

#   # Grab all grunt-* packages from package.json and load their tasks
#   fs = require('fs')
#   exec = require('child_process').exec
#   moment = require('moment')
#   _ = require('underscore')
#   require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks
#   require('./tasks/notify')

#   appDescriptor = JSON.parse(fs.readFileSync("appDescriptor.json").toString())
#   version = fs.readFileSync("version.txt").toString().replace("\n", "")
#   stackatoAppId = [
#     appDescriptor.appId
#     version.replace /\./g, '-'
#     moment().format 'YYYYMM'
#     process.env.USER
#   ].join('-')

#   log = (msg) ->
#     process.stdout.write msg + '\n'


#   # Get the src-dest mapping for the last watch event
#   getAssetFile = ->
#     src:  '<%= assets.src %>'
#     dest: '<%= assets.dest %>'

#   # Build a files array that mapps to asset config values
#   getAssetFiles = (target) ->
#     files: [{
#       expand: true
#       cwd: '<%= assets.' + target + '.src.path %>'
#       src:  '**/*.<%= assets.' + target + '.src.ext %>'
#       dest: '<%= assets.' + target + '.dest.path %>'
#       ext:  '.<%= assets.' + target + '.dest.ext %>'
#     }]


#   grunt.initConfig
#     # Load packages for easy reference
#     pkg: grunt.file.readJSON 'package.json'
#     banner: '// Built <%= grunt.template.today("mm-dd-yyyy,  h:MM:ss TT") %>\n\n'

#     # Define some constants for our asset paths to avoid repetition
#     assets:
#       coffee:
#         src:    { path: 'assets/js',               ext: 'coffee'}
#         dest:   { path: 'WebContent/js',           ext: 'js'    }
#       js:
#         src:    { path: 'assets/js',               ext: 'js'}
#         dest:   { path: 'WebContent/js',           ext: 'js'    }
#       stylus:
#         src:    { path: 'assets/css',              ext: 'styl'  }
#         dest:   { path: 'WebContent/css',          ext: 'css'   }
#       jade:
#         src:    { path: 'assets/templates',         ext:  'jade' }
#         dest:   { path: 'WebContent/templates',    ext:  'html' }
#       html:
#         src:    { path: 'assets/templates',         ext:  'html' }
#         dest:   { path: 'WebContent/templates',    ext:  'html' }

#     # Watch and compile app whenever changes are made.
#     watch:
#       options:
#         nospawn: true
#       jade:
#         files:    'assets/templates/**/*.jade'
#         tasks:    ['jade:single', 'syncFile']
#         options:  livereload: true
#       html:
#         files:    'assets/templates/**/*.html'
#         tasks:    ['copy:html', 'syncFile']
#         options:  livereload: true
#       coffee:
#         files:    'assets/js/**/*.coffee'
#         tasks:    ['coffeelint:single', 'coffee:single', 'syncFile']
#         options:  livereload: true
#       stylus:
#         files:    'assets/css/**/*.styl'
#         tasks:    ['stylus:all', 'syncFile']
#         options:  livereload: true
#       js:
#         files:    'assets/js/**/*.js'
#         tasks:    ['copy:js', 'syncFile']
#         options:  livereload: true
#       json:
#         files:    'assets/**/*.json'
#         tasks:    ['copy:json']
#       python:
#         files:    'assets/**/*.py'
#         tasks:    ['copy:python']
#       gruntfile:
#         files:    'Gruntfile.coffee'
#         tasks:    ['coffeelint:gruntfile']

#     # PRECOMPILE ASSETS

#     # Compile Jade to HTML
#     jade:
#       single:     getAssetFile()
#       all:        getAssetFiles 'jade'
#       options:
#         pretty:   true
#         client:   false

#     # Compile Stylus to CSS
#     stylus:
#       single:     getAssetFile()
#       all:        getAssetFiles 'stylus'
#       options:
#         linenos:  true
#         compress: false

#     # Compile CoffeeScript
#     coffee:
#       single:     getAssetFile()
#       all:        getAssetFiles 'coffee'

#     # CoffeeLint for helpful feedback
#     coffeelint:
#       single:     getAssetFile()
#       app:        ['assets/**/*.coffee']
#       gruntfile:  'Gruntfile.coffee'
#       options:
#         max_line_length:
#           value: 150
#           level: 'warn'




#     # UTILITIES

#     # Run shell commands directly
#     shell:
#       ant_clean:         command: 'ant clean'
#       ant_build:         command: 'ant'
#       stackato_push:     command: 'stackato push -n --path build/stackato'
#       stackato_update:   command: 'stackato update --path build/stackato/ -n'
#       options:
#         stdout: true

#     # Starts a static Connect server
#     connect:
#       server:
#         options:
#           port: 9001
#           base: 'build'
#           keepalive: true

#     # Notification via Growl/OSX
#     notify_hooks:
#       options:
#         enabled: true
#         max_jshint_notifications: 5

#     # Remove precompile files
#     clean:
#       options:
#         force: true
#       js:       ['WebContent/js']
#       css:      ['WebContent/css']
#       views:    ['WebContent/templates']
#       images:   ['WebContent/img']
#       build:    ['build', 'WebContent']
#       all:      ['build', 'WebContent', 'node_modules']
#       docs:     ['docs']

#     # Compress files/folders to archives
#     compress:
#       main:
#         options:
#           mode: 'gzip'
#         expand: true,
#         cwd: 'assets/'
#         src: ['**/*']
#         dest: 'WebContent/'

#     # Copy files into public
#     copy:
#       js:getAssetFile()
#       jsall:
#         files: [{
#           expand: true
#           cwd: 'assets/js'
#           src: ['**/*.js']
#           dest: 'WebContent/js'
#         }]
#       json:
#         files: [{
#           expand: true
#           cwd: 'assets/js'
#           src: ['**/*.json']
#           dest: 'WebContent/js'
#         }]
#       html:
#         files: [{
#           expand: true
#           cwd: 'assets/templates'
#           src: ['**/*.html']
#           dest: 'WebContent/templates'
#         }]
#       python:
#         files: [{
#           expand: true
#           cwd: 'assets/js'
#           src: ['**/*.py']
#           dest: 'WebContent/js'
#         }]

#   # TASKS

#   # Register tasks
#   grunt.registerTask  'clean-assets',   ['clean:js', 'clean:css', 'clean:views']
#   grunt.registerTask  'build-assets',   ['jade:all', 'stylus:all', 'coffee:all', 'copy:json', 'copy:jsall', 'copy:html', 'copy:python']
#   grunt.registerTask  'build',          ['coffeelint:app', 'clean-assets', 'build-assets']
#   grunt.registerTask  'ant',            ['shell:ant_clean', 'shell:ant_build']
#   grunt.registerTask  'push',           ['shell:stackato_push']
#   grunt.registerTask  'update',         ['shell:stackato_update']
#   grunt.registerTask  'up',             ['build', 'ant', 'update']
#   grunt.registerTask  'default',        ['build', 'watch']

#   grunt.registerTask 'syncFile', 'sync changed files to Stackato via SCP', ()->
#     done = @async
#     source = grunt.config 'assets.dest'
#     destination = source.replace 'WebContent/', ''

#     log "Updating file: " + source + " ... "
#     grunt.warn 'Updating ' + source
#     exec "stackato scp " + stackatoAppId + " " + source + " :" + destination, (err, stdout, stderr) ->
#       if err
#         log source + ": Error."
#         grunt.warn 'SCP failed: ' + source
#         log stdout + stderr
#         done()
#       else
#         grunt.warn source + " uploaded successfully"
#         log source + " uploaded successfully"
#         done()

#   # EVENTS

#   # This function handles the events fired by the watch task.
#   # Watch typically compiles all of a given asset type whenever
#   # one of those assets changes, which can lead to slower livereloading.
#   # Here, we determine the source and destination per our asset config
#   # at the top. Grunt will compile only the asset that changed and immediately
#   # refresh, speeding things up considerably.

#   grunt.event.on 'watch', (action, srcPath, target) ->
#     switch target
#       when 'coffee', 'jade', 'stylus', 'js'
#         a = grunt.config 'assets.' + target

#         src = srcPath
#         dest = srcPath
#           .replace(a.src.path, a.dest.path)
#           .replace(a.src.ext, a.dest.ext)

#         grunt.config 'assets.src', src
#         grunt.config 'assets.dest', dest
