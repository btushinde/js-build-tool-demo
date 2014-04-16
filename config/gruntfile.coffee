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
    # Watch and compile app whenever changes are made.
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


    # PRECOMPILE ASSETS
    # Compile Jade to HTML
    jade:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.jade'
          dest: 'build/grunt'
          ext:  '.html'
        }]
      public:
        files: [{
          expand: true
          cwd:  'public'
          src:  '**/*.jade'
          dest: 'build/grunt'
          ext:  '.html'
        }]
      options:
        pretty:   true
        client:   false

    # Compile Stylus to CSS
    stylus:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.styl'
          dest: 'build/grunt'
          ext:  '.css'
        }]
        options:
          linenos:  true
          compress: false

    # Compile CoffeeScript
    coffee:
      compile:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.coffee'
          dest: 'build/grunt'
          ext:  '.js'
        }]

    # CoffeeLint for helpful feedback
    coffeelint:
      all:
        files: [{
          expand: true
          cwd:  'assets'
          src:  '**/*.coffee'
          dest: 'build/grunt'
          ext:  '.js'
        }]
        options:
          max_line_length:
            value: 150
            level: 'warn'


    copy:
      json:
        files: [{
          expand: true
          cwd:  'public'
          src:  '**/*.json'
          dest: 'build/grunt'
          ext:  '.json'
        }]
      vendor:
        files: [{
          expand: true
          cwd:  'bower_components'
          src: '**/*'
          dest: 'build/grunt/vendor'
          filter: 'isFile'
        }]

    # Starts a static Connect server
    connect:
      server:
        options:
          port: 9001
          base: 'build/grunt'
          keepalive: true
          livereload: true

    # Remove precompile files
    clean:
      options:
        force: true
      js:       ['build/grunt/js']
      css:      ['build/grunt/css']
      views:    ['build/grunt/templates']
      build:    ['build/grunt']

  # TASKS
  # Register tasks
  grunt.registerTask 'lint',    ['coffeelint']
  grunt.registerTask 'build',   ['clean:build', 'coffee', 'stylus', 'jade', 'copy']
  grunt.registerTask 'default', ['lint', 'build', 'watch']