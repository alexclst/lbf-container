#!/usr/bin/env fish

# see if we were called naked
if [ -z "$argv[1]" ]
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

# get site from Local's sites.json file
set JQCMD (echo '.[] | select( .path as $jqpath | "'$PWD'" | startswith($jqpath))')
set SITE_JSON (jq $JQCMD ~/Library/Application\ Support/Local/sites.json)

# all remaining functions only make sense within Local site folders
# if not in a site folder the site json will be enpty
if [ -z "$SITE_JSON" ]
    echo "This is not a Local site's folder."
    exit
end

# now that we know we have a single site get that site's id
set SITE_ID (echo $SITE_JSON | jq -r '.id')

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
    set HOSTNAME (echo $SITE_JSON | jq -r '.domain')
    open "http://$HOSTNAME"
    exit
end

# return the url of the site (note, always returns http)
if test $argv[1] = 'url'
    set HOSTNAME (echo $SITE_JSON | jq -r '.domain')
    echo "http://$HOSTNAME"
    exit
end

# keep a dying site alive
if test $argv[1] = 'keepalive'
    set HOSTNAME (echo $SITE_JSON | jq -r '.domain')
    set SITE_URL "http://"$HOSTNAME
    set KEEPALIVE ~/.tg-site-keepalive-$HOSTNAME
    while true
        curl -I --silent $SITE_URL >$KEEPALIVE &
        sleep 3
        if test -s $KEEPALIVE
            rm $KEEPALIVE
            echo -ne '\r'(date)'                         '
            sleep 10
        else
            echo -e "\r----------- "(date)" -----------"
            local-cli 'stop-site' $SITE_ID
            local-cli 'start-site' $SITE_ID
        end
    end
    exit
end

# run the specified local-cli command with the found site id
local-cli $argv[1] $SITE_ID