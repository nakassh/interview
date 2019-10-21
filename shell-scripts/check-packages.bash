#!/bin/bash 
set -o noclobber  # Avoid overlay files (echo "hi" > foo)
set -o errexit    # Used to exit upon error, avoiding cascading errors
set -o nounset    # Exposes unset variables
set -euo pipefail
trap "echo 'error: Script failed: see failed command above'" ERR

DISTRO_DETECTION='' # Debian based = 0 / Fedora based = 1
INSTALLED_PACKAGES=('')
NOT_INSTALLED_PACKAGES=('')

function print_gathered_packages_information () {
    
    if [[ "${#INSTALLED_PACKAGES[@]}" -gt 0 ]]; then
        echo 'Current installed packages:'
        for package in "${INSTALLED_PACKAGES[@]}"; do
            echo -e "\e[92m$package\e[0m"
        done
    fi

    echo
    
    if [[ "${#NOT_INSTALLED_PACKAGES[@]}" -gt 0 ]]; then
        echo 'Not installed packages:'
        for package in "${NOT_INSTALLED_PACKAGES[@]}"; do
            echo -e "\e[31m$package\e[0m"
        done
    fi
}

function check_package_redhat () {
    if [[ -n $(rpm -qa "$1") ]]; then
        INSTALLED_PACKAGES+=("$1")
    else
        NOT_INSTALLED_PACKAGES+=("$1")
    fi
}

function check_package_debian () {
    # TODO: check and implement array
    dpkg -s "$1"
}

function detect_distro_information () {
    if hostnamectl | grep -q -i 'fedora\|red hat\|redhat\|centos'; then
        echo 'Red Hat distro based detected'
        DISTRO_DETECTION=1
        
    elif hostnamectl | grep -q -i 'ubuntu\|debian\|deepin\|mint'; then
        echo 'Debian based distro detected'
        DISTRO_DETECTION=0

    else 
        echo 'Your distro is not supported'
        exit 25
    fi
}

function loop_each_package () {
    for package in "$@"; do 
        if [[ $DISTRO_DETECTION -eq 1 ]]; then
            check_package_redhat "$package"
        
        elif [[ $DISTRO_DETECTION -eq 0 ]]; then
            echo check_package_debian "$package"
    fi
done
}

detect_distro_information
loop_each_package "$@"
print_gathered_packages_information