
FROM debian:jessie

# feel free to change this ;)
MAINTAINER Andrew Stilliard <andrew.stilliard@gmail.com>

# properly setup debian sources
ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://http.debian.net/debian jessie main\n\
deb-src http://http.debian.net/debian jessie main\n\
deb http://http.debian.net/debian jessie-updates main\n\
deb-src http://http.debian.net/debian jessie-updates main\n\
deb http://security.debian.org jessie/updates main\n\
deb-src http://security.debian.org jessie/updates main\n\
" > /etc/apt/sources.list
RUN apt-get -y update

# install package building helpers
RUN apt-get -y --force-yes --fix-missing install dpkg-dev debhelper

# install dependancies
RUN apt-get -y build-dep pure-ftpd

# build from source
RUN mkdir /tmp/pure-ftpd/ && \
	cd /tmp/pure-ftpd/ && \
	apt-get source pure-ftpd && \
	cd pure-ftpd-* && \
	./configure --with-tls && \
	sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
	dpkg-buildpackage -b -uc

# install the new deb files
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd-common*.deb
RUN apt-get -y install openbsd-inetd
RUN dpkg -i /tmp/pure-ftpd/pure-ftpd_*.deb

# Prevent pure-ftpd upgrading
RUN apt-mark hold pure-ftpd pure-ftpd-common

# setup ftpgroup and ftpuser
RUN groupadd ftpgroup
RUN useradd -g ftpgroup -d /home/ftpusers -s /dev/null ftpuser

COPY run.sh /run.sh
RUN chmod u+x /run.sh

ENV PUBLICHOST ftp.foo.com

VOLUME ["/home/ftpusers", "/etc/pure-ftpd/passwd"]


# Secure defaults, ref: https://github.com/stilliard/docker-pure-ftpd/issues/10
RUN cd /etc/pure-ftpd/conf/ && \
	echo "yes" | tee AntiWarez ChrootEveryone CreateHomeDir CustomerProof Daemonize DontResolve IPV4Only NoAnonymous NoChmod NoRename ProhibitDotFilesRead ProhibitDotFilesWrite && \
	echo "no" | tee AllowAnonymousFXP AllowDotFiles AllowUserFXP AnonymousCanCreateDirs AnonymousCantUpload AnonymousOnly AutoRename BrokenClientsCompatibility CallUploadScript DisplayDotFiles IPV6Only KeepAllFiles LogPID NATmode PAMAuthentication UnixAuthentication VerboseLog


# startup
CMD /run.sh -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30009

EXPOSE 21 30000-30009

