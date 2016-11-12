#!/bin/bash

if [ -e /etc/pure-ftpd/passwd/pureftpd.passwd ]
then
  pure-pw mkdb /etc/pure-ftpd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd
fi

/usr/sbin/pure-ftpd "$@"
