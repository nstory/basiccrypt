# parse() takes an array of tokens created by lex.coffee and converts
# those tokens into an AST tree (represented as nested arrays)

###
GRAMMAR (incomplete):

Statement -> "PRINT" Expression (',' Expression)*
Expression -> Factor ((+|-) Factor)*
Factor -> Term ((*|/) Term)*
Term -> ('-'|'+')? ([0-9]+ | [A-Z] | '(' Expression ')')
         | 'RND' '(' Expression ')'
###

_ = require('underscore')

module.exports = (tokens) ->
  Statement = ->
    switch
      when nextMatches /^PRINT$/
        consume 'PRINT'
        exprList = while peek()
          switch
            when peek() == ','
              consume ','
              '"\t"'
            when peek() == ';'
              consume ';'
              null
            when /^"/.test peek()
              consume()
            else
              Expression()
        ['PRINT', (e for e in exprList when e?)]
      when nextMatches /^IF$/
        consume 'IF'
        left = Expression()
        op = consume(/^(=|<|<=|<>|>|>=|><)$/)
        right = Expression()
        consume 'THEN'
        stmt = Statement()
        ['IF', [op, left, right], stmt]
      when nextMatches /^GOTO$/
        consume 'GOTO'
        ['GOTO', Expression()]
      when nextMatches /^INPUT$/
        consume 'INPUT'
        varList = [consume /^[A-Z]$/]
        while nextMatches /^,$/
          consume ','
          varList.push(consume /^[A-Z]$/)
        ['INPUT', varList]
      when nextMatches /^LET$/
        consume 'LET'
        name = consume /^[A-Z]$/
        consume '='
        expr = Expression()
        ['LET', name, expr]
      when nextMatches /^GOSUB$/
        consume 'GOSUB'
        ['GOSUB', Expression()]
      when nextMatches /^RETURN$/
        consume 'RETURN'
        ['RETURN']
      when nextMatches /^CLEAR$/
        consume 'CLEAR'
        ['CLEAR']
      when nextMatches /^LIST$/
        consume 'LIST'
        ['LIST']
      when nextMatches /^RUN$/
        consume 'RUN'
        ['RUN']
      when nextMatches /^END$/
        consume 'END'
        ['END']
      when nextMatches /^EVAL$/
        consume 'EVAL'
        exprList = [ExpressionOrString()]
        while nextMatches /^,$/
          consume ','
          exprList.push ExpressionOrString()
        ['EVAL', exprList]
      else
        unexpected()

  ExpressionOrString = ->
    switch
      when nextMatches /^"/
        consume()
      else
        Expression()

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
      when nextMatches /(^-|\+)$/
        [consume(), Term()]
      when nextMatches /^\($/
        consume '('
        e = Expression()
        consume ')'
        e
      when nextMatches /^(\d+|[A-Z])$/
        consume()
      when nextMatches /^RND$/
        consume 'RND'
        consume '('
        limit = consume /^\d+$/
        consume ')'
        ['RND', limit]
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
