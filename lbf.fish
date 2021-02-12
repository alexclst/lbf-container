#!/opt/homebrew/bin/fish

# see if we were called naked
if test -z "$argv[1]"
	local-cli
	exit
end

# see if we wanted help
if test $argv[1] = 'help'
	local-cli help
	exit
end

# get site id from old container script
set SITE_ID (php  ~/bin/lbf-container/lbf-container.php $PWD $HOME)

# all functions only make sense within Local site folders
if test -z "$SITE_ID"
	echo "This is not a Local site's folder."
	exit
end

# ensure that Local is running before we attempt to do anything with it
begin
	pgrep Local
end &> /dev/null
if test $status = 1 # Local isn't running
	open -g /Applications/Local.app/
	sleep 5
	osascript -e 'tell application "System Events" to set visible of process "Local" to false'
end

# check for custom restart command
# TODO: remove once local-cli introduces this
if test $argv[1] = 'restart'
	local-cli 'stop-site' $SITE_ID
	local-cli 'start-site' $SITE_ID
	exit
end

# run the specified local-cli command with the found site id
local-cli $argv[1] $SITE_ID