#!/usr/bin/env bash

cd ~/

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb heroku/login
pb heroku

# are the required env vars declared?
if [ -n "$HMAIL1" ] && [ -n "$HMAIL2" ] &&
    [ -n "$HPASS1" ] && [ -n "$HPASS2" ] &&
    [ -n "$HAPP1" ] && [ -n "$HAPP2" ]; then
    echo "variables found"
else
    echo "not all required variables set"
fi

hlogin "$HMAIL1" "$HPASS1"

HTIME1=$(htime "$HAPP1")

if echo "$HTIME1" | egrep '[0-9]{3}'; then
    echo "$HMAIL1 fully used, changing to $HMAIL2"
    sleep 5
    heroku ps:scale web=0 -a "$HAPP1"
    sleep 1
    hlogin "$HMAIL2" "$HPASS2"
    heroku ps:scale web=1 -a "$HAPP2"
else
    echo "account 1 still going"
    heroku ps:scale web=1 -a "$HAPP1"
    sleep 2
    hlogin "$HMAIL2" "$HPASS2"
    heroku ps:scale web=0 -a "$HAPP2"
fi
