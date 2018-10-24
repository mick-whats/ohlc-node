require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
ohlc = require '../'
data = require '../sample/quandlSample.json'

test 'validate', (t) ->
  inValid = ohlc(data).validate()
  t.is inValid.length, 2
test 'validate verbose', (t) ->
  inValid = ohlc(data).validate(false)
  t.is inValid.length, 93

test 'volume minus', (t) ->
  inValid = ohlc([['20170808',1,1,1,1,-2 ]]).validate()
  t.is inValid.length, 1
  t.is inValid[0].msg, 'volume is Negative Number.'
test 'not Close', (t) ->
  inValid = ohlc([['20170808',1,1,1,0,1 ]]).validate()
  t.is inValid.length, 1
  t.is inValid[0].msg, 'Close value is invalid'
test 'not Close', (t) ->
  inValid = ohlc([['20170808',1,1,1,1,{a:1} ]]).validate()
  t.is inValid.length, 1
  t.is inValid[0].msg, 'Item value is invalid'