module.exports = (tokens) ->
  token for token in tokens when !/^ *$/.test(token)
