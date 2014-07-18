_ = require('underscore')

module.exports = (tree) ->
  compile = (node) ->
    switch
      when _.isString node
        node
      when _.isArray node
        cmd = node[0]
        switch
          when /^(\+|-|\/|\*|>|>=|<|<=)$/.test cmd
            "(#{compile(node[1])}#{cmd}#{compile(node[2])})"
          when cmd == "="
            "(#{compile(node[1])}===#{compile(node[2])})"
          when /^<>|><#/.test cmd
            "(#{compile(node[1])}!==#{compile(node[2])})"
          when cmd == "IF"
            relExpr = compile node[1]
            thenStatement = compile node[2]
            "if(#{relExpr}){#{thenStatement}}"
          when cmd == "PRINT"
            exprList = (compile expr for expr in node[1])
            "print([#{exprList.join(',')}])"
          when cmd == "INPUT"
            stmts = ("#{name}=_list[#{idx}];" for name, idx in node[1])
            "(function(_list){#{stmts.join('')}})(input())"
          when cmd == "LET"
            "#{node[1]}=#{compile(node[2])}"
          when cmd == "RETURN"
            "_return()"
          else
            # this default works for other statements
            args = (compile n for n in node.slice(1))
            "#{cmd.toLowerCase()}(#{args.join(',')})"

  compile tree
