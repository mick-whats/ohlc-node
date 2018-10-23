path = require('path')
module.exports =
  # mode: 'production'
  # mode: 'development'
  # devtool: 'source-map',
  entry: ['babel-polyfill', './lib/index.js'],
  output:
    filename: 'ohlc.js'
    path: path.join(__dirname, 'dist')
    library: 'ohlc'
    libraryTarget: 'umd'
    globalObject  : 'this'
  resolve:
    extensions: ['.js']
  module: rules: [ {
    test: /\.m?js$/
    exclude: /(node_modules|bower_components)/
    use:
      loader: 'babel-loader'
      options:
        presets: ['@babel/preset-env']
  }
  ]