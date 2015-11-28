# (C) Christoph "criztovyl" Schulz
# GPLv3 or later

# ToDO:
# - do not simply download the newest SecurStick due to possible incompatibility.
#   Include some kind of test that determines a fallback version for that.

# Defaults
DEFAULT_SBDD="$HOME/.securbox"
DEFAULT_SB_MOUNT_POINT="/media/securbox"

# Installs securbox
# Args: zenity no-sudo
#  zenity: whether to install Zenity, use 1 to do so
#  no-sudo: disable sudo by setting this to 1.
#  sbdd: securbox data directory, defaults to "~/.securbox". Use - to ask user.
installSB()
{

    trap "exit" SIGINT

    # Args

    [ "$1" == 1 ] && install_zenity="zenity"
    [ "$2" == 1 ] && SUDO="" || SUDO="sudo"
    [ "$3" == "-" ] && read -p "Enter securbox home directory [$HOME/.securbox]: " SBDD
    [ -z "$3" ] && SBDD=$DEFAULT_SBDD

    [ -z "$USERNAME" ] && USERNAME=$USER

    # securbox mount point
    SB_MOUNT_POINT=`cat securbox | grep "SB_MOUNT_POINT=[^\\\`]" |sed "s/SB_MOUNT_POINT=\(.\+\)/\1/"`
    [ -z "$SB_MOUNT_POINT" ] && SB_MOUNT_POINT=$DEFAULT_SB_MOUNT_POINT

    [ ! -d "$SB_MOUNT_POINT" ] && $SUDO mkdir -p $SB_MOUNT_POINT


    ##
    # Get Securstick download link

    # Download page
    page=`curl -s "http://www.withopf.com/tools/securstick/"`

    # Determine character encoding
    charset=`echo $page | file - --mime-encoding -b`

    # Convert and extract download link
    dl_link=`echo $page | iconv -f $charset | grep "SecurStick-linux-[[:digit:]]*\.tar" -o`

    #
    ##

    # Install packages
    $SUDO apt-get install davfs2 realpath curl $install_zenity

    # Add mountpoint to fstab
    $SUDO su -c "echo \"http://127.0.0.1:2000/X $SB_MOUNT_POINT davfs user,noauto 0 0\" >> /etc/fstab"

    # Fix davfs bug
    $SUDO chmod u+s /sbin/mount.davfs

    # Add user to davfs group
    $SUDO adduser $USERNAME davfs2

    # Add "secrets" to davfs secrets file
    secretsFile="~/.davfs2/secrets"
    line='http://127.0.0.1:2000/X "" ""'
    [ -f $secretsFile ] && [ `cat $secretsFile | grep "$line" | wc -l` -lt 1 ] && echo $line >> $secretsFile

    # Get a temporary directory
    tmp=`mktemp -d`
    mkdir -p $tmp

    # Download SecurStick and put into temporary directory
    curl "$sest_dl" | tar -x -C $tmp

    # Create securbox home
    mkdir -p "$SBDD"

    # Copy SecurStick there and make executable
    cp "$tmp/SecurStick-linux" "$SBDD"
    chmod +x "$SBDD/SecurStick-linux"

    #Configure

    # Ready.
    echo "Install and configure finished. As you need to be in the davfs2 user group you've been added to it. Please logout and login again to finish group allocation."
}
installSB $@
