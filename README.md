#securbox - SecurStick Linux Wrapper
securbox is a wrapper program to use SecurStick under linux, written as a bash script.
It's able to connect to your SecurStick via commandline, completely without browser, and mount or unmount it.

#Requirements
* `davfs2` (`mount.davfs`) for mounting SecurStick webDAV share 
* `awk` for get the address from output file (`awk` should be installed by default)
* `cURL` to get pages and `POST` password.
* SecurStick
* Zenity can be used for asking for password by a GUI. (optimal)

#Prerequisites

##Packages
Install davfs and cURL packages (davfs2 and curl):

    sudo apt-get install davfs2 curl

Optional also install zenity:

    sudo apt-get install zenity

##SecurStick
Go to [SecurStick Homepage](http://www.withopf.com/tools/securstick/) and download SecurStick and CryptUtil (for Linux ;) ).

#"Setup"
 * Choose a folder for your securbox
 * Extract SecurStick and CryptUtil into it
 * Copy `securbox` and `securstick` to PATH
 * First time you need to start `SecurStick-linux` manually and set up securbox password (simply double-click it)
   + Follow the orders given by SecurStick.
   + Stop manual when you are ready (self-explaining after you have set up your password)
 * Now you can add the securbox to fstab so that you can mount it as a normal user.
   - `http://127.0.0.1:2000/X /media/securbox davfs user,noauto 0 0`
   - the SecurStick DAV is not secured with user and password so you can simply add no user and password to the DAV secrets file: `/media/securbox                 ""            ""`
 * Now you can use `securbox` :)

#Usage
 To start `securbox`, type

     securbox start

into your commandline and enter your password. You will see some cURL progress and after that a mount (if you get timeout messages you can ignore them, it will work anyway) and a "Logged in:)" Message.
Example:

    Enter SecurBox Password:
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   814    0   814    0     0   462k      0 --:--:-- --:--:-- --:--:--  794k
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
      0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   994    0   949  100    45    183      8  0:00:05  0:00:05 --:--:--   227
    Logged in:)

If you want to close down the securbox, type:

    securbox stop

This will unmount your securbox and stop it. May you will see mount waiting for synchronsation of the cache, simply wait.
After that there is again a cURL progress and then it will be over^^
Example (with cache wait):

    /sbin/umount.davfs: waiting while mount.davfs (pid 13987) synchronizes the cache .. OK
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100   484    0   484    0     0   409k      0 --:--:-- --:--:-- --:--:--  472k

#Meta

##Background
I'm using SecurStick to carry my "top-secrect" stuff with me in my Dropbox.

The early time, I simply started the SecurStick with a ugly double-click (as if we wold be in Windows...) and then SecurStick mounts to Nautilus.

After a while I wanted to access the data from SecurStick via command line. But mounted in Nautilus that doesn't work.

Then I've searched for a possibility to mount the (web)DAV share and found davfs2. But it's very uncomfortable when you do this manually: First you have to open the FileManager, go to the SecurStick folder, double-click SecurStick, waiting the web browser to start, enter password, unmount from nautilus (neither it's unnecessery), open command line and mount.

So I've written this script.

###Problems
I've found no documentation about SecurStick command line usage so I search the hard-coded strings in the executable, as example how to disable nautilus mount and disable opening the browser. (Described at the end of the file) 

After that I found out, that you can't simply POST password and unlock SecurStick, you have to GET the index and the image first.

###ToDo
 * Password newline
 * PATH independency
 * Set up from command line

###Changelog
 * 25.11.2014
   - Initiated

##License
This Project is licensed under GPLv3 or newer. See gpl.txt for details.

##Author
(c) 2014 Christoph "criztovyl" Schulz. <ch.schulz@joinout.de>

##Links
* [GitHub Repo](https://github.com/criztovyl/securbox)
* [GitHub Author](https://github.com/criztovyl)
* [Author Website](http://joinout.de)
* [Author Blog](http://criztovyl.joinout.de)
* securbox Page (coming soon...)

#SecurStick Command line options

Here are the options I've found in SecurStick-linux. (Obvoious options are not described)

* -NoBrowser
* -NoMount
* -R: (unknown)
* -ra (unknow)
* -ServerPort: (for webDAV server)
* -Drive: (?)
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
