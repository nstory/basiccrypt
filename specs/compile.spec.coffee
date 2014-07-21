require('source-map-support').install()
compile = require '../lib/compile.js'

global = `(function() {return this;})()`

describe 'compile', ->
  beforeEach ->
    global.A = undefined
    global.B = undefined
    global.print = jasmine.createSpy('print')
    global.input = jasmine.createSpy('input')

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

  it 'supports PRINT using global.print', ->
    code = compile '10 PRINT "Hello, "; "World!"'
    `eval(code)`
    expect(global.print).toHaveBeenCalledWith "Hello, World!"

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

  it 'does integer arithmetic', ->
    code = compile "10 LET A = 5/2"
    `eval(code)`
    expect(global.A).toBe 2

  it 'supports INPUT using global.input', ->
    global.input.andReturn "42"
    code = compile "10 INPUT A"
    `eval(code)`
    expect(global.A).toBe 42

  it 'supports letter input', ->
    global.input.andReturn "A B"
    code = compile "10 LET A = 1\n20 LET B = 2\n30 INPUT C,D"
    `eval(code)`
    expect(global.C).toBe 1
    expect(global.D).toBe 2
