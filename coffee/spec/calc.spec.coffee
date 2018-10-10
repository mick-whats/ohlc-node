require('source-map-support').install()
_ = require('lodash')
# {test} = require 'ava'
calc = require '../lib/calc'
Big = require('big.js')


test 'js', () ->
  a = 17.85
  b = 2.55
  expect a+b
  .toBe 20.400000000000002
  expect parseFloat(Big(a).plus(b))
  .toBe 20.4
  return
test 'Big', () ->
  a = new Big(0).plus(3)
  b = Big(0).plus(3)
  expect parseFloat(a)
  .toBe parseFloat(b)
  return
test 'sum', () ->
  expect calc.sum([1,2,3,4,5])
  .toBe 15
  return
test 'sumBy', () ->
  arr = [
    {a:1,b:2}
    {a:2,b:4}
    {a:3,b:6}
    {a:4,b:8}
    {a:5,b:10}
  ]
  expect calc.sumBy(arr,'a')
  .toBe 15
  expect calc.sumBy(arr,'b')
  .toBe 30
  expect calc.sumBy(arr,(o)->o.b)
  .toBe 30
  return
test 'mean', () ->
  expect calc.mean([1,2,3,4,5])
  .toBe 3
  return

test 'meanBy', () ->
  arr = [
    {a:1,b:2}
    {a:2,b:4}
    {a:3,b:6}
    {a:4,b:8}
    {a:5,b:10}
  ]
  expect calc.meanBy(arr,'a')
  .toBe 3
  expect calc.meanBy(arr,'b')
  .toBe 6
  expect calc.meanBy(arr,(o)->o.b)
  .toBe 6
  return

test 'changeIn', () ->
  expect calc.changeIn(100,90)
  .toBe -10
  expect calc.changeIn(200,190)
  .toBe -5
  return
test 'addSma', () ->
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
  expect res
  .toEqual [
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

