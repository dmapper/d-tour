module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: './tmp'
          install: true

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

  grunt.registerTask 'build', ['clean', 'bower', 'copy', 'clean:tmp']