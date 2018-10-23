require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
ohlc = require '../'
objData = require '../sample/objData.json'
arrayData = require '../sample/arrayData.json'

test 'constructor with array', () ->
  
  prices = ohlc(arrayData).toDaily()
  sample = prices[0]
  expect sample
  .toEqual {
    "Date": '2017-01-04',
    Open: 348,
    High: 350,
    Low: 346,
    Close: 350,
    Volume: 68700,
  }

test 'constructor with object', () ->
  pricesArray = ohlc(arrayData).toDaily()
  pricesObject = ohlc(objData).toDaily()
  expect pricesArray
  .toEqual pricesObject

test 'constructor throw', () ->
  expect () -> ohlc([1,2,3,4])
  .toThrowError 'inconsistent datatypes'

test 'values(period)', () ->
  expect arrayData.length
  .toBe 101
  prices = ohlc(arrayData).value()
  expect prices.length
  .toBe 101
  prices = ohlc(arrayData).value('week')
  expect prices.length
  .toBe 22
  prices = ohlc(arrayData).value('month')
  expect prices.length
  .toBe 5

test 'toDaily()', () ->
  prices = ohlc(arrayData).toDaily()
  expect prices.find (item)-> item.Date is '2017-04-03'
  .toEqual {
    "Date": '2017-04-03'
    Open: 352
    High: 352
    Low: 348
    Close: 348
    Volume: 108200
  }

test 'toWeekly()', () ->
  prices = ohlc(arrayData).toWeekly()
  expect prices.find (item)-> item.Date is '2017-04-02'
  .toEqual {
    "Date": '2017-04-02'
    Open: 352
    High: 352
    Low: 338
    Close: 339
    Volume: 379400
  }

test.skip 'toWeekly() with sma', () ->
  prices = ohlc(arrayData).sma(13,26,52).round(0).toWeekly()
  expect prices.find (item)-> item.Date is '2017-04-02'
  .toEqual {
    "Date": '2017-04-02'
    Open: 352
    High: 352
    Low: 338
    Close: 339
    Volume: 379400
    sma13: 351
    sma26: null
    sma52: null
    smad13: -3.42
    smad26: null
    smad52: null
  }

# test 'start() and end()', () ->
#   prices = ohlc(arrayData).toDaily()
#   expect prices.length, 101
#   prices = ohlc(arrayData).start('2017-04-03').toDaily()
#   expect prices.length, 40
#   prices = ohlc(arrayData).end('2017-04-10').toDaily()
#   expect prices.length, 67
#   prices = ohlc(arrayData).start('2017-04-03').end('2017-04-10').toDaily()
#   expect prices.length, 6

# test 'toMonthly()', () ->
#   prices = ohlc(arrayData).toMonthly()
#   m1 = prices.find (item)-> item.Date is '2017-04-01'
#   t.deepEqual m1,{
#     "Date": '2017-04-01'
#     Open: 352
#     High: 370
#     Low: 330
#     Close: 357
#     Volume: 1514900
#   }

# test 'toChartData() by readme', () ->
#   chartData = ohlc(arrayData).sma(5,25).round(0).toChartData()
#   t.deepEqual Object.keys(chartData),['candle', 'volume','sma5','smad5','sma25','smad25']
#   t.deepEqual chartData.candle[90], [1494979200000,370,372,365,369]
#   t.deepEqual chartData.volume[90], [1494979200000,32300]
#   t.deepEqual chartData.sma5[90], [1494979200000,372]
#   t.deepEqual chartData.smad5[90], [1494979200000,-0.81]
#   t.deepEqual chartData.sma25[90], [1494979200000,359]
#   t.deepEqual chartData.smad25[90], [1494979200000,2.79]
#   expect moment(chartData.candle[90][0]).format('YYYY-MM-DD'),'2017-05-17'


# test 'toChartData()', () ->
#   chartData = ohlc(arrayData).toChartData()
#   t.deepEqual Object.keys(chartData),['candle', 'volume']
#   t.deepEqual chartData.candle[0],    [
#     1483488000000,
#     348,
#     350,
#     346,
#     350,
#     ]
#   t.deepEqual chartData.volume[0],[1483488000000,68700]

# test 'toChartData(period, opts)', () ->
#   chartData = ohlc(arrayData).sma(5,25,75).toChartData(null)
#   # chartData = prices.toChartData(null,{sma: [5,25,75]})
#   t.deepEqual Object.keys(chartData),['candle', 'volume','sma5','smad5','sma25','smad25','sma75','smad75']
#   t.deepEqual chartData.sma5[0],[1483488000000,null]
#   t.deepEqual chartData.sma5[10],[1484784000000,341]


# test 'array range', ()->
#   arr = [0,1,2,3,4,5]
#   t.deepEqual arr[2..4], [2,3,4]
#   t.deepEqual arr[2...4], [2,3]

# test 'moment', () ->
#   _format = 'gggg-ww'
#   expect moment('2018-01-01').format(_format),'2018-01'
#   expect moment('2018-01-02').format(_format),'2018-01'
#   expect moment('2018-09-19').format(_format),'2018-38'
#   expect moment('2018-12-30').format(_format),'2019-01'
#   expect moment('2018-12-31').format(_format),'2019-01'
#   expect moment('2019-01-01').format(_format),'2019-01'
#   expect moment('2019-01-02').format(_format),'2019-01'
#   expect moment('2019-05-01').format(_format),'2019-18'
#   expect moment('2019-09-01').format(_format),'2019-36'
#   t.pass()

# test 'moment 2', () ->
#   m = moment('20180921')
#   d = m.format('d') # 曜日の数値表記
#   sunday = m.subtract(d,'days').format()
#   t.pass()