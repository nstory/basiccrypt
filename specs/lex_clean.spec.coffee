describe 'lex_clean', ->
  lex_clean = require '../lib/lex_clean.js'

  examples = [
    {in: ['PRINT', ' ', '42'], out: ['PRINT', '42']}
  ]

  for example in examples
    do(example) ->
      it "#{JSON.stringify(example.in)} -> #{JSON.stringify(example.out)}", ->
        expect(lex_clean example.in).toEqual example.out
