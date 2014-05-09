{View,BufferedProcess,$$,$} = require 'atom'
HeaderView = require './header-view'
AnsiFilter = require 'ansi-to-html'
_ = require 'underscore-plus'

save_all = ->
	editors = atom.workspace.getEditors()
	for editor in editors
		if editor.buffer.isModified()
			console.log 'save'
			editor.buffer.save()

module.exports =
class TheosOutputView extends View
	@bufferedProcess: null

	@content: ->
		@div =>
			@subview 'headerView', new HeaderView()

			css = 'tool-panel panel panel-bottom padding theos-output-view native-key-bindings'
			@div class: css, outlet: 'script', tabindex: -1, =>
				@div class: 'panel-body padded output', outlet: 'output'

	initialize: (serializeState) ->
		atom.workspaceView.command "theos-manager:build",      => @build()
		atom.workspaceView.command "theos-manager:clean",      => @clean()
		atom.workspaceView.command "theos-manager:run_latest", => @run_latest()
		atom.workspaceView.command "theos-manager:run",        => @run()
		atom.workspaceView.command "theos-manager:cancel",     => @stop()
		atom.workspaceView.command 'theos-manager:close-view', => @close()

		@ansiFilter = new AnsiFilter

	serialize: ->

	resetView: (title = 'Loading...') ->
		atom.workspaceView.prependToBottom this unless @hasParent()

		@stop()

		@headerView.title.text title
		@headerView.title.command ''
		@headerView.setStatus 'start'

		@output.empty()


	start: ->
		editor = atom.workspace.getActiveEditor()

		return unless editor?

		@resetView()

	close: ->
		@detach() if @hasParent()

	run_command: (cmd, statusWindowTitle) ->
		console.log cmd
		@start()
		@headerView.title.text statusWindowTitle
		@headerView.command.text cmd

		cmd = cmd.split(' ')

		command = cmd.shift()
		args    = cmd

		# Set up Theos variables
		theos             = atom.config.get('theos-build-manager.theosRootPath')   or atom.config.getDefault 'theos-build-manager.theosRootPath'
		theos_device_port = atom.config.get('theos-build-manager.theosDevicePort') or atom.config.getDefault 'theos-build-manager.theosDevicePort'
		theos_device_ip   = atom.config.get('theos-build-manager.theosDeviceIp')?.trim()

		# Don't run anything if the user hasn't set up THEOS_DEVICE_IP
		if not theos_device_ip?.length
			atom.beep()
			@output.append $$ ->
				@h1 'Setup required'
				@p 'Please specify THEOS_DEVICE_IP in your Atom config.'
			@headerView.setStatus 'err'
			return

		# Set up some environment variables
		options = {
			cwd: atom.project.path
			env: {
				PATH              : "#{theos}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
				THEOS             : theos
				THEOS_DEVICE_IP   : theos_device_ip
				THEOS_DEVICE_PORT : theos_device_port
			}
		}

		stdout = (output) => @display 'stdout', output
		stderr = (output) => @display 'stderr', output
		exit   = (code) =>
			if code is 0
				@headerView.setStatus 'stop'
			else
				@headerView.setStatus 'err'
			atom.beep()
			console.log("Build finished with exit code #{code}")

		@bufferedProcess = new BufferedProcess({command, args, options, stdout, stderr, exit})

		return options

	stop: ->
		if @bufferedProcess? and @bufferedProcess.process?
			@display 'stdout', '^C'
			@headerView.setStatus 'kill'
			@bufferedProcess.kill()

	# TODO: Automatically scroll output window
	display: (css, line) ->
		line = _.escape(line)
		line = @ansiFilter.toHtml(line)

		@output.append $$ ->
			@pre class: "line #{css}", =>
				@raw line

		@script.scrollToBottom()

	# Theos Manager Actions
	build: ->
		save_all()
		@run_command 'make -j -e DEBUG=1', 'Build'

	run: ->
		save_all()
		@run_command 'make -j -e DEBUG=1 package install', 'Run'

	run_latest: ->
		@run_command 'make -j -e DEBUG=1 install', 'Run Latest'

	clean: ->
		@run_command 'make clean', 'Clean'
