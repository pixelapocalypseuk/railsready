#!/bin/bash
#
# Rails Ready Ready - Get Ready for Rails Ready
#
# Author: Josh McArthur <josh@3months.com>
# License: MIT
#
#

shopt -s nocaseglob
set -e

script_runner=$(whoami)
railsready_path=$(cd && pwd)/railsready
log_file="$railsready_path/install.log"
distro_sig=$(cat /etc/issue)
admin_user_name="administrator"
user_home="/home/$admin_user_name"
repository_url="https://github.com/3months/railsready"
templates_url="https://github.com/3months/railsready/raw/master/templates"

control_c()
{
    echo -n "\n\n*** Exiting ***\n"
    exit 1
}

# Intercept any keyboard interrupts
trap control_c SIGINT

# Print pretty header
echo -e "\n\n"
echo "##########################################"
echo "########## Rails Ready :: READY ##########"
echo "##########################################"

# Check the distro is supporter
if [[ $distro_sig =~ ubuntu ]] ; then
    distro="ubuntu"
else
    echo -e "\nRails Ready Ready currently only supports Ubuntu\n"
    exit 1
fi

# Check user is root
if [ $script_runner =! "root" ] ; then
    echo -e "\nThis script must be run as root, as it needs to set up some system-level files and settings. If you are worried about the security of allowing this, it is suggested that you carefully review the actions this script will take\n"
    exit 1
fi

echo -e "\n\n"
echo "!!! This script will update your system! Run on a fresh install only !!!"
echo "run tail -f $log_file in a new terminal to watch the install"

echo -e "\n"
echo "What this script gets you:"
echo " * An $admin_user_name user that is permitted to sudo"
echo " * A secure SSH configuration preconfigured to prefer public key authenitcation"
echo " * A webserver-oriented IP Tables configuration allowing web and SSH traffic only"

echo -e "\nThis script is always changing."
echo "Make sure you got it from https://github.com/3months/railsready"

echo -e "\n"
echo -e "\n=> Creating log file..."
cd && mkdir -p railsready_ready && touch install.log
echo "==> done."

echo -e "\n=> Creating $admin_user_name user..."
useradd $admin_user_name -G admin --create-home
echo "==> done."

echo -e "\n=> Installing OpenSSH server, if it isn't already installed..."
apt-get install openssh-server
echo "==> done."

if [[ -d "$user_home/.ssh" ]] ; then
    echo -e "\n=> Don't need to create user's .ssh directory, it already exists"
else
    echo -e "\n=> Creating SSH config folder structure at $user_home/.ssh..."
    mkdir -p $user_home/.ssh
fi
echo "==> done."

echo "Replace system-default SSHD config file with more secure version? Summary of changes:"
echo "=> 1. Root login disabled"
echo "=> 2. Only user $admin_user_name is permitted to login."
echo "=> 3. Unused authentication mechanisms are disabled."
echo "=> 4. Some other minor performance and security enhancements."
echo "!!! NOTE: This script will set up public key authentication, but will not disable password authentication - just something to keep in mind !!!"
echo -n "Replace SSHD config? [y or n]? "
read replaceSSHD

if [ $replaceSSH -e "y" ] ; then
    echo -e "=> Replacing default SSHD config with template from $templates_url/sshd_config..."
    echo "Backed up old sshd_config to sshd_config.old"
    wget --no-check-certificate -0 /etc/ssh/sshd_config $templates_url/ssh_config
    sed s/AllowUsers ADMIN_USER_NAME/AllowUsers $admin_user_name/ </etc/ssh/sshd_config >/etc/ssh/sshd_config
    echo "==> done."
else
    echo "==> Skipped."
fi

echo "Add IP Tables ruleset for a Rails web server? Summary of changes:"
echo "=> 1. Web server ports 80 and 443 are enabled for all traffic"
echo "=> 2. Your configured SSH port is open for incoming traffic"
echo "=> 3. Incoming ping requests are allowed."
echo "=> 4. All other incoming ports are blocked, but outgoing traffic is permitted on any port"
echo -n "Add IP Tables config? [y or n]? "
read addIPTables

if [$addIPTables -e "y" ] ; then
    echo -e "=> Adding configuration for IP Tables from $templates_url/iptables.up.rules"
    echo "Flush existing rules..."
    /sbin/iptables -F
    echo "Placing rules file in /etc"
    wget --no-check-certificate -0 /etc/iptables.up.rules $templates_url/iptables.up.ruels
    echo "Adding network interface boot script to load rules into iptables"
    echo -e '#!/bin/sh
        /sbin/iptables-restore < /etc/iptables.up.rules' > /etc/network/if-pre-up.d/iptables
    echo "Making new script executable"
    chmod +x /etc/network/if-pre-up.d/iptables
    echo "==> done."
else
    echo "==> Skipped."
fi




