Big = require('big.js')
_ = require 'lodash'

module.exports = util =
  decimalPlace: (num)->
    if not _.isNumber(num)
      return 0
    else if _.isNaN(num)
      return 0
    else
      arr = Big(num).abs().toString().split('.')
      if arr.length >= 2
        return arr[1].length
      else
        return 0