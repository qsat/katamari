'use strict'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  grunt.loadNpmTasks 'grunt-styleguide'
  grunt.loadNpmTasks 'grunt-este-watch'
 
  grunt.initConfig
 
    pkg:
      grunt.file.readJSON 'package.json'

    esteWatch:
      options:
        dirs: ["../src/**"]

      coffee: (filepath) -> 'coffee'
      scss:   (filepath) -> 'compass'
      sass:   (filepath) -> 'compass'
      css:    (filepath) -> 'styleguide'
      html:   (filepath) -> 'copy:src'

    connect:
      server:
        options:
          port: 8008
          hostname: '0.0.0.0'
          base: '../htdocs'

      styleguide:
        options:
          port: 8009
          hostname: '0.0.0.0'
          base: '../styleguide'

    styleguide:
      options:
        framework:
          name: 'styledocco'
      proj:
        options:
          name: 'Style Guide'
        files:
          '../styleguide': ['../src/**/*.scss', '../src/**/.*.sass']

    copy:
      bower:
        expand: true
        flatten: true
        cwd: '../bower/bower_components/' # srcの固定。destは固定されない
        src: ['*/*.js', '!*/*.min.js', '!*/*-min.js', '!*/index.js', '!*/*test*.js']
        dest: '../src/shared/js/libs'
        filter: 'isFile'
      src:
        expand: true
        flatten: false
        cwd: '../src'
        src: ['**/*', '!**/*.coffee', '!**/*.scss']
        dest: '../htdocs/'

    coffee:
      compile:
        expand: true
        flatten: false #src内のディレクトリをキープして出力
        cwd: '../src'
        src: '**/*.coffee'
        dest: '../htdocs/'
        ext: '.js'

    jshint:
      htdocs: [
        '../htdocs/**/*.js',
        '!../htdocs/**/*.min.js'
      ]

    uglify:
      options:
        mangle: true # true にすると難読化がかかる。false だと関数や変数の名前はそのまま
      shared:
        options: # sourcemap : https://github.com/gruntjs/grunt-contrib-uglify/issues/71
          banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - */' 
        files:
          '../htdocs/shared/js/script.min.js': [
            '../htdocs/shared/js/libs/jquery.js'
            '../htdocs/shared/js/observer.js'
          ]

    # https://github.com/gruntjs/grunt-contrib-compass
    compass:
      src:
        options:
          outputStyle: 'expanded'
          noLineComments: true
          debugInfo: false
          basePath: '../src'
          sassDir: './'
          cssDir: '../htdocs/'
          importPath: '../config/scss'

    cssmin:
      src:
        expand: true
        flatten: false
        cwd: '../htdocs/'
        src: ['**/*.css', '!**/*.min.css']
        dest: '../htdocs/'
        ext: '.css'

    # concat:
    #   dist:
    #     files:
    #       '../htdocs/shared/css/style.css': [
    #         '../htdocs/shared/css/all.css',
    #         '../htdocs/shared/css/module.css',
    #         '../htdocs/shared/css/theme-responsive.css',
    #         '../htdocs/shared/css/theme.css'
    #       ]

    # clean:
    #   dist: [
    #         '../htdocs/shared/css/all.css',
    #         '../htdocs/shared/css/module.css',
    #         '../htdocs/shared/css/theme-responsive.css',
    #         '../htdocs/shared/css/theme.css'
    #       ]

  grunt.registerTask 'default', ['connect', 'esteWatch']
  grunt.registerTask 'lint', ['jshint']
  grunt.registerTask 'build', ['uglify', 'cssmin']
