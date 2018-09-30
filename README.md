# ohlc

## sumple data

```data.json
arrayData = [
 [
    "2017-01-04",
    348,
    350,
    346,
    350,
    68700
  ],
  [
    "2017-01-05",
    350,
    353,
    349,
    352,
    59200
  ],
  [
    "2017-01-06",
    350,
    358,
    350,
    356,
    168900
  ]
]
```


## toDaily()

output to daily data

```js
ohlc(arrayData).toDaily();
/// result 
[
  ...
  {
    "Date": '2017-04-03',
    Open: 352,
    High: 352,
    Low: 348,
    Close: 348,
    Volume: 108200
  }
  ...
]
```

## toWeekly()

output to weekly data
```js
ohlc(arrayData).toWeekly();
/// result 
[
  ...
  {
    "Date": '2017-04-02',
    Open: 352,
    High: 352,
    Low: 338,
    Close: 339,
    Volume: 379400
  }
  ...
]
```

## toMonthly

output to monthly data
```js
ohlc(arrayData).toMonthly();
/// result 
[
  ...
  {
    "Date": '2017-04-01',
    Open: 352,
    High: 370,
    Low: 330,
    Close: 357,
    Volume: 1514900
  }
  ...
]
```

## value(period)
output data

```js

// daily
ohlc(arrayData).value()
// equal toDaily
ohlc(arrayData).toDaily()

// weekly
ohlc(arrayData).value('weekly')
// equal toWeekly
ohlc(arrayData).toWeekly()

// monthly
ohlc(arrayData).value('monthly')
// equal toMonthly
ohlc(arrayData).toMonthly()

```

## start() and end()

Set the output period

```js
prices = ohlc(arrayData).toDaily();
/// prices.length is 101

prices = ohlc(arrayData).start('2017-04-03').toDaily();
/// prices.length is 40

prices = ohlc(arrayData).end('2017-04-10').toDaily();
/// prices.length is 67

prices = ohlc(arrayData).start('2017-04-03').end('2017-04-10').toDaily();
/// prices.length is 6
```


## sma

This will add sma(simple MA)

```js
ohlc(arrayData).sma(5, 25, 75).toDaily();
/// result
[
  ...
  {
    Date: '2017-05-31',
    Open: 372,
    High: 372,
    Low: 362,
    Close: 364,
    Volume: 46500,
    sma5: 373,
    sma25: 373,
    sma75: 360
  }
  ...
]
```
