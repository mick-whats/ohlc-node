require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'

ohlc = require '../'
# ohlc = require '../dist/ohlc.js'
objData = require '../sample/objData.json'
arrayData = require '../sample/arrayData.json'

test 'constructor data format', (t) ->
  data = {data: [['2017-12-12',1,1,1,1,9]]}
  o = ohlc(data)
  t.is o.items[0].Date, '2017-12-12'
test 'constructor rename options', (t) ->
  opts =
    inputDateFormat: 'MM-DD-YYYY'
    otherOption: 1
  data = [['12-13-2017',1,1,1,1,9]]
  o = ohlc(data,opts)
  t.is o.items[0].Date, '2017-12-13'
  t.deepEqual Object.keys(o.opts),['inputDateFormat','otherOption','round']

test 'constructor with array', (t) ->
  prices = ohlc(arrayData).toDaily()
  sample = prices[0]
  t.deepEqual sample,{
    "Date": '2017-01-04',
    Open: 348,
    High: 350,
    Low: 346,
    Close: 350,
    Volume: 68700,
  }

test 'constructor with object', (t) ->
  pricesArray = ohlc(arrayData).toDaily()
  pricesObject = ohlc(objData).toDaily()
  t.deepEqual pricesArray, pricesObject

test 'constructor throw', (t) ->
  e = t.throws () -> ohlc([1,2,3,4])
  t.is e.message, 'inconsistent datatypes'

test 'values(period)', (t) ->
  t.is arrayData.length, 101
  prices = ohlc(arrayData).value()
  t.is prices.length, 101
  prices = ohlc(arrayData).value('week')
  t.is prices.length, 22
  prices = ohlc(arrayData).value('month')
  t.is prices.length, 5

test 'toDaily()', (t) ->
  prices = ohlc(arrayData).toDaily()
  d1 = prices.find (item)-> item.Date is '2017-04-03'
  t.deepEqual d1,{
    "Date": '2017-04-03'
    Open: 352
    High: 352
    Low: 348
    Close: 348
    Volume: 108200
  }

test 'toWeekly()', (t) ->
  prices = ohlc(arrayData).toWeekly()
  w1 = prices.find (item)-> item.Date is '2017-04-02'
  t.deepEqual w1,{
    "Date": '2017-04-02'
    Open: 352
    High: 352
    Low: 338
    Close: 339
    Volume: 379400
  }


test 'toWeekly() with sma', (t) ->
  prices = ohlc(arrayData).sma(13,26,52).toWeekly()
  w1 = prices.find (item)-> item.Date is '2017-04-02'
  t.deepEqual w1,{
    "Date": '2017-04-02'
    Open: 352
    High: 352
    Low: 338
    Close: 339
    Volume: 379400
    sma13: 351
    sma26: null
    sma52: null
    smad13: -3.55
    smad26: null
    smad52: null
  }

test 'start() and end()', (t) ->
  prices = ohlc(arrayData).toDaily()
  t.is prices.length, 101
  prices = ohlc(arrayData).start('2017-04-03').toDaily()
  t.is prices.length, 40
  prices = ohlc(arrayData).end('2017-04-10').toDaily()
  t.is prices.length, 67
  prices = ohlc(arrayData).start('2017-04-03').end('2017-04-10').toDaily()
  t.is prices.length, 6

test 'toMonthly()', (t) ->
  prices = ohlc(arrayData).toMonthly()
  m1 = prices.find (item)-> item.Date is '2017-04-01'
  t.deepEqual m1,{
    "Date": '2017-04-01'
    Open: 352
    High: 370
    Low: 330
    Close: 357
    Volume: 1514900
  }

test 'toChartData() by readme', (t) ->
  chartData = ohlc(arrayData).sma(5,25).toChartData()
  t.deepEqual Object.keys(chartData),['candle', 'volume','sma5','smad5','sma25','smad25']
  t.deepEqual chartData.candle[90], [1494979200000,370,372,365,369]
  t.deepEqual chartData.volume[90], [1494979200000,32300]
  t.deepEqual chartData.sma5[90], [1494979200000,372]
  t.deepEqual chartData.smad5[90], [1494979200000,-0.86]
  t.deepEqual chartData.sma25[90], [1494979200000,359]
  t.deepEqual chartData.smad25[90], [1494979200000,2.76]
  t.is moment(chartData.candle[90][0]).format('YYYY-MM-DD'),'2017-05-17'


test 'toChartData()', (t) ->
  chartData = ohlc(arrayData).toChartData()
  t.deepEqual Object.keys(chartData),['candle', 'volume']
  t.deepEqual chartData.candle[0],    [
    1483488000000,
    348,
    350,
    346,
    350,
    ]
  t.deepEqual chartData.volume[0],[1483488000000,68700]

test 'toChartData(period, opts)', (t) ->
  chartData = ohlc(arrayData).sma(5,25,75).toChartData(null)
  # chartData = prices.toChartData(null,{sma: [5,25,75]})
  t.deepEqual Object.keys(chartData),['candle', 'volume','sma5','smad5','sma25','smad25','sma75','smad75']
  t.deepEqual chartData.sma5[0],[1483488000000,null]
  t.deepEqual chartData.sma5[10],[1484784000000,341]


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