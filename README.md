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

## constructor

```
var prices;
prices = new ohlc(arrayData);
```

## toDays()

```
var d1, days, prices;
prices = new ohlc(arrayData);
days = prices.toDays();
d1 = days.find(function(item) {
  return item.Date === '2017-04-03';
});
/// d1  
{
  "Date": '2017-04-03',
  Open: 352,
  High: 352,
  Low: 348,
  Close: 348,
  Volume: 108200
}
```

## toWeeks()

```
var prices, w1, weeks;
prices = new ohlc(arrayData);
weeks = prices.toWeeks();
w1 = weeks.find(function(item) {
  return item.Date === '2017-04-02';
});

/// w1
{
  "Date": '2017-04-02',
  Open: 352,
  High: 352,
  Low: 338,
  Close: 339,
  Volume: 379400
}
```

## toMonths

```
var m1, months, prices;
prices = new ohlc(arrayData);
months = prices.toMonths();
m1 = months.find(function(item) {
  return item.Date === '2017-04-01';
});
/// m1
{
  "Date": '2017-04-01',
  Open: 352,
  High: 370,
  Low: 330,
  Close: 357,
  Volume: 1514900
}
```