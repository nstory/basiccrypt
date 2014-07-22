# lex_clean() takes an array of tokens as returned by lex.coffee
# and cleans it up (removing whitespace; expanding abbreviations)
# so that it can be parsed by parse.coffee

module.exports = (tokens) ->
  # remove white space
  tokens = (token for token in tokens when !/^ *$/.test(token))

  # expand abbreviated forms
  for token in tokens
    switch
      when /^PR/.test token
        'PRINT'
      when /^[a-z]$/.test token
        token.toUpperCase()
      else
        token

