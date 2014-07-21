_ = require 'underscore'

parse = require './parse.js'
lex = require './lex.js'
lex_clean = require './lex_clean.js'
jsify = require './jsify.js'

template = """
(function() {
// SUPPORT FUNCTIONS
var print = function(args) {
  variables.print(args.join(""));
};
var goto = function(destination) {
  ip = destination;
};
var gosub = function(destination) {
  stack.push(ip)
  ip = destination;
};
var _return = function(destination) {
  ip = stack.pop()+1;
};
var end = function() {
  ip = -1;
};
var clear = function() {
};
var list = function() {
};
var input = function() {
  var line = variables.input();
  var arr = line.split(/ +/);
  for (var i = 0; i < arr.length; i++) {
    if (/^[A-Z]$/.test(arr[i])) {
      arr[i] = variables[arr[i]];
    } else {
      arr[i] = +arr[i];
    }
  }
  return arr;
};
var rnd = function(limit) {
  return Math.floor(Math.random()*limit);
};

// STATE
var variables = (function() {return this;})();
var ip = 0;
var stack = [];

// CODE
while(ip != -1) {
  switch(ip) {
case 0:
%%CONTENT%%
    ip = -1;
    break;
    default:
      throw new Error("Jumped to invalid line number");
  }
}
})();
"""

module.exports = (program) ->
  # convert the BASIC program into an array of JS statements
  js_statements = for line, idx in program.split "\n"
    # skip empty lines
    continue if line.trim() == ""

    # separate the line number from the statement
    line_number = +(/^\d+/.exec line)[0]
    line_statement = line.replace(/^\d+/, '')

    # skip commnets
    continue if /^ *REM/.test line_statement

    # lex, parse, compile
    try
      tokens = lex line_statement
      cleaned = lex_clean tokens
      tree = parse cleaned
      js = jsify tree
    catch error
      throw new Error("line #{idx+1}: #{error.description}")

    {line_number: line_number, statement: js}

  # for every line N, there must also be a line N+1 (even if
  # it's blank. this way RETURN statements can jump to the
  # next line
  js_statements = _.uniq js_statements.concat(
    ({line_number:stmt.line_number+1, statement: ''} for stmt in js_statements)
  )

  js_statements.sort (a,b) -> a.line_number - b.line_number

  # convert the JS statements into the body of a switch statement
  content = (for stmt in js_statements
    "case #{stmt.line_number}: ip=#{stmt.line_number}; #{stmt.statement};"
  ).join "\n"

  template.replace('%%CONTENT%%', content)
