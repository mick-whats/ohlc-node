assert = require 'assert'
_ = require('xza').lodash
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
objData = require './objData.json'
arrayData = require './arrayData.json'

test 'constructor with array', (t) ->
  prices = new ohlc(arrayData)
  sample = prices.items.find (item)-> item.Date is '2017-01-04'
  t.deepEqual sample,{
    "Date": '2017-01-04',
    Open: 348,
    High: 350,
    Low: 346,
    Close: 350,
    Volume: 68700,
  }

test 'constructor with object', (t) ->
  pricesArray = new ohlc(arrayData)
  pricesObject = new ohlc(objData)
  t.deepEqual pricesArray.toDays()[0], pricesObject.toDays()[0]

test 'constructor throw', (t) ->
  e = t.throws () ->new ohlc([1,2,3,4])
  t.is e.message, 'ArrayType Or ObjectType Required'

test 'toDays()', (t) ->
  prices = new ohlc(arrayData)
  days = prices.toDays()
  d1 = days.find (item)-> item.Date is '2017-04-03'
  t.deepEqual d1,{
    "Date": '2017-04-03'
    Open: 352
    High: 352
    Low: 348
    Close: 348
    Volume: 108200
  }

test 'toWeeks()', (t) ->
  prices = new ohlc(arrayData)
  weeks = prices.toWeeks()
  w1 = weeks.find (item)-> item.Date is '2017-04-02'
  t.deepEqual w1,{
    "Date": '2017-04-02'
    Open: 352
    High: 352
    Low: 338
    Close: 339
    Volume: 379400
  }

test 'toMonths()', (t) ->
  prices = new ohlc(arrayData)
  months = prices.toMonths()
  m1 = months.find (item)-> item.Date is '2017-04-01'
  t.deepEqual m1,{
    "Date": '2017-04-01'
    Open: 352
    High: 370
    Low: 330
    Close: 357
    Volume: 1514900
  }

test 'addSma(range)', (t) ->
  prices = new ohlc(arrayData)
  prices.addSma(5)
  samples = prices.toDays().filter (item)-> item.Date.includes('2017-02-')
  t.is samples[0].sma5, 347
  t.is samples[1].sma5, 347
  t.is samples[2].sma5, 346
  
test 'array range', (t)->
  arr = [0,1,2,3,4,5]
  t.deepEqual arr[2..4], [2,3,4]
  t.deepEqual arr[2...4], [2,3]

test 'moment', (t) ->
  _format = 'gggg-ww'
  t.is moment('2018-01-01').format(_format),'2018-01'
  t.is moment('2018-01-02').format(_format),'2018-01'
  t.is moment('2018-09-19').format(_format),'2018-38'
  t.is moment('2018-12-30').format(_format),'2019-01'
  t.is moment('2018-12-31').format(_format),'2019-01'
  t.is moment('2019-01-01').format(_format),'2019-01'
  t.is moment('2019-01-02').format(_format),'2019-01'
  t.is moment('2019-05-01').format(_format),'2019-18'
  t.is moment('2019-09-01').format(_format),'2019-36'
  t.pass()

test 'moment 2', (t) ->
  m = moment('20180921')
  d = m.format('d') # 曜日の数値表記
  sunday = m.subtract(d,'days').format()
  t.pass()