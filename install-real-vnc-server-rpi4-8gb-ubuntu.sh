#!/bin/bash

# Script that will install RealVNC on Raspberry Pi 8gb with Ubuntu 20.10 64bit
# Based on instructions from https://www.raspberrypi.org/forums/viewtopic.php?t=288769
# Thanks to soma72 for the original instructions and pucasso, kazin08 and Ghost_Rider51 for cracking the code
# This script is built based on their efforts.
# It will hopefully help others the way it helped me. Just paying it forward.
# I know I will be using it on my other RPis


vncServer="realvnc-vnc-server_6.7.2.43081_arm64.deb"

releaseInfo=`lsb_release -a`
releaseVersion=`lsb_release -r`


# Array of Ubuntu versions that need to have the
# file custom.conf under /etc/gdm3 modified
# 20.10 = Groovy Gorilla
# 21.04 = Hirsute Hippo
declare -a lookForVersions=( "20.10" "21.04" )

# This function should only be called for the versions
# of Ubuntu RPi like Hirsute Hippo v21.04 so that the 
# VNC piece could function.
# It basically enables false on Wayland for gdm3 in the
# custom.conf file. It makes a backup of the custom.conf
# file first.
function modifyGDM3CustomConf(){
    
    # Make backup of custom.conf under /etc/gdm3
    # replace the #WaylandEnabled=false with out it being commented out
    gdm3File="/etc/gdm3/custom.conf"
    echo
    echo
    echo "Attempting to make a backup of $gdm3File..."
    timeStamp=$(date '+%Y%m%d-%H%M%S')
    sudo cp -rfv "$gdm3File" "$gdm3File.bkup.$timeStamp" 

    ls -lahtr /etc/gdm3
    
    # Using sed to modify custom.conf under /etc/gdm3
    echo
    echo
    echo "Attempting to modify $gdm3File"
    echo "Un-commenting WaylandEnable=false in file."
    sudo sed -i 's/#WaylandEnable=false/WaylandEnabled=false/g' $gdm3File
    echo
    echo

}

# This is the main function and must be called at the 
# bottom of the program, otherwise it will not run
function main(){

    echo "You are about to install RealVNC Server for RaspberryPi4 8gb"
    echo $vncServer
    echo
    echo "Checking to see if this version of Ubuntu for RaspberryPi is supported by script..."

    
    for version in "${lookForVersions[@]}"
    do
        if [[ "$releaseVersion" == *"$version"* ]]; then
            isSupportedVersion=1
        else
            isSupportedVersion=0
        fi
    done


    if [[ $isSupportedVersion == 1 ]]; then
        echo "$releaseInfo"
        echo "is supported by this script."
    else
        echo "$releaseInfo"
        echo "Is not supported, exiting program..."
        exit
    fi


    echo "Would you like to continue?"
    echo "Enter 'y' for yes or 'n' for No :"
    read -r answer

    if [[ $answer == 'y' || $answer == 'Y' ]]; then

        # Start by installing all libraries VNC server will depend on
		echo
        echo "Installing VNC Server dependencies..."
		
        # Add RaspPi missing lib, could occur when using clean Ubuntu RaspPI image 
        # Bug repored by https://github.com/codefun
        # https://github.com/mtbiker-s/ubuntu20.10-rpi-install-vnc/issues/4
        sudo apt install libraspberrypi0

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

		# Download VNC server package and get ready to install it
        echo
        echo "Installing VNC Server : \"$vncServer\"..."
        wget https://archive.raspberrypi.org/debian/pool/main/r/realvnc-vnc/$vncServer

        # Install package
        sudo dpkg -i $vncServer

		# VNC services that will make use of the lib files previously installed
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

        
        # Running this only if the version of Ubuntu
        # for RPi is not Hirsute Hippo 20.10
        if [[ "$releasVersion" != *"20.10"* ]]; then
                # Call function to do the modification of
                # the /etc/gdm3/custom.conf file
                modifyGDM3CustomConf
        fi

       

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
}

# Calling the main function
main