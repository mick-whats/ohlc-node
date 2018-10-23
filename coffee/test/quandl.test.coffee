require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require '../sample/quandlSample.json'

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
  
test 'validate', (t) ->
  err = ohlc(data).validate()
  t.is err[0].msg, 'Four values (ohlc) are invalid.'
  t.deepEqual err[0].original, ['2017-05-19',null,null,null,null,0]
  t.is err[1].msg, 'Volume is zero, but the four values are different'
  t.deepEqual err[1].original, ['2013-09-17',245,245,243,243,0]

test 'modify', (t) ->
  err = ohlc(data).modify().validate()
  t.is err.length, 0

test 'modify 2013-09-17', (t) ->
  prices = ohlc(data).modify().value()
  item = prices.find (item)-> item.Date is '2013-09-17'
  t.deepEqual item, {
    Close: 243,
    Date: '2013-09-17',
    High: 243,
    Low: 243,
    Open: 243,
    Volume: 0,
  }

test 'modify 2017-05-19', (t) ->
  prices = ohlc(data).modify().value()
  item = prices.find (item)-> item.Date is '2017-05-19'
  t.deepEqual item, {
    Close: 1987,
    Date: '2017-05-19',
    High: 1987,
    Low: 1987,
    Open: 1987,
    Volume: 0,
  }
  
