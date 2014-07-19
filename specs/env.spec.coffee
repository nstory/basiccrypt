describe 'env', ->
  env = null
  output = null

  beforeEach ->
    env = require '../lib/env.js'
    output = []
    env.print = (list) ->
      output.push list

  it 'executes an immediate statement', ->
    env 'PRINT (4+5)*6+7'
    expect(output).toEqual([[61]])

  it 'assign to a variable', ->
    env 'LET A = 5'
    env 'PRINT A'
    expect(output).toEqual([[5]])

  it 'saves statements to run later', ->
    env '10 PRINT 10'
    env '20 PRINT 20'
    expect(output).toEqual []
    env 'RUN'
    expect(output).toEqual [[10],[20]]
