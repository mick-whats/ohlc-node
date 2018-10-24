path = require('path')
module.exports =
  context: path.resolve(__dirname, 'lib/'),
  entry: ['babel-polyfill', './index.js'],
  output:
    filename: 'ohlc.js'
    path: path.join(__dirname, 'dist')
    library: 'ohlc'
    libraryTarget: 'umd'
    globalObject  : 'this'
  resolve:
    extensions: ['.js']
  module: rules: [ {
    test: /\.*js$/
    exclude: /(node_modules|bower_components)/
    use:
      loader: 'babel-loader'
      options:
        presets: ['@babel/preset-env']
  }
  ]