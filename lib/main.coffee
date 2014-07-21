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

program
  .usage('[options] <file>')
  .option '-p, --print', 'compile to JavaScript and write to stdout'
  .parse process.argv

if program.args.length isnt 1
  console.log 'Exactly one file must be passed to the command'
  program.help()

contents = fs.readFileSync program.args[0], {encoding: 'utf-8'}
compiled = compile(contents)

switch
  when program.print
    console.log compiled
  else
    `eval(compiled)`
