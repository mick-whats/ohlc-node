module.exports =
  verbose: true
  # transform:
  #   "^.+\\.coffee$": "<rootDir>/coffee-preprocessor.js"
  collectCoverage: false
  testMatch:[
    "**/spec/**/*.js"
  ]
  moduleFileExtensions: [
    "js",
    "jsx",
    "json"
  ]
  watchPathIgnorePatterns: [
    "<rootDir>/node_modules/"
  ]
  # collectCoverage: false