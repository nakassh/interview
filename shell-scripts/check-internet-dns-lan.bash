#!/bin/bash 
# set -o noclobber  # Avoid overlay files (echo "hi" > foo)
# set -o errexit    # Used to exit upon error, avoiding cascading errors
# set -o nounset    # Exposes unset variables
# set -euo pipefail
# trap "echo 'error: Script failed: see failed command above'" ERR

## Colors
COLOR_LIGHT_GREEN='\e[92m'
COLOR_LIGHT_RED='\e[91m'
COLOR_LIGHT_YELLOW='\e[93m'
COLOR_RESET='\e[0m'

INTERNET_URL_TEST='google.com'
IP_GOOGLE_DNS='8.8.8.8'
IP_CLOUDFLARE_DNS='1.1.1.1'
IP_LAN_GATEWAY=$(ip route | grep default | cut -d ' ' -f3)

function verify_internet_connection () {
    
    if [[ -n $(curl -kfsL $INTERNET_URL_TEST | grep html) ]]; then
        echo -e "Internet: ${COLOR_LIGHT_GREEN}Operational${COLOR_RESET}"
    else
        echo -e "Internet: ${COLOR_LIGHT_RED}Not working${COLOR_RESET}"        
    fi
}

function verify_dns_connection () {

    PING_COMMAND=$(ping -q -c 4 -W 4 "$IP_CLOUDFLARE_DNS" | grep packets | cut -d ' ' -f4) 
    if [[ -z $PING_COMMAND ]]; then
        echo -e "DNS     : ${COLOR_LIGHT_RED}Not working${COLOR_RESET}"        
    else
        if [[ $PING_COMMAND -gt 2 ]]; then
            echo -e "DNS     : ${COLOR_LIGHT_GREEN}Operational${COLOR_RESET}"
        elif [[ $PING_COMMAND -eq 0 ]]; then
            echo -e "DNS     : ${COLOR_LIGHT_YELLOW}Not good - High packet${COLOR_RESET}"
        elif [[ $PING_COMMAND -eq 0 ]]; then
            echo -e "DNS     : ${COLOR_LIGHT_RED}Not working${COLOR_RESET}"
        fi        
    fi
}

function verify_gateway_connection () {

    if [[ -z $IP_LAN_GATEWAY ]]; then
        echo 'You appears either not connected or not have a default connection'
        exit 25
    fi

    PING_COMMAND=$(ping -q -c 4 -W 4 "$IP_LAN_GATEWAY" | grep packets | cut -d ' ' -f4) 
    if [[ -z $PING_COMMAND ]]; then
        echo -e "Gateway : ${COLOR_LIGHT_RED}Not working${COLOR_RESET}"        
    else
        if [[ $PING_COMMAND -gt 2 ]]; then
            echo -e "Gateway : ${COLOR_LIGHT_GREEN}Operational${COLOR_RESET}"
        elif [[ $PING_COMMAND -eq 0 ]]; then
            echo -e "Gateway : ${COLOR_LIGHT_YELLOW}Not good - High packet${COLOR_RESET}"
        elif [[ $PING_COMMAND -eq 0 ]]; then
            echo -e "Gateway : ${COLOR_LIGHT_RED}Not working${COLOR_RESET}"
        fi        
    fi
}

verify_gateway_connection
verify_dns_connection
verify_internet_connection