module.exports =
  verbose: true
  transform:
    "^.+\\.coffee$": "<rootDir>/coffee-preprocessor.js"
  
  testMatch:[
    "**/spec/**/*.coffee"
  ]
  moduleFileExtensions: [
    "js",
    "jsx",
    "json",
    "coffee"
  ]
  watchPathIgnorePatterns: [
    "<rootDir>/node_modules/"
  ]
  collectCoverage: false