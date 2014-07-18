require('source-map-support').install()

describe "parse", ->
    parse = require '../lib/parse.js'
    examples = [
        # EXPRESSIONS
        {in: ['4', '+', '5'], out: ['+', '4', '5']}
        {in: ['4', '+', '5', '*', '6'], out: ['+', '4', ['*', '5', '6']]}
        {in: ['4', '*', '5', '+', '6'], out: ['+', ['*', '4', '5'], '6']}
        {in: ['4', '*', '5'], out: ['*', '4', '5']}
        {in: ['(', '4', '+', '5', ')', '*', '3'], out: ['*', ['+', '4', '5'], '3']}
        {in: ['-', '4', '+', '5'], out: ['+', ['-', '4'], '5']}
        {in: ['4', '-', '5', '-', '6'], out: ['-', ['-', '4', '5'], '6']}
        {in: ['12', '/', '2', '/', '3'], out: ['/', ['/', '12', '2'], '3']}
        {in: ['+', '4'], out: ['+', '4']}
        {in: ['A', '+', 'Z'], out:['+', 'A', 'Z']}
        {in: ['(', '4', '+', '4'], throws: true}
        {in: ['+'], throws: true}
        {in: ['5', '5'], throws: true}

        # PRINT
        {in: ['PRINT', '4', '+', '5'], out: ['PRINT', [['+', '4', '5']]]}
        {in: ['PRINT', 'A', ',', 'B'], out: ['PRINT', ['A', 'B']]}
    ]

    for example in examples
        do (example) ->
            it "#{JSON.stringify(example.in)} -> #{if example.throws then 'exception' else JSON.stringify(example.out)}", ->
                if example.throws
                    expect(-> parse(example.in)).toThrow()
                else
                    expect(parse(example.in)).toEqual(example.out)
