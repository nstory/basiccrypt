_ = require 'underscore'

parse = require './parse.js'
lex = require './lex.js'
lex_clean = require './lex_clean.js'
jsify = require './jsify.js'

module.exports = do ->
  statements = []
  variables = {}

  # add the statement to the statements array; replace any existing
  # element with the same line_number
  addStatement = (statement) ->
    statements.unshift statement
    statements = _.uniq statements, (stmt) -> stmt.line_number
    statements.sort (a,b) -> a.line_number - b.line_number

  # the exported is "env"
  env = (line) ->
    # expose functions
    print = env.print

    # run needs to be in this lexical scope, so eval'd code has access
    # to print, variables, etc.
    run = ->
      js_statements = for line in statements
        tokens = lex line.statement
        cleaned = lex_clean tokens
        tree = parse cleaned
        (jsify tree) + ';'
      program = js_statements.join ''
      print = env.print
      eval program

    # if the line starts with a line number, save away the statement,
    # otherwise it should be executed immediately
    switch
      when /^\d+/.test line
        addStatement
          line_number: +(/^\d+/.exec line)[0]
          statement: line.replace(/^\d+/, '')
      else
        tokens = lex line
        cleaned = lex_clean tokens
        tree = parse cleaned
        js = jsify tree
        eval js

  env.list = ->
    statements

  env
