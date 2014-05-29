
Docker Pure-ftpd Server
============================

Pull to docker:
```bash
sudo docker pull stilliard/pure-ftpd
```

Or via git clone:
```bash
# Clone the repo
git clone https://github.com/stilliard/docker-pure-ftpd.git
# Build the image
make build
# Run as a container:
make run
```

Once inside
---------------

Create an ftp user: `e.g. bob with access only to /home/ftpusers/bob`
```bash
pure-pw useradd bob -u ftpuser -d /home/ftpusers/bob
pure-pw mkdb
```
*No restart should be needed.*

More info on usage here:

- http://download.pureftpd.org/pure-ftpd/doc/README.Virtual-Users
- http://www.debianhelp.co.uk/pureftp.htm


Test your connection
-------------------------
From the host machine:
```bash
ftp -p localhost 21
```

----------------------------------------

By default the server is already started, but you can stop it:
```bash
killall -9 pure-ftpd
```

And restart it:
```bash
/usr/sbin/pure-ftpd -c 30 -C 1 -l puredb:/etc/pure-ftpd/pureftpd.pdb -x -E -j -R &
```

----------------------------------------

Credits
-------------
Thanks for the help on stackoverflow with this!
http://stackoverflow.com/questions/23930167/installing-pure-ftpd-in-docker-debian-wheezy-error-421
