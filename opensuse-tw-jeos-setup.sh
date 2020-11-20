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

echo "Changing hostname to $hostname..."
hostnamectl set-hostname $hostname

echo "Installing base packages..."
zypper in -y -t pattern enhanced_base console sw_management documentation
zypper in -y command-not-found sudo

echo "Adding groups..."
groupadd -f users
groupadd -f wheel
groupadd -f docker

echo "Creating user $username..."
useradd -g users -G wheel,docker -m $username

# Adapted from https://stackoverflow.com/a/22940001
printf "Enter password for user: "
password=''
while IFS= read -r -s -n1 char; do
  [[ -z $char ]] && { printf '\n'; break; } # ENTER pressed; output \n and break.
  if [[ $char == $'\x7f' ]]; then # backspace was pressed
      # Remove last char from output variable.
      [[ -n $password ]] && password=${password%?}
      # Erase '*' to the left.
      printf '\b \b' 
  else
    # Add typed char to output variable.
    password+=$char
    # Print '*' in its stead.
    printf '*'
  fi
done

echo "Setting password for $username..."
echo "$username:$password" | chpasswd
unset password

echo "Disabling ssh root login..."
sed -i '/^PermitRootLogin[ \t]\+\w\+$/{ s//PermitRootLogin no/g; }' /etc/ssh/sshd_config

echo "Restarting sshd service..."
sudo systemctl restart sshd
