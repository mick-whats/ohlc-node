require('source-map-support').install()
_ = require('lodash')
moment = require 'moment'
{test} = require 'ava'
errors = require '../lib/errors'

test.skip 'errors', (t) ->
  t.deepEqual new errors.VolumeTypeIsNotNumberError({foo: 'bar'}),{}
