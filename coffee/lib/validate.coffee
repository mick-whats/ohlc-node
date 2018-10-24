messages = require('./message').error
_ = require '../node_modules/lodash/lodash.min.js'
moment = require '../node_modules/moment/min/moment.min.js'

class Errors
  constructor: (@org) ->
    @items = []
    @length = @items.length
  add: (item,messageNumber)=>
    message = messages[messageNumber]
    @items.push {
      item: item
      original: @org.find (orgItem)->
        moment(orgItem[0]).valueOf() is moment(item.Date).valueOf()
      level: message[0]
      errid: messageNumber
      msg: message[2]
      msg_jp: message[1]
    }
    @length = @items.length
    return @
  out:(compact=true) ->
    if compact
      items = _.groupBy(@items,'errid')
      items = Object.keys(items).map (id)-> items[id][0]
    else
      items = @items
    return items

module.exports = (compact)->
  err = new Errors(@org)
  @items.forEach (item,i)->
    # item.VolumeはParseFloatされているので値が不正でもNaNになる
    # つまり必ずNumberになる
    if item.Volume < 0
      err.add(item,2)
    else if item.Volume > 0
      if not item.Close
        err.add(item,5)
    else # Volume is zero or NaN
      if Number.isNaN(item.Open)
        err.add(item,3)
      else if not (item.Close is item.High is item.Low is item.Open)
        err.add(item,4)
      else if Number.isNaN(item.Volume)
        err.add(item,0)


  return err.out(compact)