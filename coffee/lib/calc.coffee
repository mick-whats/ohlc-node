Big = require('../node_modules/big.js/big.min.js')
_ = require '../node_modules/lodash/lodash.min.js'


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
  addSma: (range,items,roundNumber) ->
    roundNumber = roundNumber or 0
    key = "sma#{range}"
    d_key = "smad#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
        item[d_key] = null
      else
        refItems = arr[i-(range-1)..i]
        sma = calc.meanBy(refItems,'Close')
        item[key] = parseFloat Big(sma).round(roundNumber)
        item[d_key] = calc.changeIn(sma,item.Close)
    return items
  addVwma: (range,items,roundNumber) ->
    roundNumber = roundNumber or 0
    key = "vwma#{range}"
    d_key = "vwmad#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
        item[d_key] = null
      else
        refItems = arr[i-(range-1)..i]
        sumPrice = calc.sumBy refItems, (o)-> o.Close * o.Volume
        sumVolume = calc.sumBy(refItems,'Volume')
        vwma = Big(sumPrice).div(sumVolume)
        item[key] = parseFloat vwma.round(roundNumber)
        item[d_key] = calc.changeIn(parseFloat(vwma),item.Close)
    return items
