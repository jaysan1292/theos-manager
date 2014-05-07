{BufferedProcess} = require 'atom'

current_process = null

run_command = (cmd) ->
	console.log cmd

	cmd = cmd.split(' ')

	command = cmd.shift()
	args    = cmd

	# Set up Theos variables
	theos             = atom.config.get('theos-manager.theosRootPath')   or atom.config.getDefault 'theos-manager.theosRootPath'
	theos_device_port = atom.config.get('theos-manager.theosDevicePort') or atom.config.getDefault 'theos-manager.theosDevicePort'
	theos_device_ip   = atom.config.get('theos-manager.theosDeviceIp').trim()

	# Don't run anything if the user hasn't set up THEOS_DEVICE_IP
	if not theos_device_ip?.length
		console.error 'Please specify THEOS_DEVICE_IP in your environment OR in your Atom config.'
		atom.beep()
		return

	# Set up some environment variables
	options = {
		cwd: atom.project.path
		env: {
			PATH              : theos+'/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin'
			THEOS             : theos
			THEOS_DEVICE_IP   : theos_device_ip
			THEOS_DEVICE_PORT : theos_device_port
		}
	}

	# TODO: Show console output window instead of outputting to console.log
	stdout = (output) ->
		console.log output

	stderr = (output) ->
		console.error output

	exit = (code) ->
		atom.beep()
		console.log("Build finished with exit code #{code}")

	current_process = new BufferedProcess({command, args, options, stdout, stderr, exit})

save_all = () ->
	for editor in atom.workspace.getEditors()
		editor.save()

module.exports =
	configDefaults:
		theosRootPath: '/opt/theos'
		theosDeviceIp: ''
		theosDevicePort: 22

	activate: ->
		atom.workspaceView.command "theos-manager:build",      => @build()
		atom.workspaceView.command "theos-manager:cancel",     => @cancel()
		atom.workspaceView.command "theos-manager:clean",      => @clean()
		atom.workspaceView.command "theos-manager:run_latest", => @run_latest()
		atom.workspaceView.command "theos-manager:run",        => @run()

	build: ->
		save_all()
		run_command 'make -j -e DEBUG=1'

	run: ->
		save_all()
		run_command 'make -j -e DEBUG=1 package install'

	run_latest: ->
		run_command 'make -j -e DEBUG=1 install'

	clean: ->
		run_command 'make clean'

	cancel: ->
		if current_process?
			current_process.kill()
			current_process = null
