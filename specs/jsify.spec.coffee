jsify = require '../lib/jsify.js'

describe 'jsify', ->
  examples = [
    {in: ['PRINT', ['42']], out: 'print([42])'}
    {in: ['PRINT', [['+', '4', '5']]], out: 'print([(4+5)])'}
    {in: ['PRINT', [['/', '4', '5']]], out: 'print([(4/5)])'}
    {in: ['PRINT', ['A', 'B']], out: 'print([A,B])'}
    {
      in: ['IF', ['=', '1', '1'], ['PRINT', ['42']]]
      out: 'if((1===1)){print([42])}'
    }
    {
      in: ['IF', ['<>', '1', '1'], ['PRINT', ['42']]]
      out: 'if((1!==1)){print([42])}'
    }
    {in: ['GOTO', '42'], out: 'goto(42)'}
    {
      in: ['INPUT', ['A', 'B']]
      out: '(function(_list){A=_list[0];B=_list[1];})(input())'
    }
    {in: ['LET', 'A', '42'], out: 'A=42'}
    {in: ['GOSUB', '42'], out: 'gosub(42)'}
    {in: ['RETURN'], out: '_return()'}
    {in: ['CLEAR'], out: 'clear()'}
    {in: ['LIST'], out: 'list()'}
    {in: ['RUN'], out: 'run()'}
    {in: ['END'], out: 'end()'}
  ]

  for example in examples
    do(example) ->
      it "#{JSON.stringify(example.in)} -> #{example.out}", ->
        expect(jsify(example.in)).toEqual(example.out)
