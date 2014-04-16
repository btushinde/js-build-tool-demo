###
Gruntfile.coffee
###


fs = require('fs')
exec = require('child_process').exec
_ = require('lodash')

# "load-grunt-tasks": "*",
# "grunt-contrib-watch": "*",
# "grunt-contrib-clean": "*",
# "grunt-contrib-copy": "*",
# "grunt-contrib-concat": "*",
# "grunt-shell": "*",
# "grunt-contrib-coffee": "*",
# "grunt-coffeelint": "*",
# "grunt-contrib-jade": "*",
# "grunt-contrib-stylus": "*",
# "grunt-uncss": "*",
# "grunt-csso": "*",
# "grunt-autoprefixer": "*",
# "grunt-closure-compiler": "*",
# "grunt-contrib-htmlmin": "*",

module.exports = (grunt) ->

  # Grab all grunt-* packages from package.json and load their tasks
  require("load-grunt-tasks")(grunt)

  # Get the src-dest mapping for the last watch event
  getAssetFile = ->
    src:  '<%= assets.src %>'
    dest: '<%= assets.dest %>'

  # Build a files array that mapps to asset config values
  getAssetFiles = (target) ->
    files: [{
      expand: true
      cwd: '<%= assets.' + target + '.src.path %>'
      src:  '**/*.<%= assets.' + target + '.src.ext %>'
      dest: '<%= assets.' + target + '.dest.path %>'
      ext:  '.<%= assets.' + target + '.dest.ext %>'
    }]


  grunt.initConfig
    # Load packages for easy reference
    pkg: grunt.file.readJSON 'package.json'
    banner: '// Built <%= grunt.template.today("mm-dd-yyyy,  h:MM:ss TT") %>\n\n'

    # Define some constants for our asset paths to avoid repetition
    assets:
      coffee:
        src:    { path: 'assets/js',               ext: 'coffee'}
        dest:   { path: 'WebContent/js',           ext: 'js'    }
      js:
        src:    { path: 'assets/js',               ext: 'js'}
        dest:   { path: 'WebContent/js',           ext: 'js'    }
      stylus:
        src:    { path: 'assets/css',              ext: 'styl'  }
        dest:   { path: 'WebContent/css',          ext: 'css'   }
      jade:
        src:    { path: 'assets/templates',         ext:  'jade' }
        dest:   { path: 'WebContent/templates',    ext:  'html' }
      html:
        src:    { path: 'assets/templates',         ext:  'html' }
        dest:   { path: 'WebContent/templates',    ext:  'html' }

    # Watch and compile app whenever changes are made.
    watch:
      options:
        nospawn: true
      jade:
        files:    'assets/templates/**/*.jade'
        tasks:    ['jade:single', 'syncFile']
        options:  livereload: true
      coffee:
        files:    'assets/js/**/*.coffee'
        tasks:    ['coffeelint:single', 'coffee:single', 'syncFile']
        options:  livereload: true
      stylus:
        files:    'assets/css/**/*.styl'
        tasks:    ['stylus:all', 'syncFile']
        options:  livereload: true


    # PRECOMPILE ASSETS
    # Compile Jade to HTML
    jade:
      single:     getAssetFile()
      all:        getAssetFiles 'jade'
      options:
        pretty:   true
        client:   false

    # Compile Stylus to CSS
    stylus:
      single:     getAssetFile()
      all:        getAssetFiles 'stylus'
      options:
        linenos:  true
        compress: false

    # Compile CoffeeScript
    coffee:
      single:     getAssetFile()
      all:        getAssetFiles 'coffee'

    # CoffeeLint for helpful feedback
    coffeelint:
      single:     getAssetFile()
      app:        ['assets/**/*.coffee']
      gruntfile:  'Gruntfile.coffee'
      options:
        max_line_length:
          value: 150
          level: 'warn'




    # UTILITIES
    # Run shell commands directly
    shell:
      ant_clean:         command: 'ant clean'
      ant_build:         command: 'ant'
      stackato_push:     command: 'stackato push -n --path build/stackato'
      stackato_update:   command: 'stackato update --path build/stackato/ -n'
      options:
        stdout: true

    # Starts a static Connect server
    connect:
      server:
        options:
          port: 9001
          base: 'build'
          keepalive: true

    # Remove precompile files
    clean:
      options:
        force: true
      js:       ['WebContent/js']
      css:      ['WebContent/css']
      views:    ['WebContent/templates']
      images:   ['WebContent/img']
      build:    ['build', 'WebContent']
      all:      ['build', 'WebContent', 'node_modules']



  # TASKS
  # Register tasks
  grunt.registerTask  'clean-assets',   ['clean:js', 'clean:css', 'clean:views']
  grunt.registerTask  'build-assets',   ['jade:all', 'stylus:all', 'coffee:all', 'copy:json', 'copy:jsall', 'copy:html', 'copy:python']
  grunt.registerTask  'build',          ['coffeelint:app', 'clean-assets', 'build-assets']
  grunt.registerTask  'default',        ['build', 'watch']


  # EVENTS
  # This function handles the events fired by the watch task.
  # Watch typically compiles all of a given asset type whenever
  # one of those assets changes, which can lead to slower livereloading.
  # Here, we determine the source and destination per our asset config
  # at the top. Grunt will compile only the asset that changed and immediately
  # refresh, speeding things up considerably.
  #
  grunt.event.on 'watch', (action, srcPath, target) ->
    switch target
      when 'coffee', 'jade', 'stylus', 'js'
        a = grunt.config 'assets.' + target

        src = srcPath
        dest = srcPath
          .replace(a.src.path, a.dest.path)
          .replace(a.src.ext, a.dest.ext)

        grunt.config 'assets.src', src
        grunt.config 'assets.dest', dest
