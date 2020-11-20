Base setup of brand new JeOS machine. This script sets up hostname, user, and basic packages.

# Run JeOS setup script

Download script:

`curl -s https://raw.githubusercontent.com/ishchow/opensuse-tw-jeos-setup/main/opensuse-tw-jeos-setup.sh > opensuse-tw-jeos-setup.sh`
`chmod a+x opensuse-tw-jeos-setup.sh`

Run with default arguments:

`./opensuse-tw-jeos-setup.sh`

Run with arguments:

`./opensuse-tw-jeos-setup.sh -hostname tw-jeos-vm`

Note: see JeOS setup script for all possible arguments.

# Setup dotfiles for user account

Follow these [instructions](https://github.com/ishchow/dotfiles/blob/master/README.md) to setup dotfiles for user account.
