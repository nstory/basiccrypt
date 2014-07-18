###
Statement -> "PRINT" Expression (',' Expression)*
Expression -> Factor ((+|-) Factor)*
Factor -> Term ((*|/) Term)*
Term -> ('-'|'+')? ([0-9]+ | [A-Z] | '(' Expression ')')
###

_ = require('underscore')

module.exports = (tokens) ->
  Statement = ->
    switch
      when nextMatches /^PRINT$/
        consume()
        el = [Expression()]
        while nextMatches /^,$/
          consume ','
          el.push Expression()
        ['PRINT', el]
      when nextMatches /^IF$/
        consume()
        left = Expression()
        op = consume(/^(=|<|<=|<>|>|>=|><)$/)
        right = Expression()
        consume('THEN')
        stmt = Statement()
        ['IF', [op, left, right], stmt]
      else
        unexpected()

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
        unexpected()

  consume = (expected) ->
    token = tokens.shift()
    if _.isString(expected) and expected != token
      unexpected(expected)
    else if _.isRegExp(expected) and not expected.test(token)
      unexpected(expected)
    token

  peek = ->
    tokens[0]

  nextMatches = (re) ->
    re.test(peek())

  unexpected = (expected) ->
    if expected?
      throw new Error("unexpected token #{peek()} expected #{expected}")
    else
      throw new Error("unexpected token #{peek()}")

  # we mutate tokens, so, make a copy to be polite
  tokens = _.clone tokens

  tree = Statement()
  if tokens.length != 0
    unexpected()
  tree
