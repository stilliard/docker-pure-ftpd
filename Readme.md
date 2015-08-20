
Docker Pure-ftpd Server
============================

Pull down with docker:
```bash
sudo docker pull stilliard/pure-ftpd
```

Starting it 
------------------------------

`docker run -p 21:21 --name ftpd_server stilliard/pure-ftpd `

If you want to have it run in background add -d

Operating it
------------------------------

`docker exec -it ftpd_server /bin/bash`

Example usage once inside
------------------------------

Create an ftp user: `e.g. bob with chroot access only to /home/ftpusers/bob`
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


Development (via git clone)
```bash
# Clone the repo
git clone https://github.com/stilliard/docker-pure-ftpd.git
cd docker-pure-ftpd
# Build the image
make build
# Run container in background:
make run
# enter a bash shell insdie the container:
make enter
```

Credits
-------------
Thanks for the help on stackoverflow with this!
http://stackoverflow.com/questions/23930167/installing-pure-ftpd-in-docker-debian-wheezy-error-421
