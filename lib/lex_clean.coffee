module.exports = (tokens) ->
  # remove white space
  tokens = (token for token in tokens when !/^ *$/.test(token))

  # expand abbreviated forms
  for token in tokens
    switch
      when /^PR/.test token
        'PRINT'
      else
        token

