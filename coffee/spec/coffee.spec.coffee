# require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
ohlc = require '../../'
objData = require '../../sample/objData.json'
arrayData = require '../../sample/arrayData.json'
{decimalPlace} = require '../lib/util'
Big = require('big.js')
coffee = require('coffeescript')

test 'coffee', () ->
  expect coffee.compile('console.log hoge', bare: true)
  .toBe 'console.log(hoge);\n'
