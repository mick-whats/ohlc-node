require('source-map-support').install()
_ = require('lodash')
{test} = require 'ava'
calc = require '../lib/calc'
Big = require('big.js')

test.skip 'title', (t) ->
  t.log _.iteratee({ 'user': 'barney', 'active': true }).toString()
  t.log _.iteratee(['user', 'fred']).toString()
  t.log _.iteratee('user').toString()
  t.pass()

test 'js', (t) ->
  a = 17.85
  b = 2.55
  t.is a+b,20.400000000000002
  t.is parseFloat(Big(a).plus(b)),20.4
  return
test 'Big', (t) ->
  a = new Big(0).plus(3)
  b = Big(0).plus(3)
  t.is parseFloat(a),parseFloat(b)
  return
test 'sum', (t) ->
  t.is calc.sum([1,2,3,4,5]), 15
  return
test 'sumBy', (t) ->
  arr = [
    {a:1,b:2}
    {a:2,b:4}
    {a:3,b:6}
    {a:4,b:8}
    {a:5,b:10}
  ]
  t.is calc.sumBy(arr,'a'), 15
  t.is calc.sumBy(arr,'b'), 30
  t.is calc.sumBy(arr,(o)->o.b), 30
  return
test 'mean', (t) ->
  t.is calc.mean([1,2,3,4,5]), 3
  return

test 'meanBy', (t) ->
  arr = [
    {a:1,b:2}
    {a:2,b:4}
    {a:3,b:6}
    {a:4,b:8}
    {a:5,b:10}
  ]
  t.is calc.meanBy(arr,'a'), 3
  t.is calc.meanBy(arr,'b'), 6
  t.is calc.meanBy(arr,(o)->o.b), 6
  return

test 'changeIn', (t) ->
  t.is calc.changeIn(100,90),-10
  t.is calc.changeIn(200,190),-5

test 'addSma', (t) ->
  data = [
    {Close: 0.1}
    {Close: 0.2}
    {Close: 0.3}
    {Close: 0.4}
    {Close: 0.5}
    {Close: 0.6}
    {Close: 0.7}
  ]
  res = calc.addSma(3,data)
  t.deepEqual res,[
    {
      Close: 0.1,
      sma3: null,
      smad3: null,
    },
    {
      Close: 0.2,
      sma3: null,
      smad3: null,
    },
    {
      Close: 0.3,
      sma3: 0.2,
      smad3: -33.33,
    },
    {
      Close: 0.4,
      sma3: 0.3,
      smad3: -25,
    },
    {
      Close: 0.5,
      sma3: 0.4,
      smad3: -20,
    },
    {
      Close: 0.6,
      sma3: 0.5,
      smad3: -16.67,
    },
    {
      Close: 0.7,
      sma3: 0.6,
      smad3: -14.29,
    },
  ]

