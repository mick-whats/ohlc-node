merge = require('webpack-merge')
baseConfig = require('./webpack.config.base.js')

module.exports = merge baseConfig,{
  mode: 'production'
  }