
Docker Pure-ftpd Server
============================

Pull down with docker:
```bash
sudo docker pull stilliard/pure-ftpd
```

----------------------------------------

**My advice is to extend this image to make any changes.**  
This is because rebuilding the entire docker image via a fork can be slow as it rebuilds the entire pure-ftpd package from source. 

Instead you can create a new project with a `DOCKERFILE` like so:

```
FROM stilliard/pure-ftpd

# e.g. you could change the defult command run:
CMD /usr/sbin/pure-ftpd -c 30 -C 5 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R 
```

----------------------------------------

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

More info on usage here: https://download.pureftpd.org/pure-ftpd/doc/README.Virtual-Users


Test your connection
-------------------------
From the host machine:
```bash
ftp -p localhost 21
```

----------------------------------------

Default pure-ftpd options explained
-------------------------------------

```
/usr/sbin/pure-ftpd # path to pure-ftpd executable
-c 50 # --maxclientsnumber (no more than 50 people at once)
-C 10 # --maxclientsperip (no more than 10 requests from the same ip)
-l puredb:/etc/pure-ftpd/pureftpd.pdb # --login (login file for virtual users)
-E # --noanonymous (only real users)
-j # --createhomedir (auto create home directory if it doesnt already exist)
-R # --nochmod (prevent usage of the CHMOD command)
```

For more information please see `man pure-ftpd`, or visit: https://www.pureftpd.org/

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
https://stackoverflow.com/questions/23930167/installing-pure-ftpd-in-docker-debian-wheezy-error-421
