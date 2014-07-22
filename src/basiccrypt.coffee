readline = require 'readline'
parse = require './parse.js'
lex = require './lex.js'
lex_clean = require './lex_clean.js'
jsify = require './jsify.js'

print = (args) ->
  console.log args...

rl = readline.createInterface
  input: process.stdin
  output: process.stdout

rl.on 'line', (line) ->
  try
    tokens = lex line
    console.log "Tokens:  #{JSON.stringify(tokens)}"
    cleaned = lex_clean tokens
    console.log "Cleaned: #{JSON.stringify(cleaned)}"
    tree = parse cleaned
    console.log "Tree:    #{JSON.stringify(tree)}"
    js = jsify tree
    console.log "JS:      #{js}"
    eval(js)
  catch error
    console.log error
