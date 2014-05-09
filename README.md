# Theos Build Manager

Build your Theos projects through Atom.

It should go without saying, but you should have Theos already installed and
functioning if Atom Theos Build Manager is to work properly.
[Guide here](http://iphonedevwiki.net/index.php/Theos/Getting_Started)

After installing, please make sure to go into Settings to set `THEOS_DEVICE_IP`
and `THEOS_DEVICE_PORT`.

## Installing

Using `apm`:
```
$ apm install theos-build-manager
```

Or, search for "Theos Build Manager" in the Packages section in Atom's Settings,
and click Install.

## Default keybindings

Action              | Keymap
--------------------|-----------------------
Build               | `cmd-alt-b`
Run                 | `cmd-alt-shift-b`
Clean               | `cmd-alt-k`
Cancel Build        | `cmd-alt-c`
Close Output Window | `cmd-alt-x`

## Configurable options

Option            | Description
------------------|-------------------------
Theos Root Path   | The path to your installation of Theos. Defaults to `/opt/theos`.
Theos Device IP   | The IP address to use when installing via SSH. Must be set to be able to run your tweak on-device.
Theos Device Port | The port number to use when installing via SSH. Defaults to `22`.
Use Debug Flag    | Whether or not to define `DEBUG=1` when compiling.
