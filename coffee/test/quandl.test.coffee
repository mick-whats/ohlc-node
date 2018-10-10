require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require './quandlSample.json'

test 'quandl format', (t) ->
  prices = ohlc(data).value()
  t.deepEqual prices[0],{
    Close: 266,
    Date: '2013-07-16',
    High: 269,
    Low: 262,
    Open: 269,
    Volume: 3000,
  }

# test 'valid catch', (t) ->
#   t.notThrows -> ohlc(data).validate(true).value()
# test 'valid throw', (t) ->
#   e = t.throws -> ohlc(data).silent(true).validate().value()
#   t.true e.message.includes('inconsistent value - {"Date":')

test.skip 'if volume zero then modify ', (t) ->
  prices = ohlc(data).value()
  item_a = prices.find (item)-> item.Date is '2013-07-18'
  t.deepEqual item_a,{
    Close: 266,
    Date: '2013-07-18',
    High: 266,
    Low: 266,
    Open: 266,
    Volume: 0,
  }
  t.log prices.find (item)-> item.Date is '2015-09-17'
  item_b = prices.find (item)-> item.Date is '2017-05-19'
  t.deepEqual item_a,{
    Close: 266,
    Date: '2013-07-18',
    High: 266,
    Low: 266,
    Open: 266,
    Volume: 0,
  }
  prices = ohlc(data).modifyVolumeZero().value()
  item_a = prices.find (item)-> item.Date is '2013-07-18'
  t.deepEqual item_a,{
    Close: 266,
    Date: '2013-07-18',
    High: 266,
    Low: 266,
    Open: 266,
    Volume: 0,
  }
  item_b = prices.find (item)-> item.Date is '2017-05-19'
  t.deepEqual item_a,{
    Close: 266,
    Date: '2013-07-18',
    High: 266,
    Low: 266,
    Open: 266,
    Volume: 0,
  }
  