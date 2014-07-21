fs = require 'fs'
program = require 'commander'
compile = require './compile.js'

program.option '-c, --compile', 'compile to JavaScript and write to stdout'
program.parse process.argv

contents = fs.readFileSync program.args[0], {encoding: 'utf-8'}
compiled = compile(contents)

switch
  when program.compile
    console.log compiled
  else
    `eval(compiled)`
