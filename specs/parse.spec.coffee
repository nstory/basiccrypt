require('source-map-support').install()

describe "parse", ->
  parse = require '../lib/parse.js'

  testExample = (example) ->
    in_str = JSON.stringify(example.in)
    out_str = JSON.stringify(example.out)
    if example.throws
      it "#{in_str} -> exception", ->
        expect(-> parse(example.in)).toThrow()
    else
      it "#{in_str} -> #{out_str}", ->
        expect(parse(example.in)).toEqual(example.out)

  describe "expressions", ->
    examples = [
      {in: ['4', '+', '5'], out: ['+', '4', '5']}
      {in: ['4', '+', '5', '*', '6'], out: ['+', '4', ['*', '5', '6']]}
      {in: ['4', '*', '5', '+', '6'], out: ['+', ['*', '4', '5'], '6']}
      {in: ['4', '*', '5'], out: ['*', '4', '5']}
      {
        in: ['(', '4', '+', '5', ')', '*', '3'],
        out: ['*', ['+', '4', '5'], '3']
      }
      {in: ['-', '4', '+', '5'], out: ['+', ['-', '4'], '5']}
      {in: ['4', '-', '5', '-', '6'], out: ['-', ['-', '4', '5'], '6']}
      {in: ['12', '/', '2', '/', '3'], out: ['/', ['/', '12', '2'], '3']}
      {in: ['+', '4'], out: ['+', '4']}
      {in: ['A', '+', 'Z'], out:['+', 'A', 'Z']}
      {in: ['(', '4', '+', '4'], throws: true}
      {in: ['+'], throws: true}
      {in: ['5', '5'], throws: true}
    ]
    for example in examples
      printExample =
        in: ['PRINT'].concat(example.in)
        out: ['PRINT', [example.out]]
        throws: example.throws
      testExample printExample

  describe "relative expressions", ->
    examples = [
      {in: ['1', '=', '5'], out: ['=', '1', '5']}
      {in: ['1', '<', '5'], out: ['<', '1', '5']}
      {in: ['1', '<=', '5'], out: ['<=', '1', '5']}
      {in: ['1', '<>', '5'], out: ['<>', '1', '5']}
      {in: ['1', '>', '5'], out: ['>', '1', '5']}
      {in: ['1', '>=', '5'], out: ['>=', '1', '5']}
      {in: ['1', '><', '5'], out: ['><', '1', '5']}
      {in: ['1', '=<', '5'], throws: true}
    ]
    for example in examples
      ifExample =
        in: ['IF'].concat(example.in).concat(['THEN', 'PRINT', '4'])
        out: ['IF', example.out, ['PRINT', ['4']]]
        throws: example.throws
      testExample ifExample

  describe "statements", ->
    examples = [
      {in: ['PRINT', '4', '+', '5'], out: ['PRINT', [['+', '4', '5']]]}
      {in: ['PRINT', 'A', ',', 'B'], out: ['PRINT', ['A', 'B']]}
      {
        in: ['PRINT', 'A', ',', '4', '+', '5'],
        out: ['PRINT', ['A', ['+', '4', '5']]]
      }
      {in: ['PRINT', '"Hello, World!"'], out: ['PRINT', ['"Hello, World!"']]}
      {
        in: ['IF', 'A', '=', '4', 'THEN', 'PRINT', '5'],
        out: ['IF', ['=', 'A', '4'], ['PRINT', ['5']]]
      }
      {in: ['GOTO', '42'], out: ['GOTO', '42']}
      {in: ['INPUT', 'A', ',', 'B'], out: ['INPUT', ['A', 'B']]}
      {in: ['LET', 'A', '=', '4'], out: ['LET', 'A', '4']}
      {in: ['GOSUB', '42'], out: ['GOSUB', '42']}
      {in: ['RETURN'], out: ['RETURN']}
      {in: ['CLEAR'], out: ['CLEAR']}
      {in: ['LIST'], out: ['LIST']}
      {in: ['RUN'], out: ['RUN']}
      {in: ['END'], out: ['END']}
    ]

    testExample ex for ex in examples
