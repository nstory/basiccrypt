###
Statement -> "PRINT" Expression (',' Expression)*
Expression -> Factor ((+|-) Factor)*
Factor -> Term ((*|/) Term)*
Term -> ('-'|'+')? ([0-9]+ | [A-Z] | '(' Expression ')')
###

_ = require('underscore')

module.exports = (tokens) ->
  Statement = ->
    if /^PRINT$/.test peek()
      consume()
      el = [Expression()]
      while nextMatches /^,$/
        consume ','
        el.push consume()
      return ['PRINT', el]
    else
      # temporary...
      return Expression()

  Expression = ->
    current = Factor()
    while nextMatches /^\+|-$/
      current = [consume(), current, Factor()]
    current

  Factor = ->
    current = Term()
    while nextMatches /^\*|\/$/
      current = [consume(), current, Term()]
    current

  Term = ->
    switch
      when nextMatches /^-|\+$/
        [consume(), Term()]
      when nextMatches /^\($/
        consume '('
        e = Expression()
        consume ')'
        e
      when nextMatches /^\d+|[A-Z]$/
        consume()
      else
        throw new Error("unexpected token \"#{peek()}\"")

  consume = (expected) ->
    token = tokens.shift()
    if expected != undefined && expected != token
      throw new Error("unexpected token \"#{token}\" expected \"#{expected}\"")
    token

  peek = ->
    tokens[0]

  nextMatches = (re) ->
    re.test(peek())

  # we mutate tokens, so, make a copy to be polite
  tokens = _.clone tokens

  tree = Statement()
  if tokens.length != 0
    throw new Error("unexpected token \"#{peek()}\"")
  tree
