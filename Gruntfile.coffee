module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: './tmp'
          install: true

    stylus:
      dist:
        options:
          compress: false
          urlfunc:
            name: 'data-uri'
            paths: [(__dirname + '/public')]
          'include css': true
          paths: [(__dirname + '/public')]
        files:
          './tmp/compiled_css/styles.css': './*/*.styl'

    autoprefixer:
      options:
        browsers: ['last 2 version', '> 1%', 'ie 9', 'android 4']
      dist:
        files:
          './tmp/autoprefixed_css/styles.css': './tmp/compiled_css/styles.css'

    cssmin:
      dist:
        options:
          report: 'min'
          keepSpecialComments: 0
        files:
          './dist/styles.css': './tmp/autoprefixed_css/styles.css'

    copy:
      js:
        files: [
          expand: true
          flatten: true
          src: ['./tmp/js/**']
          dest: './dist/vendor/js/'
          filter: 'isFile'
        ]
      css:
        files: [
          expand: true
          flatten: true
          src: ['./tmp/css/**']
          dest: './dist/vendor/css/'
          filter: 'isFile'
        ]

    clean:
      all: ['./dist'
            './bower_components']
      tmp: ['./tmp']

    notify_hooks:
      options:
        enabled: true
        max_jshint_notifications: 5

  require('load-grunt-tasks') grunt
  grunt.task.run 'notify_hooks'

  grunt.registerTask 'build', ['clean', 'bower', 'copy', 'stylus',
                               'autoprefixer', 'cssmin', 'clean:tmp']