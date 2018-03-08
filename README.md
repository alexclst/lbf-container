# LBF Container

* Created by Alexander Celeste, [alex@tenseg.net](mailto:alex@tenseg.net)
* March 2018

The `lbf.sh` script can be called while in a folder that is part of a [**Local by Flywheel**](https://local.getflywheel.com) site to drop you into the Bash prompt of the site. This is much more convenient than digging around for Local's window when working in software like VS Code that has an integrated terminal and you just want to do something quickly on the bash prompt of the site.

## Usage

Simply run the `lbf.sh` shell script from your Local site's folder. The script passes your current working directory and home directory to `lbf-container.php`, which returns the Docker container ID. The shell script uses the Docker container ID to run the same set of commands that the *Open Site SSH* command in Local runs to place you at the bash prompt of your Local site's Docker container.

You may want to `ln -s` the `lbf.sh` script to `lbf` somewhere that is in your shell's PATH to make it easier to run. You will also need to `chmod a+x` the symlink to get it to run in the command line.

`lbf-container.php` takes input of two paths (if called from `lbf.sh` this will be the current working directory and your home directory) and returns the Docker container ID associated with the first path passed in. It finds the container ID by parsing Local's own `sites.json` file that lives within your user's library (hence why it needs your home directory). This script is really designed only to be run from `lbf.sh`. I wrote this part in PHP because I was more comfortable parsing JSON in PHP than Bash.

## Feedback

Any feedback is welcome. Feel free to email me or submit issues on the [Bitbucket repository](https://bitbucket.org/alexclst/lbf-container).