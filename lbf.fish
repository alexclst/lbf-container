#!/usr/bin/env fish

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

# ensure that Local is running before we attempt to do anything with it
begin
    pgrep Local
end &>/dev/null
if test $status = 1 # Local isn't running
    open -g /Applications/Local.app/
    sleep 5
    osascript -e 'tell application "System Events" to set visible of process "Local" to false'
end

# see if we wanted to list sites
if test $argv[1] = 'list-sites'
    local-cli list-sites
    exit
end

# get site id from container script
set SCRIPT_PATH (status --current-filename)
set SITE_ID (php  $SCRIPT_PATH-container/lbf-container.php $PWD $HOME "id")

# all functions only make sense within Local site folders
if test -z "$SITE_ID"
    echo "This is not a Local site's folder."
    exit
end

# check for custom restart command
# TODO: remove once local-cli introduces this
if test $argv[1] = 'restart'
    local-cli 'stop-site' $SITE_ID
    local-cli 'start-site' $SITE_ID
    exit
end

# see if we were asked to launch the site
# TODO: remove once local-cli introduces this
if test $argv[1] = 'open'
    set SITE_URL (php  $SCRIPT_PATH-container/lbf-container.php $PWD $HOME "domain")
    open "http://$SITE_URL"
    exit
end

# return the url of the site (note, always returns http)
if test $argv[1] = 'url'
    echo "http://"(php  $SCRIPT_PATH-container/lbf-container.php $PWD $HOME "domain")
    exit
end

# keep a dying site alive
if test $argv[1] = 'keepalive'
    set SITE_URL "http://"(php  $SCRIPT_PATH-container/lbf-container.php $PWD $HOME "domain")
    while true
        curl -I --silent $SITE_URL >.tg-site-keepalive &
        sleep 3
        if test -s .tg-site-keepalive
            rm .tg-site-keepalive
            echo -ne '\r'(date)'                         '
            sleep 10
        else
            kill $last_pid
            echo -e "\r----------- "(date)" -----------"
            local-cli 'stop-site' $SITE_ID
            local-cli 'start-site' $SITE_ID
        end
    end
    exit
end

# run the specified local-cli command with the found site id
local-cli $argv[1] $SITE_ID