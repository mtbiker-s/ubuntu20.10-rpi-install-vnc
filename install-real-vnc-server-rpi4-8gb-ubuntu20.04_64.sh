#!/bin/bash

# Script that will install RealVNC on Raspberry Pi 8gb with Ubuntu 20.10 64bit
# Based on instructions from https://www.raspberrypi.org/forums/viewtopic.php?t=288769
# Thanks to soma72 for the original instructions and pucasso, kazin08 and Ghost_Rider51 for cracking the code
# This script is built based on their efforts.
# It will hopefully help others the way it helped me. Just paying it forward.
# I know I will be using it on my other RPis


vncServer="realvnc-vnc-server_6.7.2.43081_arm64.deb"


echo "You are about to install RealVNC Server for RaspberryPi4 8gb"
echo $vncServer
echo "Running OS Ubuntu 20.10 64bit"
echo
echo

echo "Would you like to continue?"
echo "Enter 'y' for yes or 'n' for No :"
read -r answer

if [[ $answer == 'y' || $answer == 'Y' ]]; then


    # Download package required
    echo
    echo "Installing VNC Server : \"$vncServer\"..."
    wget https://archive.raspberrypi.org/debian/pool/main/r/realvnc-vnc/$vncServer

    # Install package
    sudo dpkg -i $vncServer

    # Change over to the aarch64-linux-gnu folder under /usr/lib
    # Source file location of libs needed
    cd "/usr/lib/aarch64-linux-gnu" || exit


    # Array of the files that are needed to create the lib symlinks
    declare -a libFilesToSymLink=( "libvchiq_arm.so" "libbcm_host.so" "libvcos.so" "libmmal.so" "libmmal_core.so" "libmmal_components.so"
    "libmmal_util.so" "libmmal_vc_client.so" "libvcsm.so" "libcontainers.so" )


    # Create the symlinks for the following files
    echo
    echo "Creating symlink for the following files :"

    ## Array Loop
    for fileName in "${libFilesToSymLink[@]}"
    do
      # Will create sym links for the following files
      # Note it will create the symlink file with .0 appended under the /usr/lib folder
      sourceFile="/usr/lib/aarch64-linux-gnu/"$fileName
      symlinkFile="/usr/lib/$fileName.0"
      echo "attempting to create symlink file \"$symlinkFile\"..."
      sudo ln -s "$sourceFile" "$symlinkFile"
    done

    declare -a servicesNeeded=( "vncserver-virtuald.service" "vncserver-x11-serviced.service")

    # enable the services for vncserver
    echo
    echo "Enabling and starting the necessary services..."
    for serviceName in "${servicesNeeded[@]}"
    do
        echo "Enabling and starting the service \"$serviceName\"..."
        sudo systemctl enable "$serviceName"
        sudo systemctl start "$serviceName"
    done

    echo
    echo "RealVNC Server : \"$vncServer\" has been installed."

    echo
    echo "The system needs to be rebooted."
    echo "Would you like to reboot it now?"
    echo "Enter 'y' for yes or 'n' for No :"
    read -r rebootAnswer


    if [[ $rebootAnswer == 'y' || $rebootAnswer == 'Y' ]]; then
        echo "Rebooting System..."
        sudo shutdown -r now
    else
        echo "No worries you can always reboot when you are ready."
        echo "You can reboot with the command"
        echo "sudo shutdown -r now"
    fi

else
    echo "No worries, you can always run the program later."
    echo "Exiting program..."
    echo

    exit 0
fi
