# lex takes one line of a BASIC program (without the line number)
# and converts it into an array of tokens suitable for parsing
# by parse.coffee; also see lex_clean.coffee

module.exports = (input) ->
  re = ///^(
    (\x20)+ # space characters
  | \d+ # numbers (integers)
  | \+|-|/|\* # arithmetic operators
  | =|<=|<>|<|>=|><|> # relative operators
  | PRINT|IF|GOTO|INPUT|LET|GOSUB|RETURN|CLEAR|LIST|RUN|END|EVAL # statements
  | PRI | PR # statement abberviations
  | RND # function
  | THEN # other keywords
  | [A-Za-z] # variables
  | \(|\) # parens
  | "[^"]*" # strings
  | ,|; # list sperators
  )///

  # note that the RegExp is _not_ /g; instead, we're removing the
  # matched portion of the string after each match
  tokens = while (matches = re.exec(input)) != null
    input = input.substr matches[0].length
    matches[0]

  if input.length
    throw new Error("unable to lex remainder of input: #{input}")

  tokens
