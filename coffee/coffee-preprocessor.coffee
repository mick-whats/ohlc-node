coffee = require('coffeescript')
module.exports = process: (src, path) ->
  if coffee.helpers.isCoffee(path)
    # return coffee.compile(src, bare: true)
    res = coffee.compile(src, {bare: true,sourceMap: true})
    return {
      code: res.js
      map: res.sourceMap
    }
  return src