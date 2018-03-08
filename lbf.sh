#!/bin/bash
# LBF Container
# Created by Alexander Celeste, alex@tenseg.net
# March 2018
# 
# Run this script from a folder that is a 
# Local by Flywheel site and it will drop you 
# into the bash prompt in the Docker container 
# of the site.

# figure out where we are
# see https://stackoverflow.com/a/246128/383737
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# find the container
container="$(php $DIR/lbf-container.php "$(/bin/pwd)" $HOME)"
if [ -z "$container" ]; then
	echo "Not a Local by Flywheel site folder."
else
	# launch bash in the container
	eval $(/Applications/Local\ by\ Flywheel.app/Contents/Resources/extraResources/virtual-machine/vendor/docker/osx/docker-machine env local-by-flywheel)
	/Applications/Local\ by\ Flywheel.app/Contents/Resources/extraResources/virtual-machine/vendor/docker/osx/docker exec -it $container /bin/bash
fi