# LBF

* Created by Alexander Celeste, [alex@tenseg.net](mailto:alex@tenseg.net)
* February 2020
* Version 2

The `lbf.fish` script can be called while in a folder that is part of a [**Local**](https://local.getflywheel.com) site to run any `local-cli` command using that site's ID.

## Requirements

* [Local](https://localwp.com) version 5.9.2 or newer
* [Fish](https://fishshell.com) installed via [Homebrew](https://brew.sh), you may need to modify the shebang if you're on an Intel Mac
* PHP in your path, you can install it with Homebrew
* [local-cli](https://www.npmjs.com/package/@getflywheel/local-cli) in your path
## Usage

Simply run the `lbf.fish` shell script from your Local site's folder. The script passes your current working directory and home directory to `lbf-container.php`, which returns the Site ID. The shell script uses the Site ID to run the passed command with `local-cli`.

You may want to `ln -s` the `lbf.fish` script to `lbf` somewhere that is in your shell's PATH to make it easier to run. You will also need to `chmod +x` the symlink to get it to run in the command line.

`lbf-container.php` takes input of two paths (if called from `lbf.sh` this will be the current working directory and your home directory) and returns the Docker container ID associated with the first path passed in. It finds the Site ID by parsing Local's own `sites.json` file that lives within your user's library (hence why it needs your home directory). This script is really designed only to be run from `lbf.fish`. I wrote this part in PHP because I was more comfortable parsing JSON in PHP than Bash.

If you use a different shell, you can still use the Fish script as a guide for how to write a script for the shell you prefer.

## Feedback

Any feedback is welcome. Feel free to email me or submit issues on the [Bitbucket repository](https://bitbucket.org/alexclst/lbf-container).

## Version 1

This project started out life with classic Local as a way to drop into the Docker container's shell. Since version 5, that is no longer needed, but now that `local-cli` is around the same underlying script can be used to simplify running those commands without needing to pass a site ID. The old version can still be seen in Git commit history. The script still uses *lbf* as a shorter command name, and tribute to the original name **Local**.