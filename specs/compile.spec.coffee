require('source-map-support').install()
compile = require '../lib/compile.js'

global = `(function() {return this;})()`

describe 'compile', ->
  beforeEach ->
    global.A = undefined
    global.B = undefined

  it 'allows trailing newlines', ->
    code = compile "10 LET A = 42\n"

  it 'allows comments', ->
    code = compile "10 REM this is a comment!"

  it 'maps variables to globals', ->
    code = compile '10 LET A = 42'
    `eval(code)`
    expect(global.A).toBe 42

  it 'supports GOTO', ->
    code = compile "10 GOTO 30\n20 LET A = 42\n30 LET B = 43"
    `eval(code)`
    expect(global.A).toBe undefined
    expect(global.B).toBe 43

  it 'supports PRINT using console.log', ->
    spyOn(console, 'log')
    code = compile '10 PRINT "Hello, World!"'
    `eval(code)`
    expect(console.log).toHaveBeenCalledWith "Hello, World!"

  it 'supports END', ->
    code = compile "10 LET A = 42\n20 END\n30 LET A = 43"
    `eval(code)`
    expect(global.A).toBe 42

  it 'supports GOSUB and RETURN', ->
    code = compile "10 GOSUB 40\n20LET A = 23\n30 END\n40 RETURN"
    `eval(code)`
    expect(global.A).toBe 23

  it 'supports CLEAR (as a noop)', ->
    code = compile "10 CLEAR"
    `eval(code)`

  it 'supports LIST (as a noop)', ->
    code = compile "10 LIST"
    `eval(code)`

  xit 'supports INPUT', ->
    undefined

