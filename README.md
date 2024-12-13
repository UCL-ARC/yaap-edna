# yaap-edna
This repository documents setting up the YAAP pipeline to run on the UCL Myriad HPC following [ilevantis/YAAP](https://github.com/ilevantis/YAAP).

## Setting up a programmers text editor
To edit text and script files you will need a suitable text editor such as [VSCode](https://code.visualstudio.com/), which works on Mac, Windows or Linux.

## Setting yourself up on Myriad
General help getting an account on Myriad and how to use it can be found [here](https://www.rc.ucl.ac.uk/docs/Clusters/Myriad/). Using myriad involves connecting to its ssh service which allows you to type in commands and also to remotely edit your files. This section explains how to set your self up to work efficiently on myriad using ssh.

If you will need to log in from off-site and [without using the UCL VPN](https://www.rc.ucl.ac.uk/docs/howto/#logging-in-from-outside-the-ucl-firewall) then you will need to log in via the ssh jump server. Otherwise you can simply log in direct to myriad. Note that myriad has more than one login server and each login you will be assigned at random to one or the other. If you intend to leave anything running on the login server that you'll want to return to later you will benefit from forcing you logins to always go to the same server. I cover this below.


### Create an ssh key pair
I would recommend setting up ssh key based login to allow access without typing in passwords each time. On Mac or Linux the required ssh commands should already be available. On Windows from powershell you may already have the neccessary `ssh-keygen.exe` installed or you can install [GitBash](https://gitforwindows.org/) or [MobaXterm](https://mobaxterm.mobatek.net/).

First generate an ssh key pair (Linux/Mac/GitBash):

```
ssh-keygen -t ed25519
```

Or (Powershell):

```
ssh-keygen.exe -t ed25519
```

When it asks you where to save the key files, use the filename `id_ed25519` in a folder called `.ssh` directly under your home folder (this is usually the default). It will then ask for a passphrase. It is more secure to use a passphrase, but this will require you to enter the passphrase everytime you use the key to login unless you also setup the [ssh-agent](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement) system which is beyond the scope of this guide. There is little point in using key-based logins if you set a passphrase without also setting up `ssh-agent`, as you will still have to enter the passphrase every time you login.

An ssh key pair is two files, one of which ends in `.pub`. This is the public half of the pair, and can be safely copied to a remote server that you want to log in to. The other file is the private key, and should be kept secret and secure. If someone steals it they can log in to any server that accepts your key without needing to know your password. Protecting the private key with a passphrase means they would need to know this passphrase to be able to log in with the private key.

### Setup your ssh config file
Once you have your key files saved in your `.ssh` folder you can setup your ssh configuration file to create a convenient alias for logging into myriad. On windows this file should be stored as `C:\Users\<username>\.ssh\config`, on Mac or Linux it should be `~/.ssh/config`. Edit this file in your text editor if it exists, or else create it from scratch and add a section for myriad (Linux/Mac):

```
Host myriad
  HostName login13.myriad.rc.ucl.ac.uk
  IdentityFile /home/<your_local_username>/.ssh/id_ed25519
  ProxyJump <your_myriad_username>@ssh.rc.ucl.ac.uk
  User <your_myriad_username>
```

(Windows):
```
Host myriad
  HostName login13.myriad.rc.ucl.ac.uk
  IdentityFile C:\Users\<your_local_username>\.ssh\id_ed25519
  ProxyJump <your_myriad_username>@ssh.rc.ucl.ac.uk
  User <your_myriad_username>
```

Be sure to replace `<your_local_username>` and `<your_myriad_username>` with your local and myriad usernames respectively, eg if your myriad username is `ccaexyz` the last line would become `User ccaexyz`. If you don't need to use the jump server then you can delete the `ProxyJump` line.

### Copy the key to myriad
Once you have created the key files you need to copy the *public* one to myriad. You will first want to copy it to the ssh jump server if you're using that. To copy to the jump server use (Linux/Mac/GitBash):

```
ssh-copy-id <your_myriad_username>@ssh.rc.ucl.ac.uk
```

Or (Powershell):
```
type ~\.ssh\id_ed25519.pub | ssh <your_myriad_username>@ssh.rc.ucl.ac.uk "cat >> .ssh/authorized_keys"
```

replacing `<your_myriad_username>` with the short form of your UCL username, eg something like ccaexyz. It should ask you to enter your password.

Now repeat the process for myriad (Linux/Mac/GitBash):
```
ssh-copy-id <your_myriad_username>@myriad
```

Or (Powershell):
```
type ~\.ssh\id_ed25519.pub | ssh myriad "cat >> .ssh/authorized_keys"
```

You should now be able to login to myriad without entering your password (unless you set an ssh key passphrase) using:
```
ssh myriad
```

### Editing files on myriad using VS Code
Once you have ssh access setup for myriad you can use the VS Code [Remote-SSH extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) to directly edit files on myriad. Follow the instructions to install and setup the extension. When you come to add a new host make sure the extension is using the ssh config file you setup above and it should be able to use your existing ssh key to login.

## Installing the pipeline on myriad
The `install.sh` file in this repository lists the commands used to set up the conda environment. You may find it easier to run each line manually rather than execute the script itself. This should only need to be done once. It is assumed that your personal `~/bin` folder is in your `PATH`, so that things installed can be run from anywhere. If this is not the case simply add `export PATH=${PATH}:~/bin` to the end of your `.bashrc` file.
