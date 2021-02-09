#!/opt/homebrew/bin/fish

# get site id from old container script
set SITE_ID (php  ~/bin/lbf-container/lbf-container.php $PWD $HOME)

# return if no id was found
# all functions only make sense within Local site folders
if test -z "$SITE_ID"
	echo "This is not a Local site's folder."
	exit
end

# run the specified local-cli command with the found site id
local-cli $argv[1] $SITE_ID