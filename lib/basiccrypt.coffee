readline = require 'readline'
parse = require './parse.js'
lex = require './lex.js'
jsify = require './jsify.js'

print = (args) ->
  console.log args...

rl = readline.createInterface
  input: process.stdin
  output: process.stdout

rl.on 'line', (line) ->
  try
    tokens = lex line
    tree = parse tokens
    js = jsify tree
    console.log "Tokens: #{JSON.stringify(tokens)}"
    console.log "Tree:   #{JSON.stringify(tree)}"
    console.log "JS:     #{js}"
    eval(js)
  catch error
    console.log error
