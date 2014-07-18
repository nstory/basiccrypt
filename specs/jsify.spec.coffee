jsify = require '../lib/jsify.js'

describe 'jsify', ->
  examples = [
    {in: ['PRINT', ['42']], out: '(print([42]))'}
    {in: ['PRINT', [['+', '4', '5']]], out: '(print([(4+5)]))'}
    {in: ['PRINT', [['/', '4', '5']]], out: '(print([(4/5)]))'}
    {in: ['PRINT', ['A', 'B']], out: '(print([A,B]))'}
  ]

  for example in examples
    do(example) ->
      it "#{JSON.stringify(example.in)} -> #{example.out}", ->
        expect(jsify(example.in)).toEqual(example.out)
