_ = require '../../node_modules/lodash/lodash.min.js'
moment = require '../../node_modules/moment/min/moment.min.js'

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
    @items = _.sortBy @items,(item)-> moment(item.Date).unix()
    @opts = {}
    @opts.round = (val)-> _.round(val)
    return
  round: (fn)->
    if _.isFunction(fn)
      @opts.round = fn
      return @
    else
      num = Number(fn)
      if _.isNaN(num)
        return @
      else
        @opts.round = (val)-> _.round(val,num)
        return @
  start: (date)->
    @opts.startDate = date
    @
  end: (date)->
    @opts.endDate = date
    @
  sma: (range...) ->
    @opts.smas = range
    @
  _addSma = (range,items,round) ->
    key = "sma#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
      else
        refItems = arr[i-(range-1)..i]
        item[key] = round _.meanBy(refItems,'Close')
    return items

  vwma: (range...) ->
    @opts.vwmas = range
    @
  _addVwma = (range,items,round) ->
    key = "vwma#{range}"
    items.forEach (item,i,arr)->
      if i < range - 1
        item[key] = null
      else
        refItems = arr[i-(range-1)..i]
        sumPrice = _.sumBy refItems, (o)-> o.Close * o.Volume
        sumVolume = _.sumBy(refItems,'Volume')
        item[key] = round(sumPrice/sumVolume)
    return items

  _convertingPeriodBy = (period,items,opts)->
    opts = opts or {}
    round = opts.round
    items = switch on
      when /^mo/.test(period)
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
      when /^we/.test(period)
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
      else
        items
    if opts.smas
      opts.smas.forEach (range)->
        _addSma(range,items,opts.round)
    if opts.vwmas
      opts.vwmas.forEach (range)->
        _addVwma(range,items,opts.round)
    if opts.startDate or opts.endDate
      start = opts.startDate or items[0].Date
      end = opts.endDate or _.last(items).Date
      items = _.reject items, (item)->
        return moment(item.Date).isBefore(start) or moment(item.Date).isAfter(end)
    return items
  toDaily: ->
    return _convertingPeriodBy('',@items,@opts)
  toWeekly: ->
    return _convertingPeriodBy('weekly',@items,@opts)
  toMonthly: ->
    _convertingPeriodBy('monthly',@items,@opts)
  value: (period)->
    _convertingPeriodBy(period, @items,@opts)
  toChartData: (period)->
    obj = {}
    items = _convertingPeriodBy(period,@items,@opts)
    obj.candle = items.map (item)->
      [
        moment.utc(item.Date).valueOf()
        item.Open
        item.High
        item.Low
        item.Close
      ]
    obj.volume = items.map (item)->
      [
        moment.utc(item.Date).valueOf()
        item.Volume
      ]
    otherItems = _.difference Object.keys(items[0]),
      ['Date','Open','High','Low','Close','Volume']
    otherItems.forEach (name)->
      obj[name] = items.map (item)->
        [
          moment.utc(item.Date).valueOf()
          item[name]
        ]
    return obj
        
module.exports = (data)-> new Ohlc(data)
