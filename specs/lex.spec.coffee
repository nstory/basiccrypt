require('source-map-support').install()

describe 'lex', ->
  lex = require '../lib/lex.js'

  examples = {
    '': []
    ' ': [' ']
    '456': ['456']
    '+-/*': ['+', '-', '/', '*']
    '=': ['=']
    '< <= <>': ['<', ' ', '<=', ' ', '<>']
    '> >= ><': ['>', ' ', '>=', ' ', '><']
    'ZXY': ['Z', 'X', 'Y']
    '()': ['(', ')']
    '"Hello, World!"': ['"Hello, World!"']
    # 'PRINT': ['PRINT']
  }

  for input, expected of examples
    do(input,expected) ->
      it "#{input} -> #{JSON.stringify(expected)}", ->
        expect(lex(input)).toEqual(expected)

  it 'errors out on a weird character', ->
    expect(-> lex('% ')).toThrow()
