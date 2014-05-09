TheosOutputView = require './theos-output-view'

module.exports =
	outputView: null

	configDefaults:
		theosRootPath: '/opt/theos'
		theosDeviceIp: ''
		theosDevicePort: 22
		useDebugFlag: true

	activate: (state) ->
		@outputView = new TheosOutputView state.outputViewState

	deactivate: ->
		@outputView.close()

	serialize: ->
		outputViewState: @outputView.serialize()
