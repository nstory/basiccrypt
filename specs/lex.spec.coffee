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
    'zxy': ['z', 'x', 'y']
    '()': ['(', ')']
    '"Hello, World!"': ['"Hello, World!"']
    'PRINTIFGOTOINPUTLET': ['PRINT', 'IF', 'GOTO', 'INPUT', 'LET']
    'GOSUBRETURNCLEAR': ['GOSUB', 'RETURN', 'CLEAR']
    'LISTRUNEND': ['LIST', 'RUN', 'END']
    'THEN': ['THEN']
    ',;': [',', ';']
    'PRPRI': ['PR', 'PRI']
    'RND': ['RND']
  }

  for input, expected of examples
    do(input,expected) ->
      it "#{input} -> #{JSON.stringify(expected)}", ->
        expect(lex(input)).toEqual(expected)

  it 'errors out on a weird character', ->
    expect(-> lex('% ')).toThrow()
