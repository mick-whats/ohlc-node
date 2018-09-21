_ = require 'lodash'
moment = require 'moment'

DATE_FORMAT = 'YYYY-MM-DD'

class Ohlc
  constructor: (items) ->
    @items = items.map (item)->
      if Array.isArray(item)
        return {
          "Date": moment(item[0]).format(DATE_FORMAT)
          Open:  item[1]
          High:  item[2]
          Low:   item[3]
          Close: item[4]
          Volume:item[5]
        }
      else if _.isPlainObject(item)
        d = item.Date or item.date or item.DateTime or item.dateTime
        return {
          "Date": moment(d).format(DATE_FORMAT)
          Open:  item.Open or item.open
          High:  item.High or item.high
          Low:   item.Low or item.low
          Close: item.Close or item.close
          Volume:item.Volume or item.volume
        }
      else
        throw new Error('ArrayType Or ObjectType Required')

  addSma: (range) ->
    key = "sma#{range}"
    @items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
      else
        refItems = arr[i-(range-1)..i]
        item[key] = _.round _.meanBy(refItems,'Close')
  
  toDays: ->
    return _.cloneDeep(@items)
  toWeeks: ->
    items = _.cloneDeep(@items)
    groups = _.groupBy items, (item)-> moment(item.Date).format('gggg-ww')
    Object.keys(groups).map (_week)->
      weekItems = groups[_week]
      weekItems = _.sortBy weekItems, (item)-> moment(item.Date).unix()
      _m = moment(weekItems[0].Date)
      _weekDay = _m.format('d')
      {
        "Date": _m.subtract(_weekDay,'days').format(DATE_FORMAT)
        Open: weekItems[0].Open
        Close: _.last(weekItems).Close
        High: _.maxBy(weekItems,'High').High
        Low: _.minBy(weekItems,'Low').Low
        Volume: _.sumBy(weekItems, 'Volume')
      }
    
  toMonths: ->
    items = _.cloneDeep(@items)
    groups = _.groupBy items, (item)-> moment(item.Date).format('YYYY-MM')
    Object.keys(groups).map (_month)->
      monthItems = groups[_month]
      monthItems = _.sortBy monthItems, (item)-> moment(item.Date).unix()
      {
        "Date": moment(monthItems[0].Date).format('YYYY-MM-01')
        Open: monthItems[0].Open
        Close: _.last(monthItems).Close
        High: _.maxBy(monthItems,'High').High
        Low: _.minBy(monthItems,'Low').Low
        Volume: _.sumBy(monthItems, 'Volume')
      }
    
module.exports = Ohlc
