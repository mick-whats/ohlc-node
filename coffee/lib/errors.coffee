messages = require('./message').error
# _ = require '../../node_modules/lodash/lodash.min.js'
# moment = require '../../node_modules/moment/min/moment.min.js'

# - Volumeが数値じゃない
# - Volumeが負数
# - Volumeが１以上の数値なのに Closeが負の値
# - Volumeがゼロで四本値が異なる
# TYPES =
#   DEBUG: 'DEBUG'
#   INFO: 'INFO'
#   WARN: 'WARN'
#   ERROR: 'ERROR'
#   FATAL: 'FATAL'
# class OhlcError extends Error
#   constructor: (message) ->
#     super()
#     @message = message
#     @stack = (new Error()).stack
#     @name = @constructor.name

# # volumeの型がNumber以外
# class VolumeTypeIsNotNumberError extends OhlcError
#   constructor: (@item) ->
#     m = 'Volume type is not number.'
#     super(m)
#     @level = TYPES.ERROR
# # volumeの型がNumberだが負数
# class VolumeIsNegativeNumberError extends OhlcError
#   constructor: (@item) ->
#     m = 'volume is Negative Number.'
#     super(m)
#     @level = TYPES.ERROR
# # 四本値が不正
# class FourValuesAreInvalidError extends OhlcError
#   constructor: (@item) ->
#     m = 'Four values (ohlc) are invalid.'
#     super(m)
#     @level = TYPES.ERROR
# # 出来高zeroなのに四本値が異なる
# class FourValuesAreDifferentError extends OhlcError
#   constructor: (@item) ->
#     m = 'Volume is zero, but the four values are different
# '
#     super(m)
#     @level = TYPES.ERROR

class Errors
  constructor: () ->
    @items = []
    @length = @items.length
  add: (item, index,messageNumber)=>
    message = messages[messageNumber or 0]
    @items.push {
      item: item
      original: @org.find (orgItem)->
        moment(orgItem[0]).valueOf() is moment(item.Date).valueOf()
      level: message[0]
      index: index
      errid: messageNumber
      msg: message[2]
      msg_jp: message[1]
    }
    @length = @items.length
    return @
  # compact: ->
  #   items = _.groupBy(@items,'errid')
  #   console.log Object.keys(items)
  #   @items = Object.keys(items).map (id)->items[id][0]
  #   @length = @items.length
  #   return @
  log:(compact=true) ->
    if compact
      items = _.groupBy(@items,'errid')
      items = Object.keys(items).map (id)-> items[id][0]
    else
      items = @items
    items.forEach (item)-> console.error item
  out: ->
    return @items
# class Errors extends Array
#   constructor: () ->
#     super()
#   add: (item, index,messageNumber)=>
#     message = messages[messageNumber or 0]
#     @push {
#       item: item
#       level: message[0]
#       index: index
#       msg: message[2]
#       msg_jp: message[1]
#     }
#     return
  #TODO: log: (opts)->



module.exports = Errors
