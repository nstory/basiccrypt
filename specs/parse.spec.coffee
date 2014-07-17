require('source-map-support').install()

describe "parse", ->
    parse = require '../lib/parse.js'
    examples = [
        {in: ['4', '+', '5'], out: ['+', '4', '5']}
        {in: ['4', '+', '5', '*', '6'], out: ['+', '4', ['*', '5', '6']]}
        {in: ['4', '*', '5', '+', '6'], out: ['+', ['*', '4', '5'], '6']}
        {in: ['4', '*', '5'], out: ['*', '4', '5']}
        {in: ['(', '4', '+', '5', ')', '*', '3'], out: ['*', ['+', '4', '5'], '3']}
        {in: ['-', '4', '+', '5'], out: ['+', ['-', '4'], '5']}
        {in: ['4', '-', '5', '-', '6'], out: ['-', ['-', '4', '5'], '6']}
        {in: ['(', '4', '+', '4'], throws: true}
        {in: ['+'], throws: true}
    ]

    for example in examples
        do (example) ->
            it "#{JSON.stringify(example.in)} -> #{if example.throws then 'exception' else JSON.stringify(example.out)}", ->
                if example.throws
                    expect(-> parse(example.in)).toThrow()
                else
                    expect(parse(example.in)).toEqual(example.out)
