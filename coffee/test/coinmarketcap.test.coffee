require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require './coinmarketcap.json'

test.skip 'coinmarketcap format', (t) ->
  prices = ohlc(data).value()
  t.deepEqual prices[0],{
    Close: 266,
    Date: '2013-07-16',
    High: 7367.33,
    Low: 6758.72,
    Open: 269,
    Volume: 4653770240,
  }

