# LBF

* Created by Alexander Celeste, [alex@tenseg.net](mailto:alex@tenseg.net)
* February 2020
* Version 2

The `lbf.fish` script can be called while in a folder that is part of a [**Local**](https://localwp.com) site to run any `local-cli` command using that site's ID.

## Requirements

* [Local](https://localwp.com) version 5.9.2 or newer
* [Fish](https://fishshell.com) installed via [Homebrew](https://brew.sh)
* PHP in your path, you can install it with Homebrew
* [local-cli](https://www.npmjs.com/package/@getflywheel/local-cli) in your path
## Usage

First link `ln -s` the `lbf.fish` script to `lbf` in the folder above this repo, which is intended to be somewhere that is in your shell's PATH to make it easier to run. You will also need to `chmod +x` the symlink to get it to run in the command line. Then simply use `lbf` to run anything that you'd run with `local-cli`.

`lbf-container.php` takes input of two paths (if called from `lbf.fish` this will be the current working directory and your home directory) and returns the info asked for in the third argument from the first path passed in. It finds the requested data by parsing Local's own `sites.json` file that lives within your user's library (hence why it needs your home directory). This script is really designed only to be run from `lbf.fish`. I wrote this part in PHP because I was more comfortable parsing JSON in PHP than Fish.

Along with passing through commands to `local-cli`, this script also adds the following:

* `restart` will restart a site
* `open` will open the site in your default browser
## VS Code Tasks

You can configure VS Code to [run these commands](https://code.visualstudio.com/docs/editor/tasks) using the `tasks.json` file in `.vscode` or a Workspace (which the below example is of). This can enable easy access to controlling a Local from its associated VS Code environment.

```json
"tasks": {
	"version": "2.0.0",
	"tasks": [
		{
			"label": "Start Site",
			"group": "none",
			"type": "shell",
			"runOptions": {
				"runOn": "folderOpen"
			},
			"command": "lbf start-site",
			"presentation": {
				"reveal": "never",
				"focus": false,
				"echo": true,
				"panel": "dedicated",
				"clear": false,
				"group": "server"
			},
			"problemMatcher": []
		}
	]
},
```

## Feedback

Any feedback is welcome. Feel free to email me or submit issues on the [Bitbucket repository](https://bitbucket.org/alexclst/lbf-container).

## Version 1

This project started out life with classic Local as a way to drop into the Docker container's shell. Since version 5, that is no longer needed, but now that `local-cli` is around the same underlying script can be used to simplify running those commands without needing to pass a site ID. The old version can still be seen in Git commit history. The script still uses *lbf* as a shorter command name, and tribute to the original name **Local by Flywheel**.