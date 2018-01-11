import debug from '@watchmen/debug'
import {initState} from '@watchmen/test-helpr'
import {defineSupportCode} from 'cucumber'
/* eslint-disable new-capp */

const dbg = debug(__filename)

// eslint-disable-next-line no-unused-expressions
require('../../server').default

defineSupportCode(function({Before}) {
  Before(function() {
    try {
      dbg('before: this=%j', this)
      initState()
    } catch (err) {
      dbg('before: caught=%o', err)
      throw err
    }
  })
})
