Big = require('big.js')
_ = require 'lodash'

module.exports = calc =
  sum:(arr)->
    initialValue = Big(0)
    reducer = (result, current, i, arr)->
      return result.plus(current)
    res = arr.reduce(reducer, initialValue)
    return parseFloat(res)
  sumBy:(arr,key)->
    newArr = _.map(arr,key)
    return calc.sum(newArr)
  mean:(arr)->
    sum = calc.sum(arr)
    res = Big(sum).div(arr.length)
    return parseFloat(res)
  meanBy: (arr, key)->
    newArr = _.map(arr,key)
    return calc.mean(newArr)
  changeIn: (base,target)->
    res = Big(target).minus(base).div(base).times(100).round(2)
    return parseFloat(res)
  addSma: (range,items) ->
    key = "sma#{range}"
    d_key = "smad#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
        item[d_key] = null
      else
        refItems = arr[i-(range-1)..i]
        sma = calc.meanBy(refItems,'Close')
        item[key] = sma
        item[d_key] = calc.changeIn(item.Close,sma)
    return items
  _addSma: (range,items,round) ->
    key = "sma#{range}"
    d_key = "smad#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
        item[d_key] = null
      else
        refItems = arr[i-(range-1)..i]
        sma = round _.meanBy(refItems,'Close')
        item[key] = sma
        item[d_key] = _.round (((item.Close - sma)/sma) *100), 2
    return items