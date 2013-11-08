'use strict'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  # 変更があったファイルのみwatchの対象に。filter: changed_onlyで有効化
  # http://mohayonao.hatenablog.com/entry/2013/03/26/093554
  GRUNT_CHANGED_PATH = '.grunt-changed-file'
  if grunt.file.exists GRUNT_CHANGED_PATH
    changed = grunt.file.read GRUNT_CHANGED_PATH
    grunt.file.delete GRUNT_CHANGED_PATH
    changed_only = (file)-> file is changed
  else
    changed_only = -> true

  grunt.event.on 'watch', (action, filepath, target)->
    if action is 'changed'
      grunt.file.write GRUNT_CHANGED_PATH, filepath
    if action is 'deleted'
      grunt.file.delete filepath.replace(/^\.\.\/src\/(.+)$/, '../htdocs/$1'), { force: true } # ファイルの削除
 
  grunt.initConfig
 
    pkg:
      grunt.file.readJSON 'package.json'

    copy:
      bower:
        expand: true
        flatten: true
        cwd: '../bower/bower_components/' # srcの固定。destは固定されない
        src: ['jquery/jquery.js']
        dest: '../src/shared/js/libs'
        filter: 'isFile'
      src:
        expand: true
        flatten: false
        cwd: '../src'
        src: ['**/*', '!**/*.coffee', '!**/*.scss']
        dest: '../htdocs/'
        filter: changed_only

    coffee:
      compile:
        expand: true
        flatten: false #src内のディレクトリをキープして出力
        cwd: '../src'
        src: '**/*.coffee'
        dest: '../htdocs/'
        ext: '.js'
        filter: changed_only

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

    watch:
      src:
        files: ['../src/**/*']
        tasks: ['coffee', 'compass', 'copy:src']
        options:
          livereload: true
          nospawn: false
      # html:
      #   files: ['../src/**/*.html']
      #   tasks: ['copy:src']
      #   options:
      #     livereload: true
      #     nospawn: false
      # css:
      #   files: ['../src/**/*.css', '../src/**/*.scss']
      #   tasks: ['compass', 'copy:src']
      #   options:
      #     livereload: true
      #     nospawn: false
      # js:
      #   files: ['../src/**/*.js', '../src/**/*.coffee']
      #   tasks: ['coffee', 'copy:src']
      #   options:
      #     livereload: true
      #     nospawn: false

  grunt.registerTask 'init', ['copy:bower']
  grunt.registerTask 'default', ['watch']
  grunt.registerTask 'lint', ['jshint']
  grunt.registerTask 'build', ['uglify', 'cssmin']