# (C) Christoph "criztovyl" Schulz
# GPLv3 or later

# Installs securbox
# Args: zenity no-sudo
#  zenity: whether to install Zenity, use 1 to do so
installSB()
{
    # Args

    [ "$1" == 1 ] && install_zenity="zenity"

    ##
    # Get Securstick download link

    # Download page
    page=`$CURL "http://www.withopf.com/tools/securstick/"`

    # Determine character encoding
    charset=`echo $page | file - --mime-encoding -b`

    # Convert and extract download link
    dl_link=`echo $page | iconv -f $charset | grep "SecurStick-linux-[[:digit:]]*\.tar" -o`

    #
    ##

    # Install packages
    sudo apt-get install davfs2 realpath curl $install_zenity

    # Add mountpoint to fstab
    sudo su -c "echo \"http://127.0.0.1:2000/X $SB_MOUNT_POINT davfs user,noauto 0 0\" >> /etc/fstab"

    # Fix davfs bug
    chmod u+s /sbin/mount.davfs

    # Add user to davfs group
    adduser $user davfs2

    # Get a temporary directory
    tmp=`mktemp -d`

    # Download SecurStick and put into temporary directory
    $CURL "$sest_dl" | tar -x -C $tmp

    # Create securbox home
    mkdir -p "$SBH"

    # Copy SecurStick there and make executable
    cp "$tmp/SecurStick-linux" "$SBH"
    chmod +x "$SBH/SecurStick-linux"

    # Ready.
}
