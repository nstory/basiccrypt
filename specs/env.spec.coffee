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
    expect(env.list()).toEqual [
      {line_number: 10, statement: " PRINT 10"}
    ]

  it 'replaces earlier statements', ->
    env '10 PRINT 1'
    env '20 PRINT A'
    env '10 INPUT A'
    expect(env.list()).toEqual [
      {line_number: 10, statement: " INPUT A"}
      {line_number: 20, statement: " PRINT A"}
    ]

  it 'run', ->
    env '10 PRINT 1'
    env '20 PRINT 2'
    env 'RUN'
    expect(output).toEqual [[1],[2]]

  it 'goto', ->
    env '10 PRINT 1'
    env '20 GOTO 40'
    env '30 PRINT 3'
    env '40 PRINT 4'
    env 'RUN'
    expect(output).toEqual [[1],[4]]
