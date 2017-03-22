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

# Load in any existing db from volume store
if [ -e /etc/pure-ftpd/passwd/pureftpd.passwd ]
then
    pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd
fi

# detect if using TLS (from volumed in file) but no flag set, set one
if [ -e /etc/ssl/private/pure-ftpd.pem ] && [[ "$PURE_FTPD_FLAGS" != *"--tls"* ]]
then
    echo "TLS Enabled"
    PURE_FTPD_FLAGS="$PURE_FTPD_FLAGS --tls=1 "
fi

# let users know what flags we've ended with (useful for debug)
echo "Starting Pure-FTPd:"
echo "  pure-ftpd $PURE_FTPD_FLAGS"

# start pureftpd with requested flags
exec /usr/sbin/pure-ftpd $PURE_FTPD_FLAGS
