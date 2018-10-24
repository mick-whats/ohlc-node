require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require '../sample/coinmarketcap.json'

test 'coinmarketcap format', (t) ->
  opts =
    inputDateFormat: 'MMM DD, YYYY'
  prices = ohlc(data,opts).value()
  t.deepEqual prices[0],{
    Close: 7078.5,
    Date: '2017-11-02',
    High: 7367.33,
    Low: 6758.72,
    Open: 6777.77,
    Volume: 4653770240,
    'Market Cap': 112909656064
  }

test 'coinmarketcap', (t) ->
  opts =
    INPUTDATEFORMAT: 'MMM DD, YYYY'
  prices = ohlc(data,opts).sma(5,25,75).value()
  t.snapshot prices

test 'validate', (t) ->
  opts =
    INPUTDATEFORMAT: 'MMM DD, YYYY'
  errors = ohlc(data,opts).validate()
  # t.log errors
  t.pass()