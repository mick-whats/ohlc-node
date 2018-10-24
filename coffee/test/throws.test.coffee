require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require '../sample/quandlSample.json'


test 'invalid data format', (t) ->
  data = ["2017-01-10",350,353,349,352,59200]
  err = t.throws -> ohlc(data)
  t.is err.message,
  'inconsistent datatypes'

test 'invalid data format', (t) ->
  data = {prices:[["2017-01-10",350,353,349,352,59200]]}
  err = t.throws -> ohlc(data)
  t.is err.message,
  'inconsistent datatypes: expected Array got Object.'

test 'invalid date', (t) ->
  data = [["2017-01-35",350,353,349,352,59200]]
  err = t.throws -> ohlc(data)
  t.is err.message,
    'invalid date: 2017-01-35'
