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
        options:
          'arrow_spacing': {level: 'error'}
          'line_endings': {level: 'error'}
          'missing_fat_arrows': {level: 'error'}
          'newlines_after_classes': {level: 'error'}
          'no_empty_functions': {level: 'error'}
          'no_empty_param_list': {level: 'error'}
          'no_stand_alone_at': {level: 'error'}
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
      lint:
        files: ['Gruntfile.js', 'lib/**/*', 'specs/**/*']
        tasks: ['lint']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-jasmine-node'

    grunt.registerTask 'lint', ['coffeelint']
    grunt.registerTask 'test', ['clean', 'coffee', 'jasmine_node']
