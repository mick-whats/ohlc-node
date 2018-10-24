require('source-map-support').install()
{test} = require 'ava'
{decimalPlace} = require '../lib/util'
Big = require('big.js')

test 'decimalPlace', (t) ->
  t.is decimalPlace('test'),0
  t.is decimalPlace(0/0),0
  t.is decimalPlace(1.23e+1),1
  t.is decimalPlace(1.23e+10),0
  t.is decimalPlace(1.2345678e+3),4
  t.is decimalPlace(1.2345678e+10),0
  t.is decimalPlace(1e+10),0
  t.is decimalPlace(10e+1),0
  t.is decimalPlace(1234567890123456789012345678),0
  t.is decimalPlace(1.23e-7),9
  t.is decimalPlace(1.234567e-3),9
  t.is decimalPlace(1),0
  t.is decimalPlace(1000000),0
  t.is decimalPlace(0.000001),6
  t.is decimalPlace(0.00000001),8
  t.is decimalPlace(0.0000000123),10
  t.is decimalPlace(0.1234567890),9
  t.is decimalPlace(0.1234567891),10
  t.is decimalPlace(0.00000000000000000000000000000000001),35
test 'Math.abs',(t) ->
  t.is Math.abs(0.0000001), 1e-7
  t.is Math.abs(1.0000001), 1.0000001


