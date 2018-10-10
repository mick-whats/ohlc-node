# TODO: このファイルを削除

require('source-map-support').install()
_ = require('lodash')
{test} = require 'ava'

test '文字列で計算', (t) ->
  t.is 100   + '2', '1002'
  t.is '100' + 2  , '1002'
  t.is 100   - '2', 98
  t.is '100' - 2  , 98
  t.is 100   * '2', 200
  t.is '100' * 2  , 200
  t.is 100   / '2', 50
  t.is '100' / 2  , 50

test '数値にキャスト', (t) ->
  t.is +'123', 123
  t.is (+'123')+(+'123'), 246
  t.is +'str', NaN
  t.is +true, 1

test 'Not a Number', (t) ->
  t.is typeof NaN, 'number'

test '配列操作', (t) ->
  arr = new Array(1,2,3)
  t.deepEqual arr,[1,2,3]
  arr[5] = 5
  t.deepEqual arr,[1,2,3, undefined,undefined,5]

test 'js', (t) ->
  t.is _.isNumber(1),true
  t.is _.isNumber(null),false
  t.is _.isNumber('1'),false
  a = [1,2,3]
  t.false !a
  t.false !1
  t.true !0
  t.false !true
  t.true !false

fn = (val)->
  obj.val = Number(val)

test 'Number()', (t) ->
  t.is Number(1), 1
  t.is Number('1'), 1
  t.is Number(0), 0
  t.is Number('0'), 0
  t.is Number(true), 1
  t.is Number(false), 0
  t.is Number(null), 0
  t.is Number('string'), NaN
  t.is Number(undefined), NaN
  t.is Number(NaN), NaN
  t.is Number(Number(null)), 0
test 'parseInt()', (t) ->
  t.is parseInt(1), 1
  t.is parseInt('1'), 1
  t.is parseInt(0), 0
  t.is parseInt('0'), 0
  t.is parseInt(true), NaN
  t.is parseInt(false), NaN
  t.is parseInt(null), NaN
  t.is parseInt('string'), NaN
  t.is parseInt(undefined), NaN
  t.is parseInt(NaN), NaN
  t.is parseInt(Number(null)), 0
test 'isNaN', (t) ->
  t.is isNaN(1), false
  t.is isNaN('1'), false
  t.is isNaN(0), false
  t.is isNaN('0'), false
  t.is isNaN(true), false
  t.is isNaN(false), false
  t.is isNaN(null), false
  t.is isNaN('string'), true
  t.is isNaN(undefined), true
  t.is isNaN(NaN), true
  t.is isNaN(Number(null)), false

test 'Number.isNaN', (t) ->
  t.is Number.isNaN(1), false
  t.is Number.isNaN('1'), false
  t.is Number.isNaN(0), false
  t.is Number.isNaN('0'), false
  t.is Number.isNaN(true), false
  t.is Number.isNaN(false), false
  t.is Number.isNaN(null), false
  t.is Number.isNaN('string'), false
  t.is Number.isNaN(undefined), false
  t.is Number.isNaN(NaN), true
  t.is Number.isNaN(Number(null)), false

test '_.isNaN', (t) ->
  t.is _.isNaN(1), false
  t.is _.isNaN('1'), false
  t.is _.isNaN(0), false
  t.is _.isNaN('0'), false
  t.is _.isNaN(true), false
  t.is _.isNaN(false), false
  t.is _.isNaN(null), false
  t.is _.isNaN('string'), false
  t.is _.isNaN(undefined), false
  t.is _.isNaN(NaN), true
  t.is _.isNaN(Number(null)), false

test.skip 'moment like class', (t) ->
  class A
    constructor: (@val) ->
      @hooks = {}
      @hooks.method_A = =>
        @val = 'over ride!'
      @proto = A.prototype
      @proto.out =
        -> return @val
      @hooks.prototype = @proto
    hooks() -> return @hooks
  _A = (v)-> new A(v).hooks()
  t.is _A('test').out(), 'test'
  t.is _A.method_A, 'test'
