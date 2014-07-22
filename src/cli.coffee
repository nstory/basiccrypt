fs = require 'fs'
program = require 'commander'
readlineSync = require 'readline-sync'
compile = require './compile.js'

# set up global functions (for interpreter)
global = `(function() {return this;})()`
global.print = (args...) ->
  console.log args...
global.input = ->
  readlineSync.question()

# configure and parse program arguments
program
  .usage('[options] <file>')
  .option '-p, --print', 'compile to JavaScript and write to stdout'
  .parse process.argv

switch
  when program.args.length > 1
    console.log 'Exactly one file must be passed to the command'
    program.help()
  when program.args.length == 0
    console.log 'TODO: REPL'
    process.exit 1
  else
    # read and compile the passed-in .bas file
    contents = fs.readFileSync program.args[0], {encoding: 'utf-8'}
    compiled = compile(contents)
    switch
      when program.print
        console.log compiled
      else
        `eval(compiled)`
