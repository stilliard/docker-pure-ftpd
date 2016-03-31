
Docker Pure-ftpd Server
============================

Pull down with docker:
```bash
docker pull stilliard/pure-ftpd:hardened
```

**Often needing to run as `sudo`, e.g. `sudo docker pull stilliard/pure-ftpd`**

----------------------------------------

**My advice is to extend this image to make any changes.**  
This is because rebuilding the entire docker image via a fork can be slow as it rebuilds the entire pure-ftpd package from source. 

Instead you can create a new project with a `DOCKERFILE` like so:

```
FROM stilliard/pure-ftpd

# e.g. you could change the defult command run:
CMD /usr/sbin/pure-ftpd -c 30 -C 5 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R 
```

*Then you can build your own image, `docker build --rm -t my-pure-ftp .`, where my-pure-ftp is the name you want to build as*

----------------------------------------

Starting it 
------------------------------

`docker run -d --name ftpd_server -p 21:21 -p 30000-30009:30000-30009 -e "PUBLICHOST=localhost" stilliard/pure-ftpd:hardened`

*Or for your own image, replace stilliard/pure-ftpd with the name you built it with, e.g. my-pure-ftp*

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

Tags available for different versions
--------------------------------------

**Latest versions**

- `latest` - latest working version
- `jessie-latest` - latest but will always remain on debian jessie
- `hardened` - latest + [more secure/hardened defaults](https://github.com/stilliard/docker-pure-ftpd/issues/10)

**Previous version before tags were introduced**

- `wheezy-1.0.36` - incase you want to roll back to before we started using debian jessie

**Specific pure-ftpd versions**

- `jessie-1.x.x` - jessie + specific versions, e.g. jessie-1.0.36
- `hardened-1.x.x` - hardened + specific versions

*Check the tags on github for available versions, feel free to submit issues and/or pull requests for newer versions*

Usage of specific tags: 
`sudo docker pull stilliard/pure-ftpd:hardened-1.0.36`

----------------------------------------

Our default pure-ftpd options explained
----------------------------------------

```
/usr/sbin/pure-ftpd # path to pure-ftpd executable
-c 50 # --maxclientsnumber (no more than 50 people at once)
-C 10 # --maxclientsperip (no more than 10 requests from the same ip)
-l puredb:/etc/pure-ftpd/pureftpd.pdb # --login (login file for virtual users)
-E # --noanonymous (only real users)
-j # --createhomedir (auto create home directory if it doesnt already exist)
-R # --nochmod (prevent usage of the CHMOD command)
-P $PUBLICHOST # IP/Host setting for PASV support, passed in your the PUBLICHOST env var
-p 30000:30009 # PASV port range
```

For more information please see `man pure-ftpd`, or visit: https://www.pureftpd.org/

Why so many ports opened?
---------------------------
This is for PASV support, please see: [#5 PASV not fun :)](https://github.com/stilliard/docker-pure-ftpd/issues/5)

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
