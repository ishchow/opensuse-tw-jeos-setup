#!/bin/bash

# args
hostname=${hostname:-tw-jeos-vm}
username=${username:-ishaat}

# parse args
# taken from: https://brianchildress.co/named-parameters-in-bash/
while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
    fi
    shift
done

echo "Changing hostname..."
hostnamectl set-hostname $hostname

echo "Installing base packages..."
zypper in -y -t pattern enhanced_base console sw_management documentation
zypper in -y command-not-found sudo

echo "Adding groups..."
groupadd -f users
groupadd -f wheel
groupadd -f docker

echo "Create user..."
useradd -g users -G wheel,docker -m $username
passwd $username

echo "Logging in as user..."
su - $username

