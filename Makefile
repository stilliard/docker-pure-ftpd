.PHONY: build run

build:
	sudo docker build --rm=true -t wheezy-pure-ftp-demo .

run:
	sudo docker run -i -t -p 21:21 wheezy-pure-ftp-demo
