module.exports = (input) ->
  re = ///^(
    (\x20)+ # space characters
  | \d+ # numbers (integers)
  | \+|-|/|\* # arithmetic operators
  | =|<=|<>|<|>=|><|> # relative operators
  | PRINT|IF|GOTO|INPUT|LET|GOSUB|RETURN|CLEAR|LIST|RUN|END # statements
  | THEN # other keywords
  | [A-Z] # variables
  | \(|\) # parens
  | "[^"]*" # strings
  | , # comma
  )///

  tokens = while (matches = re.exec(input)) != null
    input = input.substr matches[0].length
    matches[0]

  if input.length
    throw new Error("unable to parse remainder of input: #{input}")

  tokens
