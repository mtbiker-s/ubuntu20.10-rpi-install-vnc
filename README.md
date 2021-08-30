# Installing VNC on Raspberry Pi 4 8gb with Ubuntu 64bit
This was done so that the enablement of RealVNC on Raspberry PI 4 8GB running
Ubuntu.

## Supported Ubuntu Versions 
* Groovy Gorilla (20.10) 64bit
* Hirsute Hippo (21.04) 64bit - **Big thanks to [maurop88](https://github.com/maurop88) for providing the key to fixing the script to work with this version**
* Hirsute Hippo (21.04) 64bit Server Install - **Big thanks to [codefun](https://github.com/maurop88) for providing the key to fixing the script to work with this version and fiding the neccessary missing depencies and suggesting a better install order to avoid errors**

## ChangeLog
* Added logic so that the program could work with Ubuntu Hirsute Hippo 21.04 (Fix provided by **maurop88**)
* Added a check for the versions that script can run against, currently only supports Groovy Gorilla and Hirsute Hippo

Found this on: https://www.raspberrypi.org/forums/viewtopic.php?t=288769[](https://www.raspberrypi.org/forums/viewtopic.php?t=288769)

The folks that inspired me to write this bash script to help others are 
soma72 for the original instructions, pucasso, kazin08, Ghost_Rider51 and maurop88 for cracking the code
With their instructions below



## The steps documented to work
By pucasso, kazin08 and Ghost_Rider51

	# Download package required
	wget https://archive.raspberrypi.org/debian/pool/main/r/realvnc-vnc/realvnc-vnc-server_6.7.2.43081_arm64.deb
	
	# Install package
	sudo dpkg -i realvnc-vnc-server_6.7.2.43081_arm64.deb

	# Change over to the aarch64-linux-gnu folder under /usr/lib
	cd /usr/lib/aarch64-linux-gnu

	# As sudo create symlinks to the following files
	sudo ln libvcos.so /usr/lib/libvcos.so.0
	sudo ln libvchiq_arm.so /usr/lib/libvchiq_arm.so.0
	sudo ln libbcm_host.so /usr/lib/libbcm_host.so.0
	#libbcm_host.so
	# libvcos.so
	sudo ln libmmal.so
	sudo ln libmmal_core.so
	sudo ln libmmal_components.so
	sudo ln libmmal_util.so
	sudo ln libmmal_vc_client.so
	sudo ln libvcsm.so
	sudo ln libcontainers.so

	sudo systemctl enable vncserver-virtuald.service
	sudo systemctl enable vncserver-x11-serviced.service
	sudo systemctl start vncserver-virtuald.service
	sudo systemctl start vncserver-x11-serviced.service
	# sudo reboot
	
# Script to autoinstall
This will be helpful when having to do this across several RPis.
BASH Script based on those documentd steps.

[install-real-vnc-server-rpi4-8gb-ubuntu.sh](install-real-vnc-server-rpi4-8gb-ubuntu.sh)

To run it you must run as sudo 

    # chmod the script first
    chmod +x install-real-vnc-server-rpi4-8gb-ubuntu.sh
    
    sudo ./install-real-vnc-server-rpi4-8gb-ubuntu.sh
    
**E.g. on Hirsute Hippo 21.04**

    You are about to install RealVNC Server for RaspberryPi4 8gb
    realvnc-vnc-server_6.7.2.43081_arm64.deb

    Checking to see if this version of Ubuntu for RaspberryPi is supported by script...
    Distributor ID: Ubuntu
    Description:    Ubuntu 21.04
    Release:        21.04
    Codename:       hirsute
    is supported by this script.
    Would you like to continue?
    Enter 'y' for yes or 'n' for No :
    y

    Installing VNC Server dependencies...
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following NEW packages will be installed:
    libraspberrypi0
    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Need to get 294 kB of archives.
    After this operation, 1139 kB of additional disk space will be used.
    Get:1 http://ports.ubuntu.com/ubuntu-ports hirsute/main arm64 libraspberrypi0 arm64 0~20200520+git2fe4ca3-0ubuntu3 [294 kB]
    Fetched 294 kB in 1s (359 kB/s)
    Selecting previously unselected package libraspberrypi0:arm64.
    (Reading database ... 166200 files and directories currently installed.)
    Preparing to unpack .../libraspberrypi0_0~20200520+git2fe4ca3-0ubuntu3_arm64.deb ...
    Unpacking libraspberrypi0:arm64 (0~20200520+git2fe4ca3-0ubuntu3) ...
    Setting up libraspberrypi0:arm64 (0~20200520+git2fe4ca3-0ubuntu3) ...
    Processing triggers for libc-bin (2.33-0ubuntu5) ...
    Scanning processes...
    Scanning processor microcode...
    Scanning linux images...

    Running kernel seems to be up-to-date.

    Failed to check for processor microcode upgrades.

    No services need to be restarted.

    No containers need to be restarted.

    No user sessions are running outdated binaries.

    Creating symlink for the following files :
    attempting to create symlink file "/usr/lib/libvchiq_arm.so.0"...
    attempting to create symlink file "/usr/lib/libbcm_host.so.0"...
    attempting to create symlink file "/usr/lib/libvcos.so.0"...
    attempting to create symlink file "/usr/lib/libmmal.so.0"...
    attempting to create symlink file "/usr/lib/libmmal_core.so.0"...
    attempting to create symlink file "/usr/lib/libmmal_components.so.0"...
    attempting to create symlink file "/usr/lib/libmmal_util.so.0"...
    attempting to create symlink file "/usr/lib/libmmal_vc_client.so.0"...
    attempting to create symlink file "/usr/lib/libvcsm.so.0"...
    attempting to create symlink file "/usr/lib/libcontainers.so.0"...

    Installing VNC Server : "realvnc-vnc-server_6.7.2.43081_arm64.deb"...
    --2021-08-28 22:30:51--  https://archive.raspberrypi.org/debian/pool/main/r/realvnc-vnc/realvnc-vnc-server_6.7.2.43081_arm64.deb
    Resolving archive.raspberrypi.org (archive.raspberrypi.org)... 46.235.231.111, 46.235.227.39, 176.126.240.86, ...
    Connecting to archive.raspberrypi.org (archive.raspberrypi.org)|46.235.231.111|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 9075008 (8.7M) [application/x-debian-package]
    Saving to: ‘realvnc-vnc-server_6.7.2.43081_arm64.deb’

    realvnc-vnc-server_6.7.2.4308 100%[=================================================>]   8.65M  13.6MB/s    in 0.6s

    2021-08-28 22:30:51 (13.6 MB/s) - ‘realvnc-vnc-server_6.7.2.43081_arm64.deb’ saved [9075008/9075008]

    Selecting previously unselected package realvnc-vnc-server.
    (Reading database ... 166243 files and directories currently installed.)
    Preparing to unpack realvnc-vnc-server_6.7.2.43081_arm64.deb ...
    Unpacking realvnc-vnc-server (6.7.2.43081) ...
    Setting up realvnc-vnc-server (6.7.2.43081) ...
    Updating /etc/pam.d/vncserver
    Updating /etc/pam.conf... done

    NOTICE: common configuration in /etc/pam.d contains the following modules:
    pam_sss.so
    The default vncserver PAM configuration only enables pam_unix. See
    `man vncinitconfig' for details on any manual configuration required.

    Looking for font path... not found.
    Generating private key... done
    Installed systemd unit for VNC Server in Service Mode daemon
    Start or stop the service with:
    systemctl (start|stop) vncserver-x11-serviced.service
    Mark or unmark the service to be started at boot time with:
    systemctl (enable|disable) vncserver-x11-serviced.service

    Installed systemd unit for VNC Server in Virtual Mode daemon
    Start or stop the service with:
    systemctl (start|stop) vncserver-virtuald.service
    Mark or unmark the service to be started at boot time with:
    systemctl (enable|disable) vncserver-virtuald.service

    Processing triggers for mailcap (3.68ubuntu1) ...
    Processing triggers for gnome-menus (3.36.0-1ubuntu1) ...
    Processing triggers for desktop-file-utils (0.26-1ubuntu1) ...
    Processing triggers for hicolor-icon-theme (0.17-2) ...
    Processing triggers for man-db (2.9.4-2) ...
    Processing triggers for shared-mime-info (2.0-1) ...

    Enabling and starting the necessary services...
    Enabling and starting the service "vncserver-virtuald.service"...
    Created symlink /etc/systemd/system/multi-user.target.wants/vncserver-virtuald.service → /lib/systemd/system/vncserver-virtuald.service.
    Enabling and starting the service "vncserver-x11-serviced.service"...
    Created symlink /etc/systemd/system/multi-user.target.wants/vncserver-x11-serviced.service → /lib/systemd/system/vncserver-x11-serviced.service.


    Attempting to make a backup of /etc/gdm3/custom.conf...
    '/etc/gdm3/custom.conf' -> '/etc/gdm3/custom.conf.bkup.20210828-223137'
    total 64K
    -rw-r--r--   1 root root 1.5K Feb 25  2021 greeter.dconf-defaults
    -rw-r--r--   1 root root  554 Feb 25  2021 custom.conf
    -rw-r--r--   1 root root  996 Feb 25  2021 config-error-dialog.sh
    -rwxr-xr-x   1 root root 6.4K Feb 25  2021 Xsession
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 Init
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 PostLogin
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 PostSession
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 PreSession
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 Prime
    drwxr-xr-x   2 root root 4.0K Aug 28 22:16 PrimeOff
    drwxr-xr-x 140 root root  12K Aug 28 22:31 ..
    drwxr-xr-x   8 root root 4.0K Aug 28 22:31 .
    -rw-r--r--   1 root root  554 Aug 28 22:31 custom.conf.bkup.20210828-223137


    Attempting to modify /etc/gdm3/custom.conf
    Un-commenting WaylandEnable=false in file.



    RealVNC Server : "realvnc-vnc-server_6.7.2.43081_arm64.deb" has been installed.

    The system needs to be rebooted.
    Would you like to reboot it now?
    Enter 'y' for yes or 'n' for No :
    n
    No worries you can always reboot when you are ready.
    You can reboot with the command
    sudo shutdown -r now

    
That is pretty much it. Please feel free to modify the logic in script to
make it better.
    
    

    

    


