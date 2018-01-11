import config from 'config'
import cukeHelprSteps from '../../../src'
import constants from '../../constants'

export default cukeHelprSteps({constants, ...config})
