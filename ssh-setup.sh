#!/bin/bash
# This script automates the setup of an SSH connection from the local machine
# (Myriad) to a the UCL Research Data Storage Service (RDSS). It generates an RSA key pair, copies the
# public key to the RDSS server, and configures SSH for passwordless
# authentication.

# Get the UCL username from the command line.
USERNAME=$1

# If no username is provided use the current user.
if [ -z "$USERNAME" ]; then
  USERNAME=$USER
fi

# Define the RDS server and the file path for the generated RSA key.
RDSS="rdp-ssh.arc.ucl.ac.uk"
KEY_FILE="$HOME/.ssh/rdss_key"

# Create the SSH configuration folder if it does not exist.
if [ ! -d $HOME/.ssh ]; then
	echo "Creating .ssh folder"
	mkdir $HOME/.ssh
fi

# Generate an RSA key pair for authenticating the connection from Myriad to RDS.
echo "Generating rsa key pair"
ssh-keygen -t rsa -f $KEY_FILE -q -N ""

# Copy the public key to the RDSS server, prompting for the UCL password.
echo "Copying public key to RDSS server"
echo "Please enter your UCL password when prompted"
ssh-copy-id -i $KEY_FILE $USERNAME@$RDSS

# Ensure the SSH config file exists; if not, create it.
if [ ! -f $HOME/.ssh/config ]; then
	echo "Creating ssh config file"
	touch $HOME/.ssh/config
fi

# Add the RDSS server configuration to the SSH config file if it does not exist.
if ! grep -q "Host rdss" $HOME/.ssh/config; then
  echo "Adding RDSS server to SSH config file"
  echo "
Host rdss
  HostName $RDSS
  User $USERNAME
  IdentityFile $KEY_FILE
  ForwardAgent yes
  AddKeysToAgent yes
" >>$HOME/.ssh/config
fi

# You should now be able to connect to RDSS without a password
# by running the following command:
# ssh rdss
