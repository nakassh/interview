#!/bin/bash

TOKEN='a1b2c3d4e5-YOUR-TOKEN-HERE-a1b2c3d4e5f6'
DOMAIN='domain'
VERBOSE='true'

curl -o ~/duckdns.log -k "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&verbose=$VERBOSE" >/dev/null 2>&1