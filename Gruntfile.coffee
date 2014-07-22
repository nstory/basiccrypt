module.exports = (grunt) ->
  grunt.initConfig
    clean:
      build: ['build', 'lib']

    coffee:
      options:
        sourceMap: true
      src:
        files: [
          expand: true
          ext: '.js'
          cwd: 'src/'
          src: ['*.coffee']
          dest: 'lib/'
        ]
      specs:
        files: [
          expand: true
          ext: '.js'
          cwd: 'specs/'
          extDot: 'last'
          src: ['*.coffee']
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
          'no_backticks': {level: 'ignore'}
        files: [
          src: ['src/*.coffee', 'Gruntfile.coffee', 'specs/*.coffee']
        ]

    jasmine_node:
      build: ['build']

    watch:
      options: {atBegin: true}
      test:
        files: ['Gruntfile.js', 'src/**/*', 'specs/**/*']
        tasks: ['test']
      lint:
        files: ['Gruntfile.js', 'src/**/*', 'specs/**/*']
        tasks: ['lint']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-jasmine-node'

    grunt.registerTask 'lint', ['coffeelint']
    grunt.registerTask 'test', ['clean', 'coffee', 'jasmine_node']
