'use strict'

module.exports = (grunt)->

  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      lib:
        src: '<%= watch.lib.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        no_trailing_whitespace:
          level: 'error'
        max_line_length:
          level: 'warn'
        indentation:
          level: 'warn'
    coffee:
      lib:
        expand: true
        cwd: 'src/lib/'
        src: ['**/*.coffee']
        dest: 'out/lib/'
        ext: '.js'
      test:
        expand: true
        cwd: 'src/test/'
        src: ['**/*.coffee']
        dest: 'out/test/'
        ext: '.js'
    simplemocha:
      all:
        src: [
          'node_modules/should/lib/should.js'
          'out/test/**/*.js'
        ]
        options:
          globals: ['should', 'JSZip', 'JSZipBase64']
          timeout: 3000
          ignoreLeaks: false
          ui: 'bdd'
          reporter: 'spec'
    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      lib:
        files: ['src/lib/**/*.coffee']
        tasks: ['coffeelint:lib', 'coffee:lib', 'simplemocha']
      test:
        files: ['src/test/**/*.coffee']
        tasks: ['coffeelint:test', 'coffee:test', 'simplemocha']
    clean: ['out/']
    copy:
      main:
        files: [
            expand: true
            cwd: 'src/'
            src: ['**/*.js', 'bin/**']
            dest: 'out/'
        ]
    shell:
      'npm-link':
        command: 'npm link'
      'npm-publish':
        command: 'npm publish ./'

  grunt.event.on 'watch', (action, files, target)->
    grunt.log.writeln "#{target}: #{files} has #{action}"

    # coffeelint
    grunt.config ['coffeelint', target], src: files

    # coffee
    coffeeData = grunt.config ['coffee', target]
    files = [files] if _.isString files
    files = files.map (file)-> path.relative coffeeData.cwd, file
    coffeeData.src = files

    grunt.config ['coffee', target], coffeeData

  # tasks.
  grunt.registerTask 'compile', [
    'coffeelint'
    'coffee'
    'copy'
  ]

  grunt.registerTask 'test', [
    'simplemocha'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]

  grunt.registerTask 'prepare', [
    'clean'
    'compile'
    'test'
  ]

  grunt.registerTask 'link', [
    'prepare'
    'shell:npm-link'
  ]

  grunt.registerTask 'publish', [
    'prepare'
    'shell:npm-publish'
  ]


