###
E -> F (+|-) E
F -> T ((*|/) T)*
T -> '-'? [0-9]+ | '(' E ')'
###

_ = require('underscore')

module.exports = (tokens) ->
    E = ->
        left = F()
        return left if peek() != '+' && peek() != '-'
        op = consume()
        right = E()
        [op, left, right]

    F = ->
        left = T()
        return left if peek() != '*' && peek() != '/'
        op = consume()
        right = T()
        [op, left, right]

    T = ->
        if peek() == '-'
            return [consume('-'), T()]
        if peek() == '('
            consume('(')
            e = E()
            consume(')')
            return e
        if /^\d+$/.test peek()
            return consume()
        throw "unexpected token \"#{peek()}\""

    consume = (expected) ->
        token = tokens.shift()
        if expected != undefined && expected != token
            throw "unexpected token \"#{token}\" expected \"#{expected}\""
        token

    peek = ->
        tokens[0]

    # we mutate tokens, so, make a copy to be polite
    tokens = _.clone tokens

    E()
