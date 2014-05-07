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
$ apm install Theos-Build-Manager
```

Or, search for "Theos Build Manager" in the Packages section in Atom's Settings,
and click Install.

## Default keybindings

* Build:  `cmd-alt-b`
* Run:    `cmd-alt-shift-b`
* Clean:  `cmd-shift-k`
* Cancel Build: `cmd-alt-shift-c`

## Commands Run

* Build: `make -j -e DEBUG=1`
* Run: `make -j -e DEBUG=1 package install`
* Clean: `make clean`
