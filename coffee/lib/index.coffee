_ = require '../node_modules/lodash/lodash.min.js'
moment = require '../node_modules/moment/min/moment.min.js'
objelity = require('objelity')
calc = require('./calc')
util = require './util'
OUTPUT_DATE_FORMAT = 'YYYY-MM-DD'
PROP_NAMES =
  inputDateFormat: 'inputDateFormat'
class Ohlc
  _parseNumber = (str)->
    if _.isString(str)
      str = str.split(',').join('').trim()
    return parseFloat(str)
  momentOrThrow = (date,opts)->
    inputDateFormat = opts[PROP_NAMES.inputDateFormat]
    m = moment(date,inputDateFormat)
    if m.isValid()
      return m
    else
      throw new TypeError("invalid date: #{date}")

  constructor: (items,_opts) ->
    if _opts and _.isPlainObject(_opts)
      @opts = objelity.mapObject _opts,(val,path)->
        if /^inputDateFormat$/i.test(path)
          return [PROP_NAMES.inputDateFormat, val]
        else
          return [path,val]
    else
      @opts = {}
    if _.isPlainObject items
      if _.get(items,'dataset.data',null)
        items = items.dataset.data
      else if _.get(items,'data',null)
        items = items.data
      else
        throw new Error('inconsistent datatypes: expected Array got Object.')
    @org = items
    @items = items.map (item)=>
      if Array.isArray(item)
        return {
          "Date": momentOrThrow(item[0],@opts).format(OUTPUT_DATE_FORMAT)
          # "Date": moment(item[0]).format(OUTPUT_DATE_FORMAT)
          Open:  _parseNumber.call @, item[1]
          High:  _parseNumber.call @, item[2]
          Low:   _parseNumber.call @, item[3]
          Close: _parseNumber.call @, item[4]
          Volume:_parseNumber item[5]
        }
      else if _.isPlainObject(item)
        return objelity.mapObject item, (val, path)=>
          _path = path
          _val  = _parseNumber(val)
          if path.match(/date/i)
            _path = 'Date'
            _val =  momentOrThrow(val,@opts).format(OUTPUT_DATE_FORMAT)
          else if path.match(/open/i)
            _path = 'Open'
          else if path.match(/high/i)
            _path = 'High'
          else if path.match(/low/i)
            _path = 'Low'
          else if path.match(/close/i)
            _path = 'Close'
          else if path.match(/volume/i)
            _path = 'Volume'
          return [_path, _val]
      else
        throw new Error('inconsistent datatypes')
    @items = _.sortBy @items,(item)-> moment(item.Date).unix()
    
    @opts.round = do=>
      min = _.minBy(@items,'Low').Low
      return util.decimalPlace(min)
    return
  validate: ->
    require('./validate').call(@)
  
  modify: ->
    require('./modify').all.call(@)
  round: (num)->
    if _.isNumber(num)
      if Number.isNaN(num)
        return @
      else if num <= 0
        @opts.round = 0
        return @
      else
        @opts.round = num
        return @
    else
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
  vwma: (range...) ->
    @opts.vwmas = range
    @

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
            Volume: calc.sumBy(monthItems, 'Volume')
          }
      when /^we/.test(period)
        groups = _.groupBy items, (item)-> moment(item.Date).format('gggg-ww')
        Object.keys(groups).map (_week)->
          weekItems = groups[_week]
          weekItems = _.sortBy weekItems, (item)-> moment(item.Date).unix()
          _m = moment(weekItems[0].Date)
          _weekDay = _m.format('d')
          {
            "Date": _m.subtract(_weekDay,'days').format(OUTPUT_DATE_FORMAT)
            Open: weekItems[0].Open
            Close: _.last(weekItems).Close
            High: _.maxBy(weekItems,'High').High
            Low: _.minBy(weekItems,'Low').Low
            Volume: calc.sumBy(weekItems, 'Volume')
          }
      else
        items
    if opts.smas
      opts.smas.forEach (range)->
        calc.addSma(range,items,opts.round)
        # calc.addSma(range,items,(val)->_.round(val,opts.round))
    if opts.vwmas
      opts.vwmas.forEach (range)->
        calc.addVwma(range,items,opts.round)
        # _addVwma(range,items,(val)->_.round(val,opts.round))
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
        

module.exports = (data,opts)-> new Ohlc(data,opts)
