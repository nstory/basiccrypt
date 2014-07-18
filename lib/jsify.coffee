_ = require('underscore')

module.exports = (tree) ->
  compile = (node) ->
    switch
      when _.isString node
        node
      when _.isArray node
        cmd = node[0]
        switch
          when /^(\+|-|\/|\*)$/.test cmd
            "(#{compile(node[1])}#{cmd}#{compile(node[2])})"
          when cmd == "PRINT"
            exprList = (compile expr for expr in node[1])
            "(print([#{exprList.join(',')}]))"

  compile tree
