coffee = require('coffeescript')

test 'coffee', () ->
  expect coffee.compile('console.log hoge', bare: true)
  .toBe 'console.log(hoge);\n'
