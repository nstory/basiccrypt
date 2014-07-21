fs = require 'fs'
program = require 'commander'
readlineSync = require 'readline-sync'
compile = require './compile.js'

# set up global functions (for interpreter)
global = `(function() {return this;})()`
global.print = (args...)->
  console.log args...
global.input = ->
  readlineSync.question()

program.option '-c, --compile', 'compile to JavaScript and write to stdout'
program.parse process.argv

contents = fs.readFileSync program.args[0], {encoding: 'utf-8'}
compiled = compile(contents)

switch
  when program.compile
    console.log compiled
  else
    `eval(compiled)`
