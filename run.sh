#!/bin/bash

# build up flags passed to this file on run + env flag for additional flags
# e.g. -e "ADDED_FLAGS=--tls=2"
PURE_FTPD_FLAGS="$@ $ADDED_FLAGS "

# start rsyslog
if [[ "$PURE_FTPD_FLAGS" == *" -d "* ]] || [[ "$PURE_FTPD_FLAGS" == *"--verboselog"* ]]
then
    echo "Log enabled, see /var/log/messages"
    rsyslogd
fi

PASSWD_FILE="/etc/pure-ftpd/passwd/pureftpd.passwd"

# Load in any existing db from volume store
if [ -e /etc/pure-ftpd/passwd/pureftpd.passwd ]
then
    pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -f "$PASSWD_FILE"
fi

# detect if using TLS (from volumed in file) but no flag set, set one
if [ -e /etc/ssl/private/pure-ftpd.pem ] && [[ "$PURE_FTPD_FLAGS" != *"--tls"* ]]
then
    echo "TLS Enabled"
    PURE_FTPD_FLAGS="$PURE_FTPD_FLAGS --tls=1 "
fi

# Add user
if [ ! -z "$FTP_USER_NAME" ] && [ ! -z "$FTP_USER_PASS" ] && [ ! -z "$FTP_USER_HOME" ]
then
    echo "Creating user..."

    # Generate the file that will be used to inject in the password prompt stdin
    PWD_FILE="$(mktemp)"
    echo "$FTP_USER_PASS
$FTP_USER_PASS" > "$PWD_FILE"
    
    # Set uid/gid
    PURE_PW_ADD_FLAGS=""
    if [ ! -z "$FTP_USER_UID" ]
    then
        PURE_PW_ADD_FLAGS="$PURE_PW_ADD_FLAGS -u $FTP_USER_UID"
    else
        PURE_PW_ADD_FLAGS="$PURE_PW_ADD_FLAGS -u ftpuser"
    fi
    if [ ! -z "$FTP_USER_GID" ]
    then
        PURE_PW_ADD_FLAGS="$PURE_PW_ADD_FLAGS -g $FTP_USER_GID"
    fi

    pure-pw useradd "$FTP_USER_NAME" -f "$PASSWD_FILE" -m -d "$FTP_USER_HOME" $PURE_PW_ADD_FLAGS < "$PWD_FILE"

    if [ ! -z "$FTP_USER_HOME_PERMISSION" ]
    then
        chmod "$FTP_USER_HOME_PERMISSION" "$FTP_USER_HOME"
        echo " root user give $FTP_USER_NAME ftp user at $FTP_USER_HOME directory has $FTP_USER_HOME_PERMISSION permission"
    fi

    rm "$PWD_FILE"
fi

# Set a default value to the env var FTP_PASSIVE_PORTS
if [ -z "$FTP_PASSIVE_PORTS" ]
then
    FTP_PASSIVE_PORTS="30000:30009"
    echo "Setting default port range to $FTP_PASSIVE_PORTS"
fi
# Set passive port range in pure-ftpd options
echo "Adding passive port range"
PURE_FTPD_FLAGS="$PURE_FTPD_FLAGS -p$FTP_PASSIVE_PORTS"

# let users know what flags we've ended with (useful for debug)
echo "Starting Pure-FTPd:"
echo "  pure-ftpd $PURE_FTPD_FLAGS"

# start pureftpd with requested flags
exec /usr/sbin/pure-ftpd $PURE_FTPD_FLAGS