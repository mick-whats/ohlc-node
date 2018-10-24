_ = require '../node_modules/lodash/lodash.min.js'


module.exports = util =
  decimalPlace: (num)->
    if not _.isNumber(num)
      return 0
    else if Number.isNaN(num)
      return 0
    else
      str = num.toString()
      if str.includes('e-')
        arr = str.split('e-')
        m = parseFloat(arr[0])
        e = parseFloat(arr[1])
        md =  m.toString().split('.')
        me = if md.length is 1 then 0 else md[1].length
        return me + e
      else if str.includes('e+')
        arr = str.split('e+')#[1.23, 1]
        m = parseFloat(arr[0])# 1.23
        e = parseFloat(arr[1])# 1
        md =  m.toString().split('.')#[1,23]
        me = if md.length is 1 then 0 else md[1].length
        return if me - e <= 0 then 0 else me - e
      else
        arr = str.split('.')
        if arr.length >= 2
          return arr[1].length
        else
          return 0