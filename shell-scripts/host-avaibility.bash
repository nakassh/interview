#!/bin/bash 
# set -o noclobber  # Avoid overlay files (echo "hi" > foo)
# set -o errexit    # Used to exit upon error, avoiding cascading errors
# set -o nounset    # Exposes unset variables
# set -euo pipefail
# trap "echo 'error: Script failed: see failed command above'" ERR

# This script attempts to check a host avaibility.
# Use this to check if a host is up.

# Works in: 
# Debian and RedHat based distros (Debian, Deepin, Ubuntu, Centos, Fedora)

# How to use it:
# Pass the host ip as argument or set it on HOST_IP variable

HOST_IP='192.168.0.1'
NUM_PACKAGES=4

function start_script () {
    # Check if any argument is provided.
    # In case of that, each IP or domain passed will be checked in a loop.
    # Case any argument is provided, this script attempt to use $HOST_IP variable to execute.

    # Arguments are prioritary. They are always executed first.

if [[ $# -eq 1 ]]; then
    # If only one argument is given, execute it.
    echo "Checking by argument: $1"
    check_host_avaibility "$1"

elif [[ $# -ge 2 ]]; then
    # In case multiple arguments, execute it in a loop.
    for host in "$@"; do
        echo "Checking by argument: $host"
        check_host_avaibility "$host"
    done 

elif [[ -n $HOST_IP ]]; then
    # Check if $HOST_IP variable is not empty and then execute it
    echo "Checking by script variable: $HOST_IP"
    check_host_avaibility "$HOST_IP"

else
    # If no arguments is given and $HOST_IP is empty, it stops now.
    echo 'Neither HOST_IP variable nor argument are set.'
    echo 'You must set at least one.'
fi
}

function print_result () {
    # Extract the packets received and trasmitted
    PACKETS_TRASMITTED=$(echo "$@" | cut -d ' ' -f1)
    PACKETS_RECEIVED=$(echo "$@" | cut -d ' ' -f2)

    # echo "TX: $PACKETS_TRASMITTED"
    # echo "DX: $PACKETS_RECEIVED"
    
    if [[ $PACKETS_RECEIVED -eq 0 ]]; then
        # No packets received
        echo 'Host seems down. None packet received'

    elif [[ $PACKETS_RECEIVED -eq $NUM_PACKAGES ]]; then
        # All packets received
        echo 'Host is UP!'

    elif [[ $PACKETS_RECEIVED -gt 2 ]]; then
        # More then 3 packets received
        echo 'Host seems up.'

    elif [[ $PACKETS_RECEIVED -le 2 ]]; then
        # Less the 3 packet receveid
        # It seems to be connection problems
        echo 'Host seems up. But you have connections problems'       
    fi
}

function check_host_avaibility () {
    # Command to check if a host is up/down
    # Basically if less than 3 packets gets no answer, the host is treated as down.
    PING_COMMAND=$(ping -q -c "$NUM_PACKAGES" -W 4 "$1" | grep packets | cut -d ' ' -f1,4,6) 
    PING_EXIT_CODE=$?

    if [[ -z $PING_COMMAND ]]; then
        # The ping command return 0 even when the domain/ip is wrong/impossible/inexistent/nosense and print a not clear message
        # And as the $PING_COMMAND uses grep, some domain erros can be not shown.
        # In such case, it will result in a empty $PING_COMMAND varible
        echo 'Domain, Host or IP is wrong'

    elif [[ $PING_EXIT_CODE -eq 0 ]]; then
        # In case of success (code 0), continue
        print_result "$PING_COMMAND"

    elif [[ $PING_EXIT_CODE -eq 1 ]]; then
        # Sometimes, Ping command return exit code to 1 when no packets are received
        # In this case, print a briefy explanation to user
        echo 'Host seems down. None packets received'

    elif [[ $PING_EXIT_CODE -eq 2 ]]; then
        # Sometimes, Ping command return exit code to 2 when domain/ip are impossible/inexistent
        # In this case, print a briefy explanation to user
        echo 'Domain, Host or IP wrong'

    else 
        # In any other case that it falls, display the exit code
        echo "Error: $PING_EXIT_CODE"
    fi
}

start_script "$@"

