parse = require './parse.js'
lex = require './lex.js'
lex_clean = require './lex_clean.js'
jsify = require './jsify.js'

module.exports = do ->
  variables = {}
  env = (line) ->
    print = env.print
    tokens = lex line
    cleaned = lex_clean tokens
    tree = parse cleaned
    js = jsify tree
    eval js

