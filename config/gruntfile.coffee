###
Gruntfile.coffee
###

fs = require('fs')
exec = require('child_process').exec
_ = require('lodash')

module.exports = (grunt) ->
  # Grab all grunt-* packages from package.json and load their tasks
  require("load-grunt-tasks")(grunt)

  grunt.initConfig

    #---------------------------------------------
    # Watch + Reload
    #---------------------------------------------
    watch:
      options:
        nospawn: true
        livereload: true
      jade:
        files:    ['assets/**/*.jade', 'public/**/*.jade']
        tasks:    ['jade']
      coffee:
        files:    'assets/js/**/*.coffee'
        tasks:    ['coffeelint', 'coffee']
      stylus:
        files:    'assets/css/**/*.styl'
        tasks:    ['stylus']
      json:
        files:    'public/**/*.json'
        tasks:    ['copy:json']


    #---------------------------------------------
    # Build Assets
    #---------------------------------------------

    # Jade
    jade:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.jade'
          dest: 'build/gruntBuild'
          ext:  '.html'
        }]
      public:
        files: [{
          expand: true
          cwd:  'public'
          src:  '**/*.jade'
          dest: 'build/gruntBuild'
          ext:  '.html'
        }]
      options:
        pretty:   true
        client:   false

    # Stylus
    stylus:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.styl'
          dest: 'build/gruntBuild'
          ext:  '.css'
        }]
        options:
          linenos:  true
          compress: false

    # Coffeescript
    coffee:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.coffee'
          dest: 'build/gruntBuild'
          ext:  '.js'
        }]


    #---------------------------------------------
    # Lint
    #---------------------------------------------
    coffeelint:
      all:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.coffee'
          dest: 'build/gruntBuild'
          ext:  '.js'
        }]
        options:
          max_line_length:
            value: 150
            level: 'warn'

    #---------------------------------------------
    # Copy Files
    #---------------------------------------------
    copy:
      json:
        files: [{
          expand: true
          cwd:  'public'
          src:  '**/*.json'
          dest: 'build/gruntBuild'
          ext:  '.json'
        }]
      vendor:
        files: [{
          expand: true
          cwd:  'bower_components'
          src: '**/*'
          dest: 'build/gruntBuild/vendor'
          filter: 'isFile'
        }]


    #---------------------------------------------
    # Delete Files
    #---------------------------------------------
    clean:
      options:
        force: true
      js:       ['build/gruntBuild/js']
      css:      ['build/gruntBuild/css']
      views:    ['build/gruntBuild/templates']
      build:    ['build/gruntBuild']


    #---------------------------------------------
    # Development Server
    #---------------------------------------------
    connect:
      server:
        options:
          port: 9001
          base: 'build/gruntBuild'
          keepalive: true
          livereload: true



  # TASKS
  # Register tasks
  grunt.registerTask 'lint',    ['coffeelint']
  grunt.registerTask 'build',   ['clean:build', 'coffee', 'stylus', 'jade', 'copy']
  grunt.registerTask 'default', ['lint', 'build', 'watch']