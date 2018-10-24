_ = require '../node_modules/lodash/lodash.min.js'

module.exports = modify =
  zero: ->
    items = []
    refClose = null
    @items.forEach (item)->
      if refClose and item.Volume is 0
        newItem = _.cloneDeep(item)
        newItem.Open = refClose
        newItem.High = refClose
        newItem.Low = refClose
        newItem.Close = refClose
        items.push(newItem)
        return
      else
        refClose = item.Close
        items.push(item)
        return
    @items = items
    @
  all: ->
    modify.zero.call(@)
    @