require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require './quandlSample.json'

test.skip 'validate', (t) ->
  prices = ohlc(data).validate()
  t.is prices.errors().length, 93
  prices.errorLog()
  # t.log errors.compact().out()
  t.pass()
test.skip 'modify after validate', (t) ->
  errors = ohlc(data).modifyZero().validate()
  t.is errors.length, 0
  # t.log errors
  t.pass()
