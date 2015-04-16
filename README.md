#securbox - SecurStick Linux Wrapper
securbox is a wrapper program for SecurStick under Linux, written as a bash script.
It's able to connect to your SecurStick via commandline, mount or unmount it and is able to set up the SecurStick Safe Zone.

#Requirements
* `davfs2` (`mount.davfs`) for mounting SecurStick webDAV share 
* `awk` for get the address from output file (`awk` should be installed by default)
* `cURL` to get pages and `POST` password.
* `realpath` for getting absolute paths of the SecurBox home directory
* SecurStick
* Zenity can be used for asking for password by a GUI. (optimal)

#Prerequisites

##Packages
Install davfs, realpath and cURL packages:

    sudo apt-get install davfs2 realpath curl

Optional also install zenity:

    sudo apt-get install zenity

##SecurStick
Go to [SecurStick Homepage](http://www.withopf.com/tools/securstick/) and download SecurStick.

##securbox
Clone this repository into a favourite directory  

* via SSH with `git clone git@github.com:criztovyl/securbox.git` or
* via HTTPS with `git clone https://github.com/criztovyl/securbox.git`


#"Setup"
 * In these steps I use `vim`, if you don't want to use `vim`, replace it with `nano`.
 * Choose a folder for your securbox (default is `.securbox` in the user's home directory)
 * Extract SecurStick into it (if you only want to use it on Linux, take SecurStick-linux only)
 * If you want to be able to start your securbox from every dir, include `securbox` into your PATH. (Add `export PATH=$PATH:/path/to/securbox-dir` to your `.bashrc`)  
   TODO: Multiple securboxes.
 * Now you should add the securbox to fstab so that you can mount it as a normal user.
   - We're doing this by adding securbox to `fstab`, setting up the davfs2 secrets file, fixing a `mount.davfs` bug and adding the user to the `davfs2` group.
   - Add `http://127.0.0.1:2000/X /media/securbox davfs user,noauto 0 0` to your `/etc/fstab` file (`sudo vim /etc/fstab`)  
   (you can use a different mounting point but then you have to change it also in the `securbox` file, same way as setting the home in the point below, but look into line 24 instead of 21 ;) )
   - the SecurStick DAV is not secured with user and password so you can simply add no user and password to the DAV secrets file (`vim ~/.davfs2/secrets`): `/media/securbox                 ""            ""`
   - There is a bug in mount.davfs when not mounting as a root user, telling you `program is not setuid root`. Fix this using `sudo chmod u+s /sbin/mount.davfs`
   - Add your user to `davfs2` group: `sudo adduser $USER davfs2`
 * Open the `securbox` file and change the securbox home to the folder you've chosen in the first point (line 21; use `$HOME` instead of `~` to identify your home directory)
 * Now you can use `securbox` :)

#Usage
 To start `securbox`, type

     securbox start

into your command line. If you havn't set up your securbox, this will be done immediately as shown below.

Meanwhile securbox will start but the script needs to wait some seconds (3) to let SecurStick start up. So the following output is normal:

    Waiting for SecurStick startup...
    3 seconds remaining...
    2 seconds remaining...
    1 seconds remaining...
    Continue...

This will not happen every time because SecurStick maybe already running, as example if you entered the wrong password.
Now set a password if you didn't yet:

    Please set a new password for your securbox with at least 5 letters, both UPPER and lower case, at least one digit and at least one special character (like !,?,#).
    Enter password  : 
    Repeat password : 

If your passwords match and are strong enough, securbox will set up the Safe Zone and log in:

    Please set a new password for your securbox with at least 5 letters, both UPPER and lower case, at least one digit and at least one special character (like !,?,#).
    Enter password  : 
    Repeat password : 
    Logged in :)
    Mounted.

Sometimes you will get the below messages. If you get them something went wrong. Kill securbox with `securbox kill` and then restart with `securbox start`.

    /sbin/mount.davfs: connection timed out two times;
    trying one last time
    /sbin/mount.davfs: server temporarily unreachable;
    mounting anyway

Now you can use your securbox. Go! Go to work!  
If you're finisched, you can close the securbox by typing

    securbox stop

This will unmount your securbox and stop it. Maybe you will see `mount` waiting for synchronsation of the cache. Simply wait.

    /sbin/umount.davfs: waiting while mount.davfs (pid 13987) synchronizes the cache .. OK

#Troubleshooting

If your files in the webDAV folder are not accessable, stop and kill securbox (with `securbox stop` and `securbox kill`) and try again.

#Meta

##Background
I'm using SecurStick to carry my "top secrect" stuff with me in my Dropbox.

The early time, I simply started the SecurStick with a ugly double-click (as if we wold be in Windows...) and then SecurStick mounts to Nautilus.

After a while I wanted to access the data from SecurStick via command line. But mounted in Nautilus that doesn't work.

Then I've searched for a possibility to mount the (web)DAV share and found davfs2. But it's very uncomfortable when you do this manually: First you have to open the FileManager, go to the SecurStick folder, double-click SecurStick, waiting the web browser to start, enter password, unmount from nautilus (neither it's unnecessery), open command line and mount.

So I've written this script.

###Problems
I've found no documentation about SecurStick command line usage so I search the hard-coded strings in the executable, as example how to disable nautilus mount and disable opening the browser. (Described at the end of the file) 

After that I found out, that you can't simply POST password and unlock SecurStick, you have to GET the index and the image first.

###ToDo
 * PATH independency (?)
 * multiple securboxes
 * make useable off commandline (Zenity)

###Changelog

 * 18.03.2014
   - Bugfix: Dead SecurStick instance from PID-file is now detected correctly, previously death-check was traped inside file existance check. 
   - Improves zenity (development will be continued on zenity-dev branch soon)
 * 13.02.2014
   - Improvements
      + Countdown while wait for SecurStick start
      + Only single SecurStick/securbox instance can run (until multiple securboxes are supported)
   - Bugfix: PID wasn't read from PID-file.
   - Fixes some indenting
   - Adds the countdown as a function
 * 08.02.2015
   - Improvement: Wait a moment to let SecurStick start
   - Repair a mistake (`cat` PID-file before check if it exits)
   - Improved README
 * 21.12.2014 
   - Improvements
     + Safe Zone setup
     + removes cURL progressess
     + adds new lines after asking password
 * 25.11.2014 Initiated

##License
This Project is licensed under GPLv3 or newer. See gpl.txt for details.

##Author
(c) 2014 Christoph "criztovyl" Schulz. <ch.schulz@joinout.de>

##Links
* [GitHub Repo](https://github.com/criztovyl/securbox)
* [GitHub Author](https://github.com/criztovyl)
* [Author Website](http://joinout.de)
* [Author Blog](http://criztovyl.joinout.de)
* securbox Page (coming soon...maybe^^)

#SecurStick Command line options

Here are the options I've found in SecurStick-linux. (Obvoious options are not described)  
--Notice the colons, they're required--

* -NoBrowser
* -NoMount
* -R: (unknown)
* -ra (unknow)
* -ServerPort: (for webDAV server)
* -Drive: (Drive letter on windows, I think)
* -UsePW: (won't work with spaces)
* -FixHREF (unknown)
* -IgnoreSpotlight (unknown)
* -LockPause (unknown)
* -EnableIMS (unknown)
* -DisableIMS (unknown)
* -DisableUnsafePWCheck
* -DisableConsoleMinimize
* -Debug
* -NoUnzipWarning (?)
* -v (Version)
