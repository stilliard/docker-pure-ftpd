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
    PWD_FILE="$(mktemp)"
    echo "$FTP_USER_PASS
$FTP_USER_PASS" > "$PWD_FILE"
    pure-pw useradd "$FTP_USER_NAME" -f "$PASSWD_FILE" -m -u ftpuser -d "$FTP_USER_HOME" < "$PWD_FILE"
    rm "$PWD_FILE"
else
    echo "Please set FTP_USER_NAME, FTP_USER_PASS & FTP_USER_HOME env"
    exit 1
fi

# let users know what flags we've ended with (useful for debug)
echo "Starting Pure-FTPd:"
echo "  pure-ftpd $PURE_FTPD_FLAGS"

# start pureftpd with requested flags
exec /usr/sbin/pure-ftpd $PURE_FTPD_FLAGS
