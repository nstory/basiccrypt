module.exports = (grunt) ->
  grunt.initConfig
    clean:
      build: ['build']

    coffee:
      options:
        sourceMap: true
      lib:
        files: [
          expand: true
          ext: '.js'
          src: ['lib/*.coffee']
          dest: 'build/'
        ]
      specs:
        files: [
          expand: true
          ext: '.js'
          extDot: 'last'
          src: ['specs/*.coffee']
          dest: 'build/'
        ]

    coffeelint:
      build:
        files: [
          src: ['lib/*.coffee', 'Gruntfile.coffee', 'specs/*.coffee']
        ]

    jasmine_node:
      build: ['build/specs/']

    watch:
      options: {atBegin: true}
      test:
        files: ['Gruntfile.js', 'lib/**/*', 'specs/**/*']
        tasks: ['test']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-jasmine-node'

    grunt.registerTask 'test', ['clean', 'coffee', 'jasmine_node']
