#!/bin/bash

if [ -e /etc/pure-ftpd/passwd/pureftpd.passwd ]
then
  pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd
fi

if [ -e /etc/ssl/private/pure-ftpd.pem ]
then
    echo "Starting pure-ftp with TLS"
    TLS="--tls=1 "
fi

exec /usr/sbin/pure-ftpd "$TLS$@"
